// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require rails
//= require_self
//= require enhance
//= require excanvas
//= require jquery-ui-1.8.9.custom.min
//= require jquery.inline_label.min
//= require visualize.jQuery
//= require jquery.fancybox-1.3.4.pack
//= require jquery.elastic.source
//= require event_calendar
//= require jquery.quickClear
//= require ajaxify
//= require jquery.cookie

var played_sounds = [];
played_sounds[23] = false;
played_sounds[19] = false;
played_sounds[14] = false;
played_sounds[9] = false;
played_sounds[4] = false;
played_sounds[2] = false;
played_sounds[0] = false;

var clock_audio;
var counting_in_progress = false;
var time_since_server_time_read = 0;
var ticktack;
var timer;

var loadingFeedbackHandler;
var loaderX, loaderY;

/**** BREAKS WIDGET ****/
$(function() {
	/* add hover functionality to break buttons */
	$('.breakButtons li').live('mouseover', function() {
		$(this).addClass('breakButtonHover');
	});
	
	$('.breakButtons li').live('mouseout', function() {
		$(this).removeClass('breakButtonHover');
	});
	
	/* new break */
	$("#shortBreak a, #longBreak a").live("ajax:success", function(event, data, status, xhr) {
		if( data != 'KO' ) {
			$('#timedBreak').parent().replaceWith(data);
			decreaseTimer();
			playTickTack();
		}
	});

	/* stop break from button */
	$(".edit_break").live("ajax:success", function(event, data, status, xhr) {
			if( data != 'KO' ) {
				$('#activePomodoro').parent().replaceWith(data);
				stopCounting();
			}
  });
	
	/* add click on the whole button */
	$('#shortBreak, #longBreak').live('click', function(){
		$(this).children('a').click();
	});
	
	/* stop link click from bubbling up */
	$('#shortBreak a, #longBreak a').live('click', function(e){
		e.stopPropagation();
	});
});
/**** END BREAKS WIDGET ****/

/**** DO TODAY FUNCTIONALITY ****/
$(function(){
	$('a[data-method="post"][href^="/todotodays?activity_id="]').live("ajax:success", function(event, data, status, xhr) {
			if( data != 'KO' ) {
				updateMainListing();
			}
   });
});
/**** END DO TODAY FUNCTIONALITY ****/

/**** DO IT NOW FUNCTIONALITY ****/
$(function(){
	$('a[data-method="post"][href^="/pomodoros?activity_id="][data-action!="create-update-pomodoro"]').live("ajax:success", function(event, data, status, xhr) {

			if( data != 'KO' ) {
				
				$( getCurrentPomodoroContainer() ).parent().replaceWith(data);
				
				stopCounting();
				updateMainListing();
				decreaseTimer();
				playTickTack();
				
				$('#pomodoro_comments').elastic();
			}
   });
});
/**** END DO IT NOW FUNCTIONALITY ****/

/**** MANUALLY MARK POMODORO AS COMPLETED ****/
$(function(){
	$('a[data-action="create-update-pomodoro"]').live("ajax:success", function(event, data, status, xhr) {
			if( data != 'KO' ) {
				updateActivePomodoroWidget();
			}
   });

	$('.pomodoros_icons a[data-method="post"][href^="/pomodoros?activity_id="] img').live('mouseover', function(){
		this.src = '/assets/pomodoro_completed.png';
	}).live('mouseout', function(){
		this.src = '/assets/pomodoro_complete_manually.png';
	});
});
/**** END MANUALLY MARK POMODORO AS COMPLETED ****/

/**** VOID POMODORO ****/
$(function(){
	$(".edit_pomodoro").live("ajax:success", function(event, data, status, xhr) {
			if( data != 'KO' ) {
				$('#activePomodoro').parent().replaceWith(data);
				removeInterruptionsWidget();
				updateMainListing();

				stopCounting();
			}
	 });
	
	$('#pomodoro_successful').live('change', function(){
		if( $(this).is(':checked') ) {
			$('#pomodoro_submit').val('Complete');
		} else {
			$('#pomodoro_submit').val('Void!').effect("pulsate", { times:1 }, 1000);
		}
	});
})
/**** END VOID POMODORO ****/

/**** ACTION TOOLBAR BUTTONS ****/
$(function(){
	$(".pomodoros_count").live("ajax:success", function(event, data, status, xhr) {
		clearExistingData();
		addNewData(data, this);
	});
	
	$(".comments_count").live("ajax:success", function(event, data, status, xhr) {
			clearExistingData();
			addNewData(data, this);
			$('#commentsList #comment_content').elastic();
	});
});
/**** END ACTION TOOLBAR BUTTONS ****/

/**** PAGINATION ****/
$(function(){
	ajaxifyPagination();

	$('.pagination a').live("ajax:success", function(event, data, status, xhr) {
			updateActivitiesListing(currentActivityListId(), data);
			//ajaxifyPagination();
   });
});
/**** END PAGINATION ****/

/**** DELETE ACTIVITY ****/
$(function(){
	$('a[data-method="delete"][href^="/activities/"]').live("ajax:success", function(event, data, status, xhr) {
			if( data != 'OK' ) {
				alert('delete failed');
			}
			updateMainListing();
   });
});
/**** END DELETE ACTIVITY ****/

/**** MARK ACTIVITY AS COMPLETED ****/
$(function(){
	$(".edit_activity").live("ajax:success", function(event, data, status, xhr) {
			updateMainListing();
	 });
	
	// prevent click from bubbling up
	$('input.checkbox[type="image"]').live('click', function(e){
		e.stopPropagation();
	});
});
/**** END MARK ACTIVITY AS COMPLETED ****/

/**** GENERIC AJAX START ****/
$(document).ajaxStart(function(e){
	loadingFeedback(e, 'Loading. Please wait...');
});
/**** END GENERIC AJAX START ****/

/**** GENERIC AJAX COMPLETE ****/
$(document).ajaxComplete(function(){
	ajaxifyPagination();
	draggableTodoItems(); // make todo today items draggable
	removeLoadingFeedback(); // remove loader
});
/**** END GENERIC AJAX COMPLETE ****/

/**** DELETE TODOTODAY ****/
$(function(){
	$('a[data-method="delete"][href^="/todotodays/"]').live("ajax:success", function(event, data, status, xhr) {
			if( data != 'OK' ) {
				alert('delete failed');
			}
			updateMainListing();
   });
});
/**** END DELETE TODOTODAY ****/

/**** PROMPT SUPPORT ****/
$(function(){
	$('[data-prompt]').live('click', function(){
		user_input = prompt( $(this).attr('data-prompt'), $(this).attr('data-prompt-answer') ? $(this).attr('data-prompt-answer') : "" );
		if( user_input ) user_input = user_input.replace('"', "'");
		
		if ( $(this).attr('data-prompt-callback') && typeof window[ $(this).attr('data-prompt-callback') ] == "function") {
			return window[ $(this).attr('data-prompt-callback') ]( user_input );
		} else {
			return true;
		}
		
		return true;
	});
});
/**** END PROMPT SUPPORT ****/

/**** LOADER POSITIONING UTILITY ****/
$(function(){
	$("body").live('click', function(e){
		loaderX = e.pageX;
		loaderY = e.pageY;
	});
});
/**** END LOADER POSITIONING UTILITY ****/

/**** TOGGLE WIDGETS ****/
$(function(){
	
	$('#sidebar .toggable.expandable').live('click', function(){
		$(this).next('.widgetBox').slideDown('fast', function(){
			toggleWidgets( $(this).prev('#sidebar .toggable') );
		});	
	});
	
	$('#sidebar .toggable.collapsable').live('click', function(){
		$(this).next('.widgetBox').slideUp('fast', function(){
			toggleWidgets( $(this).prev('#sidebar .toggable') );
		});	
	});
	
	slideupWidgets();
	
});
/**** END TOGGLE WIDGETS ****/

function slideupWidgets(widgetId) {
	if( widgetId ) {
		widgetId += ' ';
	} else {
		widgetId = '';
	}
	
	$(widgetId + '.expandable. + .widgetBox').slideUp("fast");
}

function toggleWidgets( elem ) {
	
	if( $(elem).hasClass('collapsable') ) {
		
		$(elem).removeClass('collapsable').addClass('expandable');
		$.cookie( $(elem).closest('section .contentBoxNav').attr('id'), 'collapsed-true', { expires: 365 } );
		
	} else if( $(elem).hasClass('expandable') ) {
		
		$(elem).removeClass('expandable').addClass('collapsable');
		$.cookie( $(elem).closest('section .contentBoxNav').attr('id'), 'collapsed-false', { expires: 365 } );

	}
	
}

function hideEmptyWidgets(){
	$('#sidebar aside section:not( :has(nav) )').parent('aside').addClass('empty_widget');
}

function updateVoidComment(comment) {
	$('#pomodoro_comments').val( comment );
}

function getCurrentPomodoroContainer() {
	containerId = '#timedBreak'
	if( $('#activePomodoro').length ) {
		containerId = '#activePomodoro';
	}
	
	return containerId;
}

function loadingFeedback(e, message) {
	$("#loader").remove();
	
	$("body").append("<p id='loader'>" + message + "</p>");

	$("#loader")
		.css("top",(loaderY + 20) + "px")
		.css("left",(loaderX + 20) + "px")
		.fadeIn("fast");
		
	loadingFeedbackHandler = function(e) {
		$("#loader").css("top",(e.pageY + 20) + "px").css("left",(e.pageX + 20) + "px");
	}
		
	$("body").bind('mousemove', loadingFeedbackHandler);
}

function removeLoadingFeedback() {
	$("#loader").remove();
	$("body").unbind('mousemove', loadingFeedbackHandler);
}

function stopCounting() {
	counting_in_progress = false;
	if( typeof timer !== 'undefined' ) {
		clearTimeout(timer);
	}
	stopAllSounds();
	resetPageTitle();
}

function stopAllSounds() {
	if( typeof ticktack !== 'undefined' ) $(ticktack)[0].pause();
	$.cookie('last_sound_played', null);
    for( i = 0; i < played_sounds.length - 1; i++ ) played_sounds[i] = false;
}

function startCounting() {
	counting_in_progress = true;
}

$(function(){
	$("#activityFilter form").live("ajax:success", function(event, data, status, xhr) {
			updateActivitiesListing(currentActivityListId(), data);
			//ajaxifyPagination();
   });
});

function removePagination(){
	$('.pagination').remove();
}

function ajaxifyPagination(){
	$('.pagination a').attr('data-remote', true).attr('data-type', 'text');
}

$(document).ready(function(){
	
	hideEmptyWidgets();
	
	$('textarea').not('#contact_request_content').elastic();
	
	$('#activityFilter input[type=text]').quickClear();
	$('#activityFilterAnalytics input[type=text]').quickClear();
	
	$('#commentsList li').live({
		mouseenter:
    	function() {
				$(this).children('.delete_comment').show();
			},
     mouseleave:
			function() {
				$(this).children('.delete_comment').hide();
			}
    });

		$('#pomodorosList li').live({
			mouseenter:
	    	function() {
					$(this).children('.delete_pomodoro').show();
				},
	     mouseleave:
				function() {
					$(this).children('.delete_pomodoro').hide();
				}
	    });
	
	// setup pomodoro timer
	decreaseTimer();
});

function decreaseTimer() {
	
	currentTime = parseInt ( $(".timer .time").attr("data-seconds") ) -1;
	
	if(currentTime <= 0){
		
		stopCounting();
		
		currentTime = 0;
		$('.time').addClass('time_is_up');

		if( $('#pomodoro_submit[value="Complete"]').length == 0 && $('#break_submit[value="End break"]').length == 0 ) {
			$.ajax({
				type: "GET",
				url: base_url + "pomodoros/update_current_form",
				dataType: "text/html",
				data: "",
				success: function(html){
					$('#currentPomodoroForm').html(html);
					$('#pomodoro_comments').elastic();
					
					if( typeof timer !== 'undefined' ) {
						clearTimeout(timer);
					}
				}
			});
		}
		
	} else if( $('.timer .time').length > 0 ) {
		
		timer = setTimeout("decreaseTimer()", 1000);
		counting_in_progress = true;
		
		refreshTimeFromServer();
		
	} else {
		// nothing to do
		return;
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

function resetPageTitle() {
	document.title = ( document.title.replace(/\[(.*)\]/, '') );
}

function refreshTimeFromServer() {
	
	if(! $('#btn_void_pomodoro').length ) return;
	
	time_since_server_time_read++;
	// bring time from server every minute (60 seconds), cause javascript is not precise enough
	if( time_since_server_time_read >= 60 ) {
		
		$.ajax({
			type: "GET",
			url: base_url + "pomodoros/get_time_from_server",
			dataType: "text/html",
			success: function(html){
				if( html ) {
					$(".timer .time").attr("data-seconds", html);
				} else {
					alert('There was a problem connecting the server. Please try reloading the page.');
				}
			}
		});
		
		time_since_server_time_read = 0;
	}
}

function announceTimeLeft(minutes) {

	if(!voice_notifications || ($.cookie('last_sound_played') == minutes) ) return;
	
	minutes = parseInt(minutes);
	if(played_sounds[minutes] !== undefined && !played_sounds[minutes]) {
		
		minutes_file = base_url + "sounds/text-to-speech/" + (parseInt(minutes) +1) + ".";
		if(minutes == 0 && $('#pomodoro_submit[value="Complete"]').length == 0) {
			minutes_file = base_url + "sounds/text-to-speech/0.";
			
			if( ring_sound ) {
				ring_file = base_url + "sounds/clocks/alarm_clock.";
				playAudioFile(ring_file, ring_sound_volume);
			}
		} 
		
		playAudioFile(minutes_file, voice_notifications_volume);
		
		played_sounds[minutes] = true;
		
		$.cookie('last_sound_played', minutes);
	} 
}

function playAudioFile(minutes_file, sound_volume) {
	//console.log(sound_file);
	soundType = "";
	if($.support.audio.ogg) {
		soundType = "ogg"
	} else if($.support.audio.mp3) {
		soundType = "mp3"
	}
	
	if( soundType ) {
		audio = new Audio(minutes_file + soundType);
		audio.volume = sound_volume;
		$(audio).attr('preload', 'auto');
		audio.play();
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
	$('#content .activityName').live('click', function(){
		
		if( $(this).parent().parent().parent().hasClass("opened") ) {
			$(this).parent().parent().parent().find('.detailsView').toggle().parent().removeClass("opened");
		} else {
			$('.opened').find('.detailsView').toggle().parent().removeClass("opened");
			$(this).parent().parent().parent().find('.detailsView').toggle().parent().addClass("opened");
			
			if( $('li[data-activity]').length > 0 ) {
				window.location.hash = $(this).parent().parent().parent().attr('data-activity');
			}
		}
		
	});
	
	revealCurrentActivity();
});

function removeInterruptionsWidget() {
	$('#interruptions').parent().remove();
}

function revealCurrentActivity() {
	if( $('#content .activityName').length == 1 ) {
		$('#content .activityName').click();
	} else if( $('li[data-activity]').size() > 0 ) {
		$( 'li[data-activity="' + window.location.hash.replace("#", '') + '"] .activityName' ).click();
	}
}

function clearExistingData() {
	if( $('#pomodorosList').length > 0 ) $('#pomodorosList').remove();
	if( $('#commentsList').length > 0 ) $('#commentsList').remove();
}

function addNewData(data, element) {
	$(element).parent().parent().after( data );
}

// formattings
$(document).ready(function(){
	$('.field_with_errors').parent().addClass("container_of_field_with_errors");
	$('#activityFilter input[type=text]').inline_label();
	$('#activityFilterAnalytics input[type=text]').inline_label();
	
	//$('#pomodoro_comments').inline_label();
	
	$('input, select, textarea, submit, button, checkbox').live('focus', function() {
		$(this).addClass("activeInput");
	});
	$('input, select, textarea, submit, button, checkbox').live('blur', function() {
		$(this).removeClass("activeInput");
	});
	
	$('#activityFilter .toggable, #activityFilterAnalytics .toggable').click(function(){
		if ( $(this).hasClass('expandable') ) {
			$(this).addClass('collapsable');
			$(this).removeClass('expandable');
			$('#activityFilter, #activityFilterAnalytics').removeClass('collapsed_toolbar');
			$('#activityFilter .row, #activityFilterAnalytics .row').show();
		} else {
			$(this).addClass('expandable');
			$(this).removeClass('collapsable');
			$('#activityFilter, #activityFilterAnalytics').addClass('collapsed_toolbar');
			$('#activityFilter .row, #activityFilterAnalytics .row').hide();
		}
	});
	
	if( ! filtering ) {
		$('#activityFilter .row').hide();
	} else {
		// show filter form
		$('#activityFilter .toggable').click();
	}
	$('#activityFilterAnalytics .row').hide();
});

// graphs
// Run the script on DOM ready:
$(function(){
	if( $('#analytics_index').length ) {
		
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
	}
});


// usability
$(function(){ 
	
	$('#hiddendp_').datepicker({
	  beforeShow: readSelected, onSelect: updateSelected, 
		dateFormat: 'm/d/yy',
    minDate: new Date(), 
    showOn: 'both', buttonImageOnly: true, buttonImage: base_url + 'assets/calendar_empty.png'});
	
	$( "#slider" ).slider({
		value: parseInt($('#activity_estimated_pomodoros').val()) ? $('#activity_estimated_pomodoros').val() : 0,
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
$(function(){
	$('#site').wrap('<div id="nonsemanticBg" />');
	
	if( $('#sidebar aside').length == $('#sidebar aside.empty_widget').length ) {
		$('#content').addClass( 'no_sidebar' );
	}
});

// tags auto-complete
$(function() {
	function split( val ) {
		return val.split( /,\s*/ );
	}
	
	function extractLast( term ) {
		return split( term ).pop();
	}

	$( "#activity_tag_list, #q_tags" )
		// don't navigate away from the field on tab when selecting an item
		.bind( "keydown", function( event ) {
			if ( event.keyCode === $.ui.keyCode.TAB &&
					$( this ).data( "autocomplete" ).menu.active ) {
				event.preventDefault();
			}
		})
		
		.autocomplete({
			source: function( request, response ) {
				$.getJSON( base_url + 'tags/user_tags', {
					term: extractLast( request.term )
				}, response );
			},
			search: function() {
				// custom minLength
				var term = extractLast( this.value );
				if ( term.length < 2 ) {
					return false;
				}
			},
			focus: function() {
				// prevent value inserted on focus
				return false;
			},
			select: function( event, ui ) {
				var terms = split( this.value );
				// remove the current input
				terms.pop();
				// add the selected item
				terms.push( ui.item.value );
				// add placeholder to get the comma-and-space at the end
				terms.push( "" );
				this.value = terms.join( ", " );
				return false;
			}
		});
});

// settings slider 1
$( function() {
	
	$('.signUpForm input.numeric').not('.volume').each(
		
		function() {
			input_id = $(this).attr('id');
			slider_id = $(this).attr('id') + '_slider';
			
			$(this).after('<div id="' + slider_id + '" class="user_slider"></div>');
			
			$( ("#" + slider_id) ).slider({
				value: parseInt( $(this).val() ) ? $(this).val() : 0,
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
});

// settings slider 2
$( function() {
	
	$('.signUpForm input.numeric.volume').each(
		
		function() {
			input_id = $(this).attr('id');
			slider_id = $(this).attr('id') + '_slider';
			
			$(this).after('<div id="' + slider_id + '" class="user_slider"></div>');
			
			$( ("#" + slider_id) ).slider({
				value: parseInt( $(this).val() ) ? $(this).val() : 0,
				min: 0,
				max: 10,
				step: 1,
				animate: true, 
				slide: function( event, ui ) {
					$( "#" + $(this).attr('id').replace('_slider', '') ).val( ui.value );
				}
			});
			
			$( "#" + input_id ).val( $("#" + slider_id).slider( "value" ) );
		}
		
	)
});

$(function(){
	draggableTodoItems();
});

function draggableTodoItems() {
	if( ! $('#todotodays').length ) return;
	
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
}

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
		overlayColor: '#E5E2D2',
		hideOnOverlayClick: false
	});
	
	$('#new_contact_request a.button').click(function(){
		parent.$.fancybox.close();
	});
});

// priority
$(function(){
	$('#activity_priority').bind('change', function(){
		$(this).removeClass( 'high medium_high medium medium_low low none' );
		$(this).addClass( $(this).val() );
	});
});

// auto focus
$(function(){
	if( $('.field_with_errors input[type=text]').size() > 0 ) {
		$('.field_with_errors input[type=text]:first').focus();
	} else if( $('.formContainer form input[type=text]').size() > 0 ) {
		$('.formContainer form input[type=text]:first').focus();
	} else {
		$('.formContainer form textarea:first').focus();
	}
	
	//$('.activeInput').focus();
});

$(function(){
	$('.video_demo').attr('target', '_blank');
});

function playTickTack() {
	
	if( ! tick_tack_sound || ! counting_in_progress) return;
	
	sound_file = base_url + "sounds/clocks/egg_timer.";
	
	soundType = "";
	if($.support.audio.ogg) {
		soundType = "ogg"
	} else if($.support.audio.mp3) {
		soundType = "mp3"
	}
	
	if( soundType ) {
		ticktack = new Audio(sound_file + soundType);
		if( tick_tack_sound_volume !== false ) ticktack.volume = tick_tack_sound_volume;
		$(ticktack).attr('preload', 'auto');
		$(ticktack).bind('ended', function() {
			if(counting_in_progress) this.play();
		});
		
		$(ticktack)[0].play();
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
});

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
	}
}