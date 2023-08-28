#!/usr/bin/env php

<?php
$version = '1.0';

echo "Subtitle Extractor version " . $version . ", (c) 2019 by EspLab.\n\n";

if ($argc <= 1) {
   echo "Usage: " . basename($argv[0]) . " filename\n\n";
   exit;
}


for ($args = 1; $args < $argc; $args++) {
   $file = $argv[$args];
   $filename = "";
   $subs = null;
   $params = '';
   $ex = 'on';
   $default_langs = [ 'gre', 'ell', ];
   $command = "ffprobe -loglevel error -select_streams s -show_entries stream=index,codec_name:stream_tags=language -of csv=p=0 ";

   if (file_exists($file)) {

      exec($command . '"' . $file . '"', $subs, $ret);

		$found = false;

      foreach ($subs as $key => $value) {
      	
         $val = explode(',', $value);
         $of = 'off ';

         if ( in_array( $val[2], $default_langs) && !$found) {
            $of = 'on ';
            $ex = 'off';
            $found = true;
         }

         $params = $params . $key . ' "' . $val[2] . ' (' . $val[1] . ')" ' . $of;
      }
   } else {
      echo "File " . $file . " does not exist.\n";
      exec('kdialog --error "File <b>' . $file . '</b> does not exist."');
      exit(9);
   }

   $sub = [];
   $ret = null;

   $dialog = 'kdialog --title "Subtitle Extractor" --checklist="Select Subtitle to Extract from : \n' . basename($file) . '" ';

   exec($dialog . $params, $sub, $ret);

   if (count($sub) > 0) {

      $langs = explode(" ", $sub[0]);
      $ex_langs = [];

      if ($ret == 0) {

         foreach ($langs as $lang) {
            $v = $lang;
            $v = str_replace('"', "", $v);
            $v = str_replace("''", "", $v);

            $ll = explode(',', $subs[(int) $v]);

            $ex_langs[] = ["id" => $ll[0], "format" => $ll[1], "language" => $ll[2]];
         }


         $path_parts = pathinfo($file);
         $filename = $path_parts['filename'];

         $lang_count = count($ex_langs);

         if ($lang_count > 0) {
            foreach ($ex_langs as $ex_lang) {

               $id = $ex_lang["id"];

               $format = '.' . $ex_lang["format"];

               if ($format === '.subrip') {
                  $format = ".srt";
               }


               if ($lang_count > 1) {
                  $language = '.' . $ex_lang["language"];
               } else {
                  $language = '';
               }

               $loglevel = ' -loglevel warning -hide_banner -stats';

               $input = ' -i "' . $file . '"';



               $output = ' "' . $filename . $language . $format . '"';

               $extract_command = 'ffmpeg -y' . $loglevel . $input . ' -c copy -map 0:' . $id . $output;

			   if ($format === '.mov_text') {
			  	$format = ".srt";
			  	 $output = ' "' . $filename . $language . $format . '"';
				$extract_command = 'ffmpeg -y' . $loglevel . $input . ' -c text -map 0:' . $id . $output;
			   }
               

               echo "\n" . $extract_command . "\n";
               exec($extract_command);

			   $msgd = "";	
               if($format==='.ass'){
               	$convert_command = "~/bin/ffass2srt $output";
               	exec($convert_command);
               	$msgd= addslashes("\nDone converting to srt");				
               }

			   $msg = addslashes("Done extracting subtitles from:\n ".basename($file).$msgd);		
			   
               $command = "kdialog --title \"Subtitle Extractor\" --passivepopup \"" . $msg . "\" 10";

               exec($command);

				
					
               //  if($format=='.ass'){
               //     $converted_output = ' "' . $filename . $language . '.srt' . '"';
               //     $convert_command = "ffmpeg -i $output $converted_output";

               //    //  echo $convert_command;

               //    exec($convert_command);
               //  }
            }
         }
         // var_dump($ex_langs);
      } else if ($ret == 1) {
         echo "Canceled!";
      }
   }
   //ffmpeg -i Movie.mkv -c copy -map 0:s:0 subs.01.srt -c copy -map 0:s:1 subs.02.srt

}

exec('kdialog --title "Subtitle Extractor" --passivepopup "All Jobs Done." 15');
