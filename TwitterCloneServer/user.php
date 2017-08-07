<?php
/**
 * Created by PhpStorm.
 * User: madhusudhanb.r
 * Date: 8/7/17
 * Time: 12:53 AM
 */


$file = parse_ini_file("../../../TwitterClone.ini");

$host = trim($file["dbhost"]);
$user = trim($file["dbuser"]);
$pass = trim($file["dbpass"]);
$name = trim($file["dbname"]);

require ('Secure/Access.php');

$access = new Access($host,$user,$pass,$name);
$access->connect();

$word = null;
$username = htmlentities($_REQUEST["username"]);

if(!empty($_REQUEST["word"])){
    $word = $_REQUEST["word"];
}

$users = $access->selectUsers($word,$username);

if(!empty($users)){
    $returnArray["users"] = $users;
} else {
    $returnArray["message"] = "Couldn't find user";
}

$access->disconnect();

echo  json_encode($returnArray);

?>