// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(document).ready(function(){
	// setup pomodoro timer
	decreaseTimer();
});

function decreaseTimer() {
	currentTime = parseInt ( $(".timer .time").attr("data-seconds") ) -1;
	
	if(currentTime < 0){
		currentTime = 0;
	} else {
		setTimeout("decreaseTimer()", 1000);
	}
	
	minutes = parseInt(currentTime / 60);
	seconds = currentTime % 60;
	
	$(".timer .time").attr("data-seconds", currentTime);
	$(".timer .time").html(minutes + ":" + seconds);
}

// add autoupdate functionality for checkboxes
$(document).ready(function(){
	$('.todotoday input:checkbox').change(function(){
		console.log('moo');
	})
});