#!/usr/bin/env php
<?php

$tel = '/\+?\d{1,4}?[-.\s]?\(?\d{1,3}?\)?[-.\s]?\d{1,4}[-.\s]?\d{1,4}[-.\s]?\d{1,9}/';
$email = '/([A-Z|a-z|0-9](\.|_){0,1})+[A-Z|a-z|0-9]\@([A-Z|a-z|0-9])+((\.){0,1}[A-Z|a-z|0-9]){2}\.[a-z]{2,3}/';

// preg_match_all($re, $str, $matches, PREG_SET_ORDER, 0);

// Print the entire match result
// var_dump($matches);

$all = [];

foreach (new DirectoryIterator('.') as $fileInfo) {
    $emails = [];
    $telephone = [];

    if ($fileInfo->isDot()) {
        continue;
    }

    $filename = $fileInfo->getFilename();
    $file = file_get_contents($filename);

    preg_match_all($tel, $file, $matches, PREG_SET_ORDER, 0);

    if ($matches) {
        foreach ($matches as $match) {
            if (strlen($match[0]) > 5) {
                $telephones[] = $match[0];
            }
        }
    }

    preg_match_all($email, $file, $matches, PREG_SET_ORDER, 0);

    if ($matches) {
        foreach ($matches as $match) {
            if (strlen($match[0]) > 2 && $match[0] != 'booking@charterayacht.gr') {
                $emails[] = $match[0];
            }
        }
    }

    $p = "";
    $m = "";

    preg_match_all($tel, $filename, $tels, PREG_PATTERN_ORDER, 0);

    if (count($tels)>1) {
        $telephones[] = $tels[0][0];
    }

    $telephones = array_unique($telephones);
    $emails = array_unique($emails);

    // if (count($telephones) > 1) {
    //     $p = implode(', ', $telephones);
    // }

    // if (count($emails) > 1) {
    //     $m = implode(', ', $emails);
    // }

    // echo $filename . "; ";
    // echo trim($p, ',') . "; ";
    // echo trim($m, ',');
    // echo "\n";

    $filename_name = "";
    $filename_phone = "";
    

    $all[]=[
        "filename" => $filename,
        "filename_name" => $filename_name,
        "filename_phone" => $filename_phone,
        "emails" => array_values($emails),
        "phones" => array_values($telephones)
    ];
}

echo json_encode($all);
