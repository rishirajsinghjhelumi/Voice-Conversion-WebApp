 var VC = new Object();
 var BASE_URL = "";
 
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

			$('#paragraph_' + paragraph_id ).click(function() {
				
				$('#text-paragraphs').remove();
				$('#notice-text-default').remove();
				$('#text-display').append('<div class="span11" id="text-paragraphs"></div>');
				
				var id = $(this).attr('id');
				var paragraph_id = id.split("paragraph_")[1];
				var text = paragraphs[paragraph_id-1]["text"];
				$("#text-paragraphs").append('<div class="notice marker-on-left" id="notice-text">' + text + 
					'</div> <button id="record-button"> Record </button> <button id="send-button"> Stop </button> <button id="send-button"> Send </button>');

				$('#record-button').click(function(){
					// call the record function
				 });

				$('#stop-button').click(function(){
					// call the stop record function
				 });	

				$('#send-button').click(function(){
					// call the send record function
				 });	
				
			});
		}

	},"json");
 };	

// document.getElementById("paragraphs").addEventListener("click",function(e) {
// 	// e.target is our targetted element.
//     console.log(e.target.nodeName)
// 	if(e.target && e.target.nodeName == "LI") {
// 		alert(e.target.id);
// 	}
// });

 var get_user_read_paragraphs = function(){

 	VC['read_paragraphs'] = [];
 	var user_read_paragraphs_url = BASE_URL + "/user/paragraphs";

 	$.ajax({
		url: user_read_paragraphs_url,
		type: 'GET',
		async:false,
	}).done(function(data) {
		if( typeof data === 'string')
			data = JSON.parse(data);
		VC['read_paragraphs'] = data;
	},"json");
 };

$(document).ready(function() {

	get_user_read_paragraphs();
	VC['read_paragraphs'] = [1,2,7,14,35,26];
	get_paragraphs();

});