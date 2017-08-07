<?php
/**
 * Created by PhpStorm.
 * User: madhusudhanb.r
 * Date: 8/5/17
 * Time: 11:13 AM
 */

$file = parse_ini_file("../../../TwitterClone.ini");

$host = trim($file["dbhost"]);
$user = trim($file["dbuser"]);
$pass = trim($file["dbpass"]);
$name = trim($file["dbname"]);

require ('Secure/Access.php');

$access = new Access($host,$user,$pass,$name);
$access->connect();


if(!empty($_REQUEST["uuid"] && !empty($_REQUEST["text"]) )){
    $uuid = $_REQUEST["uuid"];
    $id = $_REQUEST["id"];
    $text = $_REQUEST["text"];

    $folder = "/Applications/XAMPP/xamppfiles/htdocs/TwitterClone/posts/" . $id;

    if(!file_exists($folder)) {
        mkdir($folder,0777,true);
    }

    $folder = $folder . "/" . basename($_FILES["file"]["name"]);
    //$returnArray = array();
    if(move_uploaded_file($_FILES["file"]["tmp_name"],$folder)){
        $returnArray["message"] = "File was uploaded";
        $path = "http://localhost/TwitterClone/posts/". $id . "/post-" . $uuid . ".jpg";
    }
    else {
        $returnArray["message"] = "File wasn't uploaded";
        $path = "";
    }

    $access->insertposts($id,$uuid,$text,$path);

} else if (!empty($_REQUEST["uuid"]) && empty($_REQUEST["id"])) {

    // STEP 2.1 Get uuid of post and path to post picture passed to this php file via swift POST
    $uuid = htmlentities($_REQUEST["uuid"]);
    $path = htmlentities($_REQUEST["path"]);

    // STEP 2.2 Delete post according to uuid
    $result = $access->deletePostUsingUUID($uuid);

    if (!empty($result)) {
        $returnArray["message"] = "Successfully deleted";
        $returnArray["result"] = $result;


        // STEP 2.3 Delete file according to its path and if it exists
        if (!empty($path)) {

            // /Applications/XAMPP/xamppfiles/htdocs/Twitter/posts/46/image.jpg
            $path = str_replace("http://localhost/", "/Applications/XAMPP/xamppfiles/htdocs/", $path);

            // file deleted successfully
            if (unlink($path)) {
                $returnArray["status"] = "1000";
                // could not delete file
            } else {
                $returnArray["status"] = "400";
            }
        }


    }
}



else {
    $id = $_REQUEST["id"];
  $posts = $access->selectPosts($id);
  if(!empty($posts)){
      $returnArray["posts"] = $posts;
  }

}

$access->disconnect();

echo json_encode($returnArray);