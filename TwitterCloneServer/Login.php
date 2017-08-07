<?php
/**
 * Created by PhpStorm.
 * User: madhusudhanb.r
 * Date: 8/2/17
 * Time: 11:37 AM
 */

$username = htmlentities($_REQUEST["username"]);
$password = htmlentities($_REQUEST["password"]);
$returnArray = array();

if (empty($username) || empty($password)){
    $returnArray["status"] = "400";
    $returnArray["message"] = "Username or password empty";
    echo json_encode($returnArray);
    return;

}

//Build connection

$file = parse_ini_file("../../../TwitterClone.ini");

$host = trim($file["dbhost"]);
$user = trim($file["dbuser"]);
$pass = trim($file["dbpass"]);
$name = trim($file["dbname"]);

require ('Secure/Access.php');

$access = new Access($host,$user,$pass,$name);
$access->connect();

$user = $access->getUser($username);

if(empty($user)){
    $returnArray["status"] = "403";
    $returnArray["message"] = "missing user";
    echo json_encode($returnArray);
    return;
}

//get password and salt from db

$secure_passord = $user["password"];
$salt = $user["salt"];

if ($secure_passord == sha1($password . $salt)){
    $returnArray["status"] = "200";
    $returnArray["message"] = "Logged in  user";
    $returnArray["id"] = $user["id"];
    $returnArray["username"] = $user["username"];
    $returnArray["email"] = $user["email"];
    $returnArray["ava"] = $user["ava"];
    $returnArray["fullname"] = $user["fullname"];


} else {
    $returnArray["status"] = "403";
    $returnArray["message"] = "passwords do not  match";

}

$access->disconnect();

echo  json_encode($returnArray);

