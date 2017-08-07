<?php
/**
 * Created by PhpStorm.
 * User: madhusudhanb.r
 * Date: 8/3/17
 * Time: 9:53 PM
 */

if(empty($_POST["id"])){
    $returnArray["status"] = "403";
    $returnArray["message"] = "Missing information";
    echo json_encode($returnArray);
    return ;
}

$id = htmlentities($_POST["id"]);

$folder = "/Applications/XAMPP/xamppfiles/htdocs/TwitterClone/ava/" . $id;

if(!file_exists($folder)){
    mkdir($folder,0777,true);
}

$folder = $folder . "/" . basename($_FILES["file"]["name"]);

if(move_uploaded_file($_FILES["file"]["tmp_name"],$folder)){
    $returnArray["status"] = "200";
    $returnArray["message"] = "upload done ";

} else {
    $returnArray["status"] = "300";
    $returnArray["message"] = "unable to upload";
    echo json_encode($returnArray);
    return ;
}

$file = parse_ini_file("../../../TwitterClone.ini");

$host = trim($file["dbhost"]);
$user = trim($file["dbuser"]);
$pass = trim($file["dbpass"]);
$name = trim($file["dbname"]);

require ('Secure/Access.php');

$access = new Access($host,$user,$pass,$name);
$access->connect();

$path = "http://localhost/TwitterClone/ava/" .$id."/ava.jpg";

$success = $access->updateAva($path,$id);

$user = $access->getUserViaId($id);


$returnArray["id"] = $user["id"];
$returnArray["username"] = $user["username"];
$returnArray["email"] = $user["email"];
$returnArray["ava"] = $user["ava"];
$returnArray["fullname"] = $user["fullname"];

$access->disconnect();

echo json_encode($returnArray);
