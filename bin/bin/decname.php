#!/usr/bin/env php
<?php

if ($argc < 1) {
    exit(1);
}

array_shift($argv);

foreach ($argv as $ff) {
    $command = '/usr/bin/guessit -j -s "' . $ff . '"';

    $out = null;
    
    exec($command, $out, $ret);

    if ($ret == 0) {
        $filename_parts = json_decode($out[0], true);

        $name = ucwords(str_replace("-", " ", $filename_parts['title'])) . " ";

        if (array_key_exists("year", $filename_parts)) {
            $year = "(" . $filename_parts["year"] . ") ";
        } else {
            $year = "";
        }

        if (array_key_exists("country", $filename_parts)) {
            if ($filename_parts["country"] == 'UNITED STATES') {
                $country = "(US) ";
            } elseif ($filename_parts["country"] == 'UNITED KINGDOM') {
                $country = "(UK) ";
            } else {
                $country = "";
            }
        } else {
            $country = "";
        }

        if (array_key_exists("season", $filename_parts)) {
            $season = $filename_parts['season'];
        } else {
            $season = "";
        }

        if (array_key_exists("episode", $filename_parts)) {
            $episode = "x" . sprintf("%02u", $filename_parts['episode']);
        } else {
            $episode = "";
        }

        if (array_key_exists("episode_title", $filename_parts)) {
            $title = "- " . $filename_parts['episode_title'];
        } else {
            $title = "";
        }

        if (array_key_exists("container", $filename_parts)) {
            $ext = "." . $filename_parts['container'];
        } else {
            $ext = "";
        }
    
        $title = str_replace("PHOENiX TRUMP XLF", "", $title);
        $title = str_replace("SVA-AVS", "", $title);
        $title = str_replace("SVA", "", $title);
        $title = str_replace("KILLERS", "", $title);
        $title = str_replace("TBS", "", $title);
        $title = str_replace("XLF", "", $title);
        $title = str_replace("CONVOY", "", $title);
        $title = str_replace("MTB", "", $title);
    
        $title = " " . trim($title);

        $filename = trim(ucfirst($name . $country . $year . $season . $episode . $title)) . $ext;

        // echo $filename."\n";

        $outk= null;

        exec("kdialog --title \"Fix Filename\" --inputbox \"New Filename for:\n" . basename($ff) . "\" \"" . $filename . "\"", $outk, $retk);

        if ($retk == 0) {
            exec('mv "' . $ff . '" "' . $outk[0] . '"');
        };
    }
}
