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
var counting_in_progress = false;

$(document).ready(function(){
	
	soundManager.url = base_url + 'swf';
	$('textarea').elastic();
	
	// setup pomodoro timer
	decreaseTimer();
});

function decreaseTimer() {
	currentTime = parseInt ( $(".timer .time").attr("data-seconds") ) -1;
	
	if(currentTime <= 0){
		
		counting_in_progress = false;
		
		currentTime = 0;
		$('.time').addClass('time_is_up');

		if( $('#pomodoro_submit[value="Complete"]').length == 0 && $('#break_submit[value="End break"]').length == 0 ) {
			$.ajax({
				type: "GET",
				url: base_url + "pomodoros/update_current_form",
				dataType: "text/html",
				success: function(html){
					$('#currentPomodoroForm').html(html);
				}
			});
		}
		
	} else if( $('.timer .time').length > 0 ) {
		
		setTimeout("decreaseTimer()", 1000);
		counting_in_progress = true;
		
	}
	
	minutes = parseInt(currentTime / 60);
	seconds = currentTime % 60;

	if(minutes > 0) {
		announceTimeLeft(minutes);
	} else if(currentTime == 0) {
		announceTimeLeft(0);
	}

	if(minutes < 10) minutes = '0' + minutes;
	if(seconds < 10) seconds = '0' + seconds;

	$(".timer .time").attr("data-seconds", currentTime);
	$(".timer .time").html(minutes + ":" + seconds);
	
	if( typeof(minutes) !== 'undefined' && typeof(seconds) !== 'undefined' && !isNaN(minutes) && !isNaN(seconds) ) {
		if( $('title:contains("[")').length > 0 ) {
			document.title = ( document.title.replace(/\[(.*)\]/, '[' + minutes + ":" + seconds + ']') );
		} else {
			document.title = ( '[' + minutes + ":" + seconds + '] ' + document.title );
		}
	}
	
}

function announceTimeLeft(minutes) {
	
	if(!voice_notifications) return;
	
	minutes = parseInt(minutes);
	if(played_sounds[minutes] !== undefined && !played_sounds[minutes]) {
		
		sound_file = base_url + "sounds/text-to-speech/" + (parseInt(minutes) +1) + ".";
		if(minutes == 0 && $('#pomodoro_submit[value="Complete"]').length == 0) {
			sound_file = base_url + "sounds/text-to-speech/0.";
		} 
		
		//console.log(sound_file);
		soundType = "";
		if($.support.audio.ogg) {
			soundType = "ogg"
		} else if($.support.audio.mp3) {
			soundType = "mp3"
		}
		
		if( soundType ) {
			audio = new Audio(sound_file + soundType);
			audio.play();
		} else {
			soundManager.onready(function() {
				var mySound = soundManager.createSound({
			  	id: 'sound_' + minutes,
			  	url: sound_file + 'mp3'
				});
				try {
					mySound.play('sound_' + minutes, {
						onfinish: function() {
							this.destruct();
						}
					});
				} catch(e) {
					
				}
			})
		}
	
		played_sounds[minutes] = true;
	} else {
		//console.log(minutes);
		//console.log(played_sounds[minutes]);
		//console.log(played_sounds[minutes]);
		//console.log("moo");
	}
}

// extend jquery support for audio and audio type
/**
* Clean way of testing for HTML5 audio support for jQuery.
*
* Example:
* if(jQuery.support.audio.mp3){
* alert('Thanks guy. Enjoy the mp3 party in your browser.');
* } else {
* alert('MP3 native playback not supported.');
* }
*
*/
(function() {
    var a = document.createElement("audio");
    function t(m){
        return (a && jQuery.isFunction(a.canPlayType) && a.canPlayType(m) != "" && a.canPlayType(m) != "no");
    };
    jQuery.extend(jQuery.support, {audio:{mp3: t('audio/mpeg'), aac: t('audio/aac'), ogg: t('audio/ogg')}});
})();

// event
$(document).ready(function(){
	// activity item click
	$('#content .activityName').click(function(){
		
		if( $(this).parent().parent().parent().hasClass("opened") ) {
			$(this).parent().parent().parent().find('.detailsView').toggle().parent().toggleClass("opened");
		} else {
			$('.opened').find('.detailsView').toggle().parent().toggleClass("opened");
			$(this).parent().parent().parent().find('.detailsView').toggle().parent().toggleClass("opened");
			
			if( $('li[data-activity]').length > 0 ) {
				window.location.hash = $(this).parent().parent().parent().attr('data-activity');
			}
		}
		
	});
	
	if( $('#content .activityName').length == 1 ) {
		$('#content .activityName').click();
	} else if( $('li[data-activity]').size() > 0 ) {
		$( 'li[data-activity="' + window.location.hash.replace("#", '') + '"] .activityName' ).click();
	}
})

// formattings
$(document).ready(function(){
	$('.field_with_errors').parent().addClass("container_of_field_with_errors");
	$('#activityFilter input[type=text]').inline_label();
	$('#pomodoro_comments').inline_label();
	$('input, select, textarea, submit, button, checkbox').focus(function() {
		$(this).addClass("activeInput");
	});
	$('input, select, textarea, submit, button, checkbox').blur(function() {
		$(this).removeClass("activeInput");
	});
})

// graphs
// Run the script on DOM ready:
$(function(){
	$('.pie').visualize({type: 'pie', width: '629px'});
	if( typeof(chart_interval) === 'undefined' || chart_interval < 20 ) {
		$('.bar').visualize({type: 'bar', width: '629px'});
	} else {
		$('.bar').visualize({type: 'line', width: '629px'});
	}
	//$('.area').visualize({type: 'area', width: '629px'});
	//$('.line').visualize({type: 'line', width: '629px'});
	//$('.analytics').visualize({type: 'area', width: '629px'});
	//$('.analytics').visualize({type: 'line', width: '629px'});
	$('.analytics').hide();
});


// usability
$(function(){ // autofocus first form input
	if( $('.formContainer form input[type=text]').size() > 0 ) {
		$('.formContainer form input[type=text]:first').focus();
	} else {
		$('.formContainer form textarea:first').focus();
	}
	
	$('#hiddendp_').datepicker({
	  beforeShow: readSelected, onSelect: updateSelected, 
		dateFormat: 'm/d/yy',
    minDate: new Date(), 
    showOn: 'both', buttonImageOnly: true, buttonImage: base_url + 'images/calendar_empty.png'});
	
	$( "#slider" ).slider({
		value: $('#activity_estimated_pomodoros').val(),
		min: 0,
		max: 8,
		step: 1,
		animate: true,
		slide: function( event, ui ) {
			$( "#activity_estimated_pomodoros" ).val( ui.value );
		}
	});
	$( "#activity_estimated_pomodoros" ).val( $( "#slider" ).slider( "value" ) );
	
	$('a.external').attr('target', '_blank');
})
     
// Prepare to show a date picker linked to three select controls 
function readSelected() { 
    $('#hiddendp_').val($('#activity_deadline_2i').val() + '/' + 
        $('#activity_deadline_3i').val() + '/' + $('#activity_deadline_1i').val()); 
    return {}; 
} 
 
// Update three select controls to match a date picker selection 
function updateSelected(date) { 
		//alert(date);
		dateParts = date.split("/");
    $('#activity_deadline_2i').val( dateParts[0] );
    $('#activity_deadline_3i').val( dateParts[1] ); 
    $('#activity_deadline_1i').val( dateParts[2] ); 
}

// nonsemantic 
$('#site').wrap('<div id="nonsemanticBg" />');

$( function(){
	
	$('.breakButtons li').click( function() {
		$(this).unbind('click');
		$(this).find('a').click();
		return;
	});
	
	$('.breakButtons li').hover(
		function() {
			$(this).addClass('breakButtonHover');
		},
		function() {
			$(this).removeClass('breakButtonHover');
		}
	);
})

$( function() {
	
	$('.signUpForm input.numeric').each(
		
		function() {
			input_id = $(this).attr('id');
			slider_id = $(this).attr('id') + '_slider';
			
			$(this).after('<div id="' + slider_id + '" class="user_slider"></div>');
			
			$( ("#" + slider_id) ).slider({
				value: $(this).val(),
				min: 5,
				max: 60,
				step: 5,
				animate: true, 
				slide: function( event, ui ) {
					$( "#" + $(this).attr('id').replace('_slider', '') ).val( ui.value );
				}
			});
			
			$( "#" + input_id ).val( $("#" + slider_id).slider( "value" ) );
		}
		
	)
})

$(function(){
	$('#todotodays').sortable({
		handle: '.drag_handle',
		update: function(event, ui) {
			$.ajax({
				type: "POST",
				url: base_url + "todotodays/save_sort",
				data: $('#todotodays').sortable("serialize"), 
				dataType: "text/html",
				success: function(html){
					
				}
			});
		}
	});
})

$(function(){
	$('.iframe').fancybox({
		padding: 0,
		margin: 0,
		scrolling: 'no',
		width: 580,
		height: 560,
		centerOnScroll: true,
		transitionIn: 'none',
		transitionOut: 'none',
		overlayOpacity: 1,
		overlayColor: '#E5E2D2'
	});
	
	$('#new_contact_request a.button').click(function(){
		parent.$.fancybox.close();
	})
})

$(function(){
	$('.video_demo').attr('target', '_blank');
})

function playTickTack() {
	
	sound_file = base_url + "sounds/clocks/egg_timer.";
	
	soundType = "";
	if($.support.audio.ogg) {
		soundType = "ogg"
	} else if($.support.audio.mp3) {
		soundType = "mp3"
	}
	
	if( soundType ) {
		audio = new Audio(sound_file + soundType);
		$(audio).attr('preload', 'auto');
		$(audio).bind('ended', function() {
			if(counting_in_progress) this.play();
		});
		
		$(audio)[0].play();
	} else {
		soundManager.onready(function() {
			var mySound = soundManager.createSound({
		  	id: 'ticking_clock',
		  	url: sound_file + 'mp3'
			});
			try {
				mySound.play('ticking_clock', {
					onfinish: function() {
						if(counting_in_progress) this.play();
					}
				});
			} catch(e) {
				
			}
		})
	}
}

$(function(){
	if(tick_tack_sound && counting_in_progress) playTickTack();
	
	$('#activity_event_type').click(function(){
		if( $('#activity_event_type').is(':checked') ) {
			$('.schedule').removeClass('inactive');
		} else {
			$('.schedule').addClass('inactive');
		}
	});
})

function playTestSound() {
	
	sound_file = base_url + "sounds/others/tada.";
	
	soundType = "";
	if($.support.audio.ogg) {
		soundType = "ogg"
	} else if($.support.audio.mp3) {
		soundType = "mp3"
	}
	
	if( soundType ) {
		audio = new Audio(sound_file + soundType);
		$(audio).attr('preload', 'auto');
		$(audio).bind('ended', function() {
			alert('Finished playing - did you hear the sound?');
		});
		
		$(audio)[0].play();
	} else {
		soundManager.onready(function() {
			var mySound = soundManager.createSound({
		  	id: 'ticking_clock',
		  	url: sound_file + 'mp3'
			});
			try {
				mySound.play('ticking_clock', {
					onfinish: function() {
						alert('Finished playing - did you hear the sound?');
					}
				});
			} catch(e) {
				
			}
		})
	}
}