// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

var played_sounds = new Array();
played_sounds[23] = false;
played_sounds[19] = false;
played_sounds[14] = false;
played_sounds[9] = false;
played_sounds[4] = false;
played_sounds[2] = false;
played_sounds[0] = false;

var clock_audio;

$(document).ready(function(){
	// setup pomodoro timer
	decreaseTimer();
	//setTimeout("testSounds()", 5000);
});

function decreaseTimer() {
	currentTime = parseInt ( $(".timer .time").attr("data-seconds") ) -1;
	
	if(currentTime < 0){
		currentTime = 0;
		if( $('#pomodoro_submit[value="Complete"]').length == 0 ) window.location.reload();
	} else {
		setTimeout("decreaseTimer()", 1000);
	}
	
	minutes = parseInt(currentTime / 60);
	seconds = currentTime % 60;
	if(seconds < 10) seconds = '0' + seconds;
	
	if(minutes > 0) {
		announceTimeLeft(minutes);
	} else if(currentTime == 0) {
		announceTimeLeft(0);
	}
	
	$(".timer .time").attr("data-seconds", currentTime);
	$(".timer .time").html(minutes + ":" + seconds);
}

// add autoupdate functionality for checkboxes
$(document).ready(function(){
	$('.todotoday input:checkbox').change(function(){
		console.log('moo');
	})
});


function testSounds() {
	for(var i in played_sounds) {
		if(!played_sounds[i]) {
			console.log("starting " + i);
			
			announceTimeLeft(i);
			played_sounds[i] = true;
			setTimeout("testSounds()", 5000);
			break;
		}
	}
}

function announceTimeLeft(minutes) {
	
	if(played_sounds[minutes] !== undefined && !played_sounds[minutes]) {
		
		sound_file = "sounds/text-to-speech/" + (parseInt(minutes) +1) + ".ogg";
		if(minutes == 0 && $('#pomodoro_submit[value="Complete"]').length == 0) {
			sound_file = "sounds/text-to-speech/0.ogg";
		} 
		
		console.log(sound_file);
		
		audio = new Audio(sound_file);
		audio.play();
	  	
		played_sounds[minutes] = true;
	}
}

function playClockSound() {
	sound_file = "/sounds/clocks/egg_timer.ogg"
	
	clock_audio = new Audio(sound_file);
	clock_audio.play();
}

function stopClockSound() {
	clock_audio.stop();
}
