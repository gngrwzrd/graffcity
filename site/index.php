<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<html lang="en">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<title>index</title>
	<meta name="generator" content="TextMate http://macromates.com/">
	<meta name="author" content="Malcolm Wilson">
	<!-- Date: 2010-11-16 -->
	
	
	<link href="assets/css/lectric.css" rel="stylesheet" media="screen" type="text/css">
	<link href="assets/css/main.css" rel="stylesheet" media="screen" type="text/css">
	
	<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js" type="text/javascript"></script>
	<script src="assets/js/lectric.min.js" type="text/javascript"></script>
	<script src="assets/js/load_images.js" type="text/javascript"></script>
</head>
<body>
	
<!-- Screenshots -->
	<div id="screenshots">
		<div class="item"><img src="assets/images/screenshots/01_splash.jpg" width="320" height="480" /></div>
	    <div class="item"><img src="assets/images/screenshots/02_spray_view.jpg" width="320" height="480" /></div>
	    <div class="item"><img src="assets/images/screenshots/03_tag_detail.jpg" width="320" height="480" /></div>
	    <div class="item"><img src="assets/images/screenshots/04_ar_view.jpg" width="320" height="480" /></div>
		<div class="item"><img src="assets/images/screenshots/05_help.jpg" width="320" height="480" /></div>
	</div>
	<a href="" id="screensPrev">Previous</a>
	<a href="" id="screensNext">Next</a>
	<script type="text/javascript">
		var slider = new Lectric.Slider();
		slider.init('#screenshots', {next: '#screensNext', previous: '#screensPrev'});
	</script>
	<br />
	
<!-- What's new -->	
	<div id="whatsNew">
		<?
		// throw this in to generate enough content since Lectric has issues with javascript
		for($i=0; $i<20; $i++){
			echo "<div id='item" . $i . "' class='item'></div>";
		}
		?>
	</div>
	<a href="" id="whatsNewPrev">Previous</a>
	<a href="" id="whatsNewNext">Next</a>
	<script type="text/javascript">
		var sl = new ServiceLoader("gallery/get_latest.php");
	</script>
	<script type="text/javascript">
		var slider2 = new Lectric.Slider();
		slider2.init('#whatsNew', {next: '#whatsNewNext', previous: '#whatsNewPrev'});
	</script>

<!-- Video -->		
	<!-- Begin VideoJS -->
	<div class="video-js-box">
	  <!-- Using the Video for Everybody Embed Code http://camendesign.com/code/video_for_everybody -->
	  <video class="video-js" width="480" height="270" controls preload poster="http://pixelrevision.com/sandbox/graffcity/assets/video/showcase.jpg">
	    <source src="http://pixelrevision.com/sandbox/graffcity/assets/video/showcase.mp4" type='video/mp4; codecs="avc1.42E01E, mp4a.40.2"' />
	    <!-- Flash Fallback. Use any flash video player here. Make sure to keep the vjs-flash-fallback class. -->
	    <object id="flash_fallback_1" class="vjs-flash-fallback" width="480" height="270" type="application/x-shockwave-flash" 
	      data="http://releases.flowplayer.org/swf/flowplayer-3.2.1.swf">
	      <param name="movie" value="http://releases.flowplayer.org/swf/flowplayer-3.2.1.swf" />
	      <param name="allowfullscreen" value="true" />
	      <param name="flashvars" 
	        value='config={"playlist":["http://pixelrevision.com/sandbox/graffcity/assets/video/showcase.jpg", {"url": "http://pixelrevision.com/sandbox/graffcity/assets/video/showcase.mp4","autoPlay":false,"autoBuffering":true}]}' />
	      <!-- Image Fallback. Typically the same as the poster image. -->
	      <img src="http://pixelrevision.com/sandbox/graffcity/assets/video/showcase.jpg" width="480" height="270" alt="Poster Image" 
	        title="No video playback capabilities." />
	    </object>
	  </video>
	  <!-- Download links provided for devices that can't play video in the browser. -->
	  <p class="vjs-no-video"><strong>Download Video:</strong>
	    <a href="http://pixelrevision.com/sandbox/graffcity/assets/video/showcase.mp4">MP4</a>,
	    <!-- Support VideoJS by keeping this link. -->
	    <a href="http://videojs.com">HTML5 Video Player</a> by VideoJS
	  </p>
	</div>
	<!-- End VideoJS -->
	
</body>
</html>
