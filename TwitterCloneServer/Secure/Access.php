<?php

class access
{
    var $host = null;
    var $user = null;
    var $password = null;
    var $name = null;
    var $conn = null;
    var $result = null;

    function __construct($dbhost, $dbuser, $dbpassword, $dbname)
    {
        $this->host = $dbhost;
        $this->user = $dbuser;
        $this->password = $dbpassword;
        $this->name = $dbname;
    }

    public function connect()
    {
        $this->conn = mysqli_connect($this->host,$this->user,$this->password,$this->name);
        if(mysqli_connect_error()){
        echo  "Couldn't connect to the database ";
        return;
        }
//        echo "connected";
        $this->conn->set_charset("utf8");

    }

    public function disconnect(){
        if ($this->conn != null){
            mysqli_close($this->conn);
            //echo "Disconnected</br>";
        }
    }

    public function registerUser($username,$password,$salt,$email,$fullname){

        $sql = "Insert into users SET username=?, password=?, salt=?, email=?, fullname =?";
        $statement = $this->conn->prepare($sql);

        if(!$statement){
            throw new Exception($statement->error);
            return;
        }

        $statement->bind_param("sssss",$username,$password,$salt,$email,$fullname);

        $returnValue = $statement->execute();

        return $returnValue;
    }

    public function getUser($username){
        $resultArray = array();
        $sql = "Select * from users where username='".$username."'";
        $result = $this->conn->query($sql);

        if($result != null && (mysqli_num_rows($result) >= 1)){

            $row = $result->fetch_array(MYSQLI_ASSOC);
            if(!empty($row)){
                $resultArray = $row;
            }
        }

        return $resultArray;
    }

    public function getUserViaId($id){
        $resultArray = array();
        $sql = "Select * from users where id='".$id."'";
        $result = $this->conn->query($sql);

        if($result != null && (mysqli_num_rows($result) >= 1)){

            $row = $result->fetch_array(MYSQLI_ASSOC);
            if(!empty($row)){
                $resultArray = $row;
            }
        }

        return $resultArray;
    }

    public function updateAva($path,$id) {
        $resultArray = array();
        $sql = "Update users Set ava = ? where id = ?";
        $statement = $this->conn->prepare($sql);
        if(!$statement){
            throw new Exception($statement->error);
            return;
        }

        $statement->bind_param("si",$path,$id);

        $resultArray = $statement->execute();

        return $resultArray;
    }


    public function insertposts($id,$uuid,$text,$path){

        $sql = "INSERT INTO posts SET id=?, uuid=?, text=?, path=?";
        $statement = $this->conn->prepare($sql);

        if(!$statement){
            throw new Exception($statement->error);
            return;
        }

        $statement->bind_param("isss",$id,$uuid,$text,$path);

        $resultArray = $statement->execute();

        return $resultArray;
    }

    public function selectPosts($id){
        $sql = "SELECT posts.id,
        posts.uuid,
        posts.text,
        posts.path,
        posts.date,
        users.id,
        users.username,
        users.email,
        users.fullname,
        users.ava 
        FROM TwitterClone.posts JOIN TwitterClone.users ON posts.id = $id AND users.id = $id ORDER BY date DESC";


        $statement = $this->conn->prepare($sql);

        if(!$statement){
            throw new Exception($statement->error);
            return ;
        }

        $statement->execute();
        $result = $statement->get_result();

        while($row = $result->fetch_assoc()){

            $returnArray[] = $row;
        }

        return $returnArray;
    }


    public function deletePostUsingUUID($uuid){
        $sql = "DELETE FROM posts WHERE uuid = ?";

        // prepare to be executed after binded params in place of ?
        $statement = $this->conn->prepare($sql);

        // error occured while preparation or sql statement
        if (!$statement) {
            throw new Exception($statement->error);
        }

        // bind param in place of ? and assign var
        $statement->bind_param("s", $uuid);
        $statement->execute();

        // assign numb of affected rows to $returnValue, to see did deleted or not
        $returnValue = $statement->affected_rows;

        return $returnValue;
    }

    public function selectUsers($word, $username) {

        // var to store all returned inf from db
        $returnArray = array();

        // sql statement to be executed if not entered word
        $sql = "SELECT id, username, email, fullname, ava FROM users WHERE NOT username = '".$username."'";

        // if word entered alter sql statement for wider search
        if (!empty($word)) {
            $sql .= " AND ( username LIKE ? OR fullname LIKE ? )";
        }

        // prepare to be executed as soon as vars are binded
        $statement = $this->conn->prepare($sql);

        // error occured
        if (!$statement) {
            throw new Exception($statement->error);
        }

        // if word entered bind params
        if (!empty($word)) {
            $word = '%' . $word . '%'; // %bob%
            $statement->bind_param("ss", $word, $word);
        }

        // execute statement
        $statement->execute();

        // assign returned results to $result var
        $result = $statement->get_result();

        // every time when we convert $result to assoc array append to $row
        while ($row = $result->fetch_assoc()) {

            // store all append $rows in $returnArray
            $returnArray[] = $row;
        }

        // feedback result
        return $returnArray;

    }

    public function updateUser($username,$email,$fullname,$id){
        $sql = "UPDATE users SET username=?, fullname=?, email=? WHERE id=?";
        $statement = $this->conn->prepare($sql);

        if(!$statement){
            throw new Exception($statement->error);
            return;
        }

        $statement->bind_param("sssi",$username,$fullname,$email,$id);

        $returnArray = $statement->execute();

        return $returnArray;
    }

}
?>