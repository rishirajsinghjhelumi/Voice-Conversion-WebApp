<!DOCTYPE html>
<html>
<head>
	<link rel="stylesheet" href="static/css/metro-bootstrap.css">
	<link rel="stylesheet" href="static/css/metro-bootstrap-responsive.css">
	<link rel="stylesheet" href="static/min/iconFont.min.css">
	<link rel="stylesheet" href="static/css/index.css">
	<script src="static/js/jquery-1.11.0.min.js"></script>
	<script src="static/js/jquery.widget.min.js"></script>
	<script src="static/min/metro.min.js"></script>
	<script src="static/js/recorder.js"></script>
	<script src="static/js/audiojs/audio.min.js"></script>
	<script src="static/js/all.js"></script>
	<script src="static/pace/pace.min.js"></script>
  	<link href="static/pace/themes/pace-theme-flash.css" rel="stylesheet" />
</head>

<body class="metro">
	<div id="wrap">

		<nav class="navigation-bar dark">
			<nav class="navigation-bar-content">
				<div class="grid">
					<div class="row">
						<div class="span3" style="padding-left:15px;">
							<a href="/"><img src="static/img/logo.png" style="width:100px;"/></a>
						</div>
						<div class="span11">
							<div class="heading" style="position:relative;padding-top:12px;font-size:55px;"><a href="/" style="color:white;">Voice Conversion</a></div>
						</div>
						% if 'user' in request.session:
						<div class="span1" id="training-button" style="padding-top:20px;">
							<form action="/training" style="display:inline">
								<button class="default large">Training</button>
							</form>
						</div>
						
						<div class="span1" id="logout-button" style="padding-top:20px;padding-left:40px;">
							<form action="/logout" style="display:inline">
								<button class="danger large">Logout</button>
							</form>
						</div>
						% endif
					</div>
				</div>
			</nav>
		</nav>

		<div class="container">