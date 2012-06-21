/*
 * Tooltip script 
 * powered by jQuery (http://www.jquery.com)
 * 
 * written by Alen Grakalic (http://cssglobe.com)
 * 
 * for more info visit http://cssglobe.com/post/1695/easiest-tooltip-and-image-preview-using-jquery
 *
 */
 


//this.tooltip = 
$(function() {	
	if( !tooltips ) return;
	
	setTimeout( 'setupTooltips()', 1000 );
});

function setupTooltips() {
	
	xOffset = 20;
	yOffset = 20;		
	
	$("[title]").live({
		mouseover:
			function(e) {
				this.t = this.title;
				this.title = "";	

				$("body").append("<p id='tooltip' class='boxShadow completeBox'>"+ this.t +"</p>");

				$("#tooltip")
					.css("top",(e.pageY - xOffset) + "px")
					.css("left",(e.pageX + yOffset) + "px")
					.delay(1500)
					.fadeIn(0)
					.delay(4000)
					.fadeOut("slow");
			},
			
		mouseout:
			function() {
				if(this.t) this.title = this.t;
				$("#tooltip").remove();
			},
			
		mousemove:
			function(e){
				$("#tooltip")
					.css("top",(e.pageY - xOffset) + "px")
					.css("left",(e.pageX + yOffset) + "px");
			}
	});
}