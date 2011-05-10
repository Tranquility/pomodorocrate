$(function(){
	
	/* get data - json - simple get request correspoding no normal site urls 
	$.ajax({
		url: "http://localhost:3000/todotodays?api_key=860fb1fb04566d57e7ef3df225ec702b83408813",
		dataType: "json",
		type: "GET",
		processData: false,
		contentType: "application/json"
	});
	*/
	
	/* create activity - xml - using POST
	$.ajax({
		url: "http://localhost:3000/activities?api_key=860fb1fb04566d57e7ef3df225ec702b83408813&activity_id=247",
		dataType: "xml",
		type: "POST",
		processData: false,
		contentType: "text/xml",
		data: '<activity><deadline type="date">2012-01-01</deadline><description>New Year!!!</description><estimated-pomodoros type="integer">4</estimated-pomodoros><name>Celebrate!!!</name><project-id type="integer">2</project-id><unplanned type="boolean">false</unplanned></activity>'
	});
	*/
	
	/* create activity - json
	$.ajax({
		url: "http://localhost:3000/activities?api_key=860fb1fb04566d57e7ef3df225ec702b83408813&activity_id=247",
		dataType: "json",
		type: "POST",
		processData: false,
		contentType: "application/json",
		data: '{ "activity": { "deadline":"2012-01-01", "description":"New Year!!! json", "estimated_pomodoros":8, "name":"Celebrate json!!", "project_id":2, "unplanned":false } }'
	});
	*/
	
	/* create todotoday - xml
	$.ajax({
		url: "http://localhost:3000/todotodays?api_key=860fb1fb04566d57e7ef3df225ec702b83408813&activity_id=247",
		dataType: "xml",
		type: "POST",
		processData: false,
		contentType: "text/xml",
		data: '<todotoday></todotoday>'
	});
	*/
	
	/* create pomodoro - xml
	$.ajax({
		url: "http://localhost:3000/pomodoros?api_key=860fb1fb04566d57e7ef3df225ec702b83408813&activity_id=247",
		dataType: "xml",
		type: "POST",
		processData: false,
		contentType: "text/xml",
		data: '<pomodoro></pomodoro>'
	});
	*/
	
	/* void pomodoro - json - use successful = true to mark a pomodoro as completed
	$.ajax({
		url: "http://localhost:3000/pomodoros/369?api_key=860fb1fb04566d57e7ef3df225ec702b83408813",
		dataType: "json",
		type: "POST",
		processData: false,
		contentType: "application/json",
		data: '{"pomodoro": {"completed":true, "successful":false, "comments":"Voided because of unexpected phone call"} }',
		beforeSend: function(xhr)   
		{
			xhr.setRequestHeader("X-Http-Method-Override", "PUT");
		}
	});
	*/
	
	/* create break - xml 
	$.ajax({
		url: "http://localhost:3000/breaks?api_key=860fb1fb04566d57e7ef3df225ec702b83408813&duration=25",
		dataType: "xml",
		type: "POST",
		processData: false,
		contentType: "text/xml",
		data: '<break></break>'
	});
	*/
	
	/* end break - json 
	$.ajax({
		url: "http://localhost:3000/breaks/73?api_key=860fb1fb04566d57e7ef3df225ec702b83408813",
		dataType: "json",
		type: "POST",
		processData: false,
		contentType: "application/json",
		data: '{ "break": { "completed":true } }',
		beforeSend: function(xhr)   
		{
			xhr.setRequestHeader("X-Http-Method-Override", "PUT");
		}
	});
	*/
	
	/* get current pomodoro - json 
	$.ajax({
		url: "http://localhost:3000/pomodoros/current?api_key=860fb1fb04566d57e7ef3df225ec702b83408813",
		dataType: "json",
		type: "GET",
		processData: false,
		contentType: "application/json"
	});
	*/
	
	/* get current break - json 
	$.ajax({
		url: "http://localhost:3000/breaks/current?api_key=860fb1fb04566d57e7ef3df225ec702b83408813",
		dataType: "json",
		type: "GET",
		processData: false,
		contentType: "application/json"
	});
	*/
	
});