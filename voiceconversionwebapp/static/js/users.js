var BASE_URL = "";

var get_all_trained_users = function(){
	var users_url = BASE_URL + "/get_all_trained_users";

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
			console.log(user_id);
			// var user_profile_pic = users[i]["profile_pic"];
			// var user_email = users[i]["email"];
			// var user_name = users[i]["name"];
			
			$("#users_completed_training").append( '<li class="users_completed_training" id="user_' + user_id + 
					'"> User ' + user_id + '</li>' );
			
			$('#user_' + user_id).click(function() {
				
				$('#text-users').remove();
 				$('#notice-info-default').remove();
 				$('#text-display').append('<div class="span10" id="text-users"></div>');
 				
 				var user_id = $(this).attr('id').split("user_")[1];
 				$("#text-users").append('<div class="notice marker-on-left" id="notice-info">' 
 					+ '<img src="' + users[user_id - 1]["profile_pic"]  + '" class="rounded span2">'
 					+ '<div>'
 					+ users[user_id - 1]["name"]
 					+ '</div>'
 					+ '<div>'
 					+ users[user_id - 1]["email"]
 					+ '</div> ' 
 					+ '</div> ' 
 				);
 			});
 		}

	},"json");
};	

$(document).ready(function() {
	
	get_all_trained_users();
	// get_users_trained_with();

});