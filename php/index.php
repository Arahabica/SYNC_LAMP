<?php
$host = "YOUR_DB_HOST";
$user = "YOUR_DB_USER";
$password = "YOUR_DB_PASSWORD";
$dbname ="YOUR_DB_NAME";

echo "Apache and PHP is Work\n";
echo "phpinfo => " .$_SERVER['HTTP_HOST'] . "/phpinfo.php\n";
echo "MySQL\n";
$link = mysql_connect($host, $user, $password);
if (!$link) {
    die('接続失敗です。'.mysql_error());
}

$db_selected = mysql_select_db($dbname, $link);
if (!$db_selected){
    die('データベース選択失敗です。'.mysql_error());
}

$result = mysql_query('SELECT * FROM test');
if (!$result) {
    die('クエリーが失敗しました。'.mysql_error());
}

$row = mysql_fetch_assoc($result);
echo $row["name"]. "\n";
mysql_close($link);