 var VC = new Object();
 VC['read_paragraphs'] = [];
 var BASE_URL = "";

 function timecode(ms) {
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

 function record(){
 	Recorder.record({
 		start: function(){
 		},
 		progress: function(milliseconds){
 			document.getElementById("time").innerHTML = timecode(milliseconds);
 		}
 	});
 };

 function play(){
 	Recorder.stop();
 	Recorder.play({
 		progress: function(milliseconds){
 			document.getElementById("time").innerHTML = timecode(milliseconds);
 		}
 	});
 };

 function stop(){
 	Recorder.stop();
 };

 function upload(paragraph_id){

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
 		}
 	});
 };
 
 var get_paragraphs = function (){

 	var paragraph_url = BASE_URL + "/paragraphs";

 	$.ajax({
 		url: paragraph_url,
 		type: 'GET',
 		async:false,
 	}).done(function(data) {		
 		if( typeof data === 'string')
 			data = JSON.parse(data);
 		var paragraphs = data['paragraphs'];

 		for (var i = 0; i < paragraphs.length; i++) {
 			var paragraph_id = paragraphs[i]["id"];
 			if(VC['read_paragraphs'].indexOf(paragraph_id) > -1){
 				$("#paragraphs").append( '<li class="list_paragraph_read" id="paragraph_' + paragraph_id + 
 					'"> Paragraph ' + paragraph_id + '</li>' );
 			}
 			else{
 				$("#paragraphs").append( '<li class="list_paragraph_unread" id="paragraph_' + paragraph_id +
 					'"> Paragraph ' + paragraph_id + '</li>' );
 			}

 			$('#paragraph_' + paragraph_id).click(function() {

 				$('#text-paragraphs').remove();
 				$('#notice-text-default').remove();
 				$('#text-display').append('<div class="span11" id="text-paragraphs"></div>');

 				var paragraph_id = $(this).attr('id').split("paragraph_")[1];
 				$("#text-paragraphs").append('<div class="notice marker-on-left" id="notice-text">' 
 					+ paragraphs[paragraph_id - 1]["text"]
 					+ '</div> ' 
 					+ '<button id="record-button"> Record </button> ' 
 					+ '<button id="stop-button"> Stop </button> ' 
 					+ '<button id="send-button"> Send </button>'
 				);

 				$('#record-button').click(function(){
					record();
				});

 				$('#stop-button').click(function(){
					stop();
				});	

 				$('#send-button').click(function(){
					upload(paragraph_id);
				});	

 			});
 		}

 	},"json");
};

var get_user_read_paragraphs = function(){

	var user_read_paragraphs_url = BASE_URL + "/user/paragraphs";

	$.ajax({
		url: user_read_paragraphs_url,
		type: 'GET',
		async:false,
	}).done(function(data) {
		if( typeof data === 'string')
			data = JSON.parse(data);
		VC['read_paragraphs'] = data['paragraphs'];
	},"json");
};

$(document).ready(function() {

	Recorder.initialize({
		swfSrc: "static/recorder.swf"
	});

	get_user_read_paragraphs();
	get_paragraphs();

});