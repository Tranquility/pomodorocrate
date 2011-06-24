$(document).ready(function(){
	fixIeLayout();
});

$(function(){
	
	$.ajaxSetup({
		dataFilter: function(data, dataType) {
			if (typeof innerShiv === 'function' && dataType === 'text') {
				return innerShiv(data, false);
			}
			else {
				return data;
			}
		}
	});
	
	$('html').ajaxStop(function(){
		fixIeLayout();
	});
	
});

function fixIeLayout() {
	$('#login_page').corner();
	$('#page').corner("bottom");
	$('.top_nav').corner("10px");
	$('.toolbar_button').corner("3px");
	$('.breakButtons li').corner("7px");
	$('.todotodayMarker').corner("3px");
	$('.inProgressMarker').corner("3px");
	$('.activity_toolbar_button').corner("3px");
	$('.button').corner("3px");
	$('.flash').corner("3px");
	
	$('#mainMenu li a').corner("10px");
	$('#loginMenu li a').corner("10px");
	$('#contact_form').corner("7px");
}