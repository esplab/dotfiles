#!/usr/bin/env php
<?php

if ($argc <= 1) {
    echo "Please give your projects path.\n";
    exit(1);
}

$path = realpath($argv[1]);

if (!file_exists($argv[1]."/artisan")) {
    echo "Artisan command not found to given path.\n";
    exit(2);
}

require $path.'/vendor/autoload.php';
$app = require_once $path.'/bootstrap/app.php';

use Illuminate\Container\Container;
use Illuminate\Database\Eloquent\Model;
use App\Http\Controllers\Controller;
use Illuminate\Support\Collection;
use Illuminate\Filesystem\Filesystem;
use Illuminate\Support\Facades\Route;

function getModels(): Collection
{
    $filesystem = new Filesystem();
    
    $models = collect($filesystem->allFiles(app_path()))
    ->map(function ($item) {
        $path = $item->getRelativePathName();
        $class = sprintf('\%s%s', Container::getInstance()->getNamespace(), strtr(substr($path, 0, strrpos($path, '.')), '/', '\\'));
        return $class;
    })
    ->filter(function ($class) {
        $valid = false;
        
        if (class_exists($class)) {
            $reflection = new \ReflectionClass($class);
            $valid = $reflection->isSubclassOf(Model::class) && !$reflection->isAbstract();
        }
        
        return $valid;
    });
    
    return $models->values();
}


function getControllers(): Collection
{
    $filesystem = new Filesystem();
    
    $controllers = collect($filesystem->allFiles(app_path()))
    ->map(function ($item) {
        $path = $item->getRelativePathName();
        $class = sprintf('\%s%s', Container::getInstance()->getNamespace(), strtr(substr($path, 0, strrpos($path, '.')), '/', '\\'));
        return $class;
    })
    ->filter(function ($class) {
        $valid = false;
        
        if (class_exists($class)) {
            $reflection = new \ReflectionClass($class);
            $valid = $reflection->isSubclassOf(Controller::class) && !$reflection->isAbstract();
        }
        
        return $valid;
    });
    
    return $controllers->values();
}

function getControllerActions($controller, $inherited = false)
{
    $reflector = new ReflectionClass($controller);
    $actionNames = array();
    $lowerControllerName = str_replace('\app', 'app', strtolower($controller));

    foreach ($reflector->getMethods(ReflectionMethod::IS_PUBLIC) as $action) {
        if ($inherited) {
            $actionNames[] = $action->name;
        } elseif (strtolower($action->class) == $lowerControllerName) {
            $actionNames[] = $action->name;
        }
    }

    return collect($actionNames)->values();
}




$routes = $app->routes->getRoutes();


dd($routes);
