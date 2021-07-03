#!/usr/bin/env php

<?php
$version = '1.0b';


<?php

namespace Pecee\Service;

class Exception extends \Exception
{ }

class Response implements \JsonSerializable
{
    /**
     * Response array
     *
     * @var array
     */
    protected $response;

    /**
     * Method
     *
     * @var string
     */
    protected $method;

    /**
     * Constructor
     *
     * @param string $method
     * @param array $response
     */
    public function __construct($method, $response)
    {
        $this->method = $method;
        $this->response = $response;
    }

    /**
     * Return response as array
     *
     * @return array
     */
    public function toArray()
    {
        return $this->response;
    }

    /**
     * Specify data which should be serialized to JSON
     * @link http://php.net/manual/en/jsonserializable.jsonserialize.php
     * @return mixed data which can be serialized by <b>json_encode</b>,
     * which is a value of any type other than a resource.
     * @since 5.4.0
     */
    public function jsonSerialize()
    {
        return $this->toArray();
    }
}


class OpenSubtitles
{
    /**
     * Endpoint
     *
     * @var string
     */
    const SERVICE_ENDPOINT = 'http://api.opensubtitles.org/xml-rpc';

    /**
     * Useragent
     *
     * @var string
     * @link https://trac.opensubtitles.org/projects/opensubtitles/wiki/DevReadFirst
     */
    protected $userAgent = 'OSTestUserAgent';

    /**
     * Language (ISO639-1)
     *
     * @var string
     */
    protected $language = 'en';

    /**
     * Username
     *
     * @var string
     */
    protected $username;

    /**
     * Password
     *
     * @var string
     */
    protected $password;

    /**
     * Token
     *
     * @var string
     */
    protected $token;

    /**
     * Create client instance
     *
     * @param  array $options
     * @return static
     * @throws Exception
     */
    public static function create(array $options)
    {
        return new static($options);
    }

    /**
     * Constructor
     *
     * @param array $options
     * @throws Exception
     */
    protected function __construct(array $options)
    {
        foreach ($options as $option => $value) {
            $this->{$option} = $value;
        }

        if ($this->username === null || $this->password === null) {
            throw new Exception('Missing username or password');
        }
    }

    /**
     * Destructor
     */
    public function __destruct()
    {
        if ($this->token !== null) {
            $this->logOut($this->token);
        }
    }

    /**
     * Obtain token
     *
     * @return string
     */
    public function obtainToken()
    {
        if ($this->token !== null) {
            return $this->token;
        }
        $response = $this->logIn(
            $this->username,
            $this->password,
            $this->language,
            $this->userAgent
        )->toArray();

        $this->token = $response['token'];

        return $this->token;
    }

    /**
     * Build XML-RPC request
     *
     * @param  string $method
     * @param  array $params
     * @return string
     */
    public function buildRequest($method, array $params = [])
    {
        $request = xmlrpc_encode_request($method, $params, [
            'encoding' => 'UTF-8',
        ]);

        return $request;
    }

    /**
     * Send XML-RPC request
     *
     * @param  string $request
     * @return array
     * @throws Exception
     */
    public function sendRequest($request)
    {
        $context = stream_context_create([
            'http' => [
                'method'  => 'POST',
                'header'  => 'Content-Type: text/xml',
                'content' => $request,
            ],
        ]);
        $file = file_get_contents(static::SERVICE_ENDPOINT, false, $context);
        $response = xmlrpc_decode($file, 'UTF-8');
        if (is_array($response) && xmlrpc_is_fault($response)) {
            throw new Exception($response['faultString'], $response['faultCode']);
        }
        if (empty($response['status']) || $response['status'] !== '200 OK') {
            throw new Exception('Invalid response status');
        }

        return $response;
    }

    /**
     * Call API method
     *
     * @param  string $method
     * @param  array $params
     * @return Response
     * @throws Exception
     */
    public function __call($method, array $params = [])
    {
        $method = ucfirst($method);
        if (!in_array($method, [
            'ServerInfo',
            'LogIn',
            'LogOut',
        ], true)) {
            $token = $this->obtainToken();
            array_unshift($params, $token);
        }
        $request = $this->buildRequest($method, $params);
        $response = $this->sendRequest($request);

        return new Response($method, $response);
    }

    protected function readUINT64($handle)
    {
        $u = unpack("va/vb/vc/vd", fread($handle, 8));
        return array(0 => $u["a"], 1 => $u["b"], 2 => $u["c"], 3 => $u["d"]);
    }

    protected function addUINT64($a, $b)
    {
        $o = array(0 => 0, 1 => 0, 2 => 0, 3 => 0);

        $carry = 0;
        for ($i = 0; $i < 4; $i++) {
            if (($a[$i] + $b[$i] + $carry) > 0xffff) {
                $o[$i] += ($a[$i] + $b[$i] + $carry) & 0xffff;
                $carry = 1;
            } else {
                $o[$i] += ($a[$i] + $b[$i] + $carry);
                $carry = 0;
            }
        }

        return $o;
    }

    protected function UINT64FormatHex($n)
    {
        return sprintf("%04x%04x%04x%04x", $n[3], $n[2], $n[1], $n[0]);
    }

    public function calcHash($file)
    {
        $handle = fopen($file, "rb");
        $fsize = filesize($file);

        $hash = array(
            3 => 0,
            2 => 0,
            1 => ($fsize >> 16) & 0xFFFF,
            0 => $fsize & 0xFFFF
        );

        for ($i = 0; $i < 8192; $i++) {
            $tmp = $this->readUINT64($handle);
            $hash = $this->addUINT64($hash, $tmp);
        }

        $offset = $fsize - 65536;
        fseek($handle, $offset > 0 ? $offset : 0, SEEK_SET);

        for ($i = 0; $i < 8192; $i++) {
            $tmp = $this->readUINT64($handle);
            $hash = $this->addUINT64($hash, $tmp);
        }

        fclose($handle);
        return $this->UINT64FormatHex($hash);
    }
}
