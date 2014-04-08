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

	/* Paragraphs */

	this.initializeParagraphs = function(){
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
				$('#text-display').append('<div id="text-paragraphs"></div>');

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

this._uploadUserVoice = function(user_id) {

	var self = this;
	Recorder.upload({
		url:"/convert_voice",
		audioParam: "speech_file",
		params: {
			'user_converted_id' : user_id
		},
		success: function(data){
			if( typeof data === 'string')
				data = JSON.parse(data);
			self.speech = data['converted_speech'];
			$('#notice-info').append(
						('<div id="audio-player">'
							+ '<audio controls="controls">'
							+ '<source src="{0}" type="audio/wav">'
							+ 'Your browser does not support audio format.'
							+ '</audio>'
							+ '</div>').format(self.speech['speech_file'])
			);
		}
	});
};

this._getNextUnreadParagraphId = function() {
	for(var i=1; i <= this.paragraphs.length ; i++){
		if(this.readParagraphs.indexOf(i) == -1)
			return i;
	}
	return -1;
};

/* Users */


this.initializeUsers = function(){
	Recorder.initialize({
			swfSrc: "static/recorder.swf"
		});	
	this.get_all_trained_users();
	this.get_users_trained_with();
	this.speech = null;
};

this.get_all_trained_users = function(){

	var users_url = BASE_URL + "/get_all_trained_users";
	var self = this;

	$.ajax({
		url: users_url,
		type: 'GET',
		async:false,
	}).done(function(data) {		
		if( typeof data === 'string')
			data = JSON.parse(data);
		var users = data['users'];

		for (var i = 0; i < users.length; i++) {
			var user_id = users[i]["id"];

			$("#users_completed_training").append( '<li class="users_completed_training" id="completed_user_{0}">{1}</li>'.format(user_id,users[i]['name']) );
			$('#completed_user_' + user_id).click(function() {

				$('#text-users').remove();
				$('#notice-info-default').remove();
				$('#text-display').append('<div id="text-users"></div>');

				var user_id = $(this).attr('id').split("completed_user_")[1];
				var user_obj = $.grep(users, function(e){ return e.id == user_id; })[0];

				$("#text-users").append(
					('<div class="notice marker-on-left" id="notice-info">' 
						+ '<div id="img-info"><img src="{0}" class="rounded span2"></div>'
						+ '<div> {1} </div>'
						+ '<div> {2} </div> ' 
						+ '</div> ').format(user_obj['profile_pic'],user_obj['name'],user_obj['email'])
					+ '<button id="train-button" class="emerald-flat-button"> Start Training </button>'
					);

				$('#train-button').click(function(){
					self.train_with(user_id);
				});
			});
		}

	},"json");
};

this.train_with = function(user_id){

	$.ajax({
		url: "/train_with",
		type: 'POST',
		async: true,
		data : {user_id : user_id }
	}).done(function(data) {
		if( typeof data === 'string')
			data = JSON.parse(data);
		this._alert(data['status']);
		if(data['status'] == 'Training Complete')
			location.reload();
	}.bind(this),"json");
};

this._alert = function(data){
	$.Dialog({
		overlay: true,
		shadow: true,
		flat: true,
		title: 'Alert Box',
		content: '',
		padding: 10,
		onShow: function(_dialog){
			var content = data
			+ '<br/>'
			+ '<div style="text-align:center;">'
			+ '<button class="button" type="button" onclick="$.Dialog.close()" style="align:center;">OK</button> '; 
			+ '/<div>'
			$.Dialog.title("Message");
			$.Dialog.content(content);
			$.Metro.initInputs();
		}
	});
};

this.get_users_trained_with = function(){

	var users_url = BASE_URL + "/get_users_trained_with";
	var self = this;

	$.ajax({
		url: users_url,
		type: 'GET',
		async:false,
	}).done(function(data) {		
		if( typeof data === 'string')
			data = JSON.parse(data);
		var users = data['users'];

		for (var i = 0; i < users.length; i++) {
			var user_id = users[i]["id"];

			$("#users_trained_with").append('<li class="users_trained_with" id="trained_user_{0}">{1}</li>'.format(user_id,users[i]['name']) );
			$('#trained_user_' + user_id).click(function() {

				$('#text-users').remove();
				$('#notice-info-default').remove();
				$('#text-display').append('<div id="text-users"></div>');

				var user_id = $(this).attr('id').split("trained_user_")[1];
				var user_obj = $.grep(users, function(e){ return e.id == user_id; })[0];

				$("#text-users").append(
					('<div class="notice marker-on-left" id="notice-info">' 
						+ '<div id="img-info"><img src="{0}" class="rounded span2"></div>'
						+ '<div> {1} </div>'
						+ '<div> {2} </div> ' 
						+ '<br/> <span id="time" style="color:black;font-size: xx-large;">0:00</span>'
						+ '</div> ').format(user_obj['profile_pic'],user_obj['name'],user_obj['email'])
					+ '<div id="all-buttons">'
					+ '<button id="record-button" class="emerald-flat-button"> Record </button>'
					+ '<button id="stop-button" class="emerald-flat-button"> Stop </button>'
					+ '<button id="play-button" class="emerald-flat-button"> Play </button>' 
					+ '<button id="convert-button" class="emerald-flat-button"> Convert </button>'
					+ '</div>'
					);

				$('#convert-button').click(function(){
					self._uploadUserVoice(user_id);
				});	

				$('#record-button').click(function(){
					self._record();
				});

				$('#stop-button').click(function(){
					self._stop();
				});

				$('#play-button').click(function(){
					self._play();
				});	

			});
}

},"json");
};	

};

