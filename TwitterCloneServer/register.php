<?php
/**
 * Created by PhpStorm.
 * User: madhusudhanb.r
 * Date: 7/26/17
 * Time: 1:35 PM
 */

$username = htmlentities($_REQUEST["username"]);
$password = htmlentities($_REQUEST["password"]);
$email = htmlentities($_REQUEST["email"]);
$fullname = htmlentities($_REQUEST["fullname"]);

//securing info and storing it in variables
if(empty($username) || empty($password) || empty($email) || empty($fullname)){
    $returnArry["status"] = "400";
    $returnArry["message"] = "missing information";
    echo json_encode($returnArry);
    return;
}

$salt = openssl_random_pseudo_bytes(20);
$secure_password = sha1($password.$salt);

//Build connection

$file = parse_ini_file("../../../TwitterClone.ini");

$host = trim($file["dbhost"]);
$user = trim($file["dbuser"]);
$pass = trim($file["dbpass"]);
$name = trim($file["dbname"]);

require ('Secure/Access.php');

$access = new Access($host,$user,$pass,$name);
$access->connect();

$result = $access->registerUser($username,$secure_password,$salt,$email,$fullname);

if ($result){
    $user = $access->getUser($username);
    $resultArray["status"] = "200";
    $resultArray["message"] = "Success registering user to the database";
    $resultArray["id"] = $user["id"];
    $resultArray["username"] = $user["username"];
    $resultArray["email"] = $user["email"];
    $resultArray["fullname"] = $user["fullname"];
    $resultArray["ava"] = $user["ava"];
}
else
{
$resultArray["status"] = "400";
$resultArray["message"] = "Failure registering user to the database";

}

$access->disconnect();

echo  json_encode($resultArray);

?>
