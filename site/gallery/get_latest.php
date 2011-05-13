<?
$cachedFile = "latest_cached.txt";
$cacheLife = 60; //caching time, in minutes
$filemod = filemtime($cachedFile); 
$now = time();
$fileAge =  ($now - $filemod)/60;

$content;
if(file_exists($cachedFile) && $fileAge <= $cacheLife){
	$content = file_get_contents($cachedFile); 
}else{
    $fh = fopen($cachedFile, 'w') or die("can't open file");
	$content = file_get_contents("static_content.txt"); // replace this with a proper url
	fwrite($fh, $content);
	fclose($fh);
}
echo $content;
?>