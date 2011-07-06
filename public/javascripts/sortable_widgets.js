function autoToggleWidgets( itemSelector ) {
	if( $.cookie(itemSelector.replace('#', '') ) == 'collapsed-true' && $( itemSelector ).children('.toggable').first().hasClass('collapsable') ) {
		$( itemSelector ).children('.toggable').first().click();
	}
}

/**** TOGGLE WIDGETS ****/
$(function(){
	
	$('#sidebar .toggable').live('click', function(){
		
		$(this).next('.widgetBox').toggle('fast', function(){
			
			if( $(this).prev('#sidebar .toggable').hasClass('collapsable') ) {
				
				$(this).prev('#sidebar .toggable').addClass('expandable').removeClass('collapsable');
				$.cookie( $(this).closest('section .contentBoxNav').attr('id'), 'collapsed-true' );
				
			} else if( $(this).prev('#sidebar .toggable').hasClass('expandable') ) {
				
				$(this).prev('#sidebar .toggable').addClass('collapsable').removeClass('expandable');
				$.cookie( $(this).closest('section .contentBoxNav').attr('id'), 'collapsed-false' );

			}
			
		});	
	});
	
	for( var itemSelector in widgets ) {
		autoToggleWidgets( itemSelector );
	}
	
});
/**** END TOGGLE WIDGETS ****/

/**** DRAGGABLE WIDGETS ****/
$(function(){
	$( "#sidebar" ).sortable({
		connectWith: $( "#sidebar" ),
		handle: '#sidebar li.active',
		update: function(event, ui) {
			/*
			$.ajax({
				type: "POST",
				url: base_url + "todotodays/save_sort",
				data: $('#todotodays').sortable("serialize"), 
				dataType: "text/html",
				success: function(html){

				}
			});
			*/
			console.log( $('#sidebar').sortable("serialize") );
		}
	});
});