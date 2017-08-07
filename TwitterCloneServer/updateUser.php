<?php
/**
 * Created by PhpStorm.
 * User: madhusudhanb.r
 * Date: 8/7/17
 * Time: 5:04 PM
 */

$returnArry = array();

$username = htmlentities($_REQUEST["username"]);
$id = htmlentities($_REQUEST["id"]);
$email = htmlentities($_REQUEST["email"]);
$fullname = htmlentities($_REQUEST["fullname"]);

//securing info and storing it in variables
if(empty($username) || empty($id) || empty($email) || empty($fullname)){
    $returnArry["status"] = "400";
    $returnArry["message"] = "missing information";
    echo json_encode($returnArry);
    return;
}

$file = parse_ini_file("../../../TwitterClone.ini");

$host = trim($file["dbhost"]);
$user = trim($file["dbuser"]);
$pass = trim($file["dbpass"]);
$name = trim($file["dbname"]);

require ('Secure/Access.php');

$access = new Access($host,$user,$pass,$name);
$access->connect();


$result = $access->updateUser($username,$email,$fullname,$id);

if(!empty($result)){
    $user = $access->getUserViaId($id);
    $returnArry["status"] = "200";
    $returnArry["message"] = "Success updated user to the database";
    $returnArry["id"] = $user["id"];
    $returnArry["username"] = $user["username"];
    $returnArry["email"] = $user["email"];
    $returnArry["fullname"] = $user["fullname"];
    $returnArry["ava"] = $user["ava"];
} else {
    $returnArry["status"] = "400";
    $returnArry["message"] = "couldnt update information";
}

$access->disconnect();

echo json_encode($returnArry);



?>


