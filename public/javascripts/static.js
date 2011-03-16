$(document).ready(function() {

	$('.thumbnail').mouseenter(function() {
		$(this).prepend('<div class="hoverArea"><div class="hoverIcon"></div></div>');
	}).mouseleave(function() {
		$(this).find('.hoverArea').remove();		
	})

	$("a.thumbnail").fancybox({
		'transitionIn'	:	'elastic',
		'transitionOut'	:	'elastic',
		'speedIn'		:	600, 
		'speedOut'		:	200, 
		'overlayShow'	:	true,
		'titlePosition' : 'outside'
	});	
	

});