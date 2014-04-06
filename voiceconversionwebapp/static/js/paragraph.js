 if (!String.prototype.format) {
 	String.prototype.format = function() {
 		var args = arguments;
 		return this.replace(/{(\d+)}/g, function(match, number) { 
 			return typeof args[number] != 'undefined'
 			? args[number]
 			: match
 			;
 		});
 	};
 }

 var BASE_URL = "";

 var VC = function(){

 	this.initialize = function(){
 		Recorder.initialize({
 			swfSrc: "static/recorder.swf"
 		});
 		this.get_user_read_paragraphs();
 		this.get_paragraphs();
 		this.initParagraphList();
 	};

 	this.get_paragraphs = function (){

 		var paragraph_url = BASE_URL + "/paragraphs";

 		$.ajax({
 			url: paragraph_url,
 			type: 'GET',
 			async:false,
 		}).done(function(data) {		
 			if( typeof data === 'string')
 				data = JSON.parse(data);
 			this.paragraphs = data['paragraphs'];
 		}.bind(this),"json");
 	};

 	this.get_user_read_paragraphs = function(){

 		var user_read_paragraphs_url = BASE_URL + "/user/paragraphs";

 		$.ajax({
 			url: user_read_paragraphs_url,
 			type: 'GET',
 			async:false,
 		}).done(function(data) {
 			if( typeof data === 'string')
 				data = JSON.parse(data);
 			this.readParagraphs = data['paragraphs'];
 		}.bind(this),"json");
 	};

 	this.initParagraphList = function(){

 		for (var i = 0; i < this.paragraphs.length; i++) {

 			var paragraph_id = this.paragraphs[i]["id"];
 			var li_class = "list_paragraph_unread";
 			var self = this;
 			var paragraphText = this.paragraphs[i]["text"];
 			if(paragraphText.length > 25)
 				paragraphText = paragraphText.substring(0, 25);
 			paragraphText += "...";

 			if(this.readParagraphs.indexOf(paragraph_id) > -1)
 				li_class = "list_paragraph_read";
 			$("#paragraphs").append('<li class="{1}" id="paragraph_{0}">{2}</li>'.format(paragraph_id, li_class, paragraphText));

 			$('#paragraph_' + paragraph_id).click(function() {

 				$('#text-paragraphs').remove();
 				$('#notice-text-default').remove();
 				$('#text-display').append('<div class="span11" id="text-paragraphs"></div>');

 				var paragraph_id = $(this).attr('id').split("paragraph_")[1];

 				$("#text-paragraphs").append(
 					'<div class="notice marker-on-left" id="notice-text">'
 					+ self.paragraphs[paragraph_id - 1]["text"]
 					+ '<br/> <span id="time" style="color:black;font-size: xx-large;">0:00</span>'
 					+ '</div>'
 					+ '<button id="record-button" class="emerald-flat-button"> Record </button>'
 					+ '<button id="stop-button" class="emerald-flat-button"> Stop </button>'
 					+ '<button id="play-button" class="emerald-flat-button"> Play </button>' 
 					+ '<button id="send-button" class="emerald-flat-button"> Send </button>'
 				);

 				$('#record-button').click(function(){
 					self._record();
 				});

 				$('#stop-button').click(function(){
 					self._stop();
 				});

 				$('#play-button').click(function(){
 					self._play();
 				});	

 				$('#send-button').click(function(){
 					self._upload(paragraph_id);
					self.readParagraphs.push(parseInt(paragraph_id));
					var nextUnreadParagraphId = self._getNextUnreadParagraphId();
					if(nextUnreadParagraphId == -1){
						alert('Training Complete');
						window.location.href = '/';
					}
					$('#paragraph_' + nextUnreadParagraphId).click();
 				});	

 			});
 		}
 	};

 	this._timecode = function(ms) {
 		var hms = {
 			h: Math.floor(ms/(60*60*1000)),
 			m: Math.floor((ms/60000) % 60),
 			s: Math.floor((ms/1000) % 60)
 		};
 		var tc = [];

 		if (hms.h > 0) {
 			tc.push(hms.h);
 		}

 		tc.push((hms.m < 10 && hms.h > 0 ? "0" + hms.m : hms.m));
 		tc.push((hms.s < 10  ? "0" + hms.s : hms.s));

 		return tc.join(':');
 	};

 	this._record = function() {
 		Recorder.record({
 			start: function(){
 			},
 			progress: function(milliseconds){
 				document.getElementById("time").innerHTML = this._timecode(milliseconds);
 			}.bind(this)
 		});
 	};

 	this._play = function() {
 		Recorder.stop();
 		Recorder.play({
 			progress: function(milliseconds){
 				document.getElementById("time").innerHTML = this._timecode(milliseconds);
 			}.bind(this)
 		});
 	};

 	this._stop = function() {
 		Recorder.stop();
 	};

 	this._upload = function(paragraph_id) {

 		paragraph_id = parseInt(paragraph_id);

 		Recorder.upload({
 			url:"/user/paragraphs/update",
 			audioParam: "speech_file",
 			params: {
 				'paragraph_id' : paragraph_id
 			},
 			success: function(data){
 				if( typeof data === 'string')
 					data = JSON.parse(data);
 				if(data['status'] == 'true'){
 					$('#paragraph_' + paragraph_id).attr('class', 'list_paragraph_read');
 				}
 				else{
 					alert(data['status']);
 				}
 			}.bind(this)
 		});
 	};

 	this._getNextUnreadParagraphId = function() {
 		for(var i=1; i <= this.paragraphs.length ; i++){
 			if(this.readParagraphs.indexOf(i) == -1)
 				return i;
 		}
 		return -1;
 	};

 };

 $(document).ready(function() {

 	var voiceConversion = new VC();
 	voiceConversion.initialize();

 });