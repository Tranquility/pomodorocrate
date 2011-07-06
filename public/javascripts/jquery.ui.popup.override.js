(function($){
/**
 * Create DialogBox by ID
 *
 * @param { String } elementID
 */
	$.extend({
		 getOrCreateDialog: function(id)
		{

			$box = $('#' + id); if (!$box.length)
			{
				$box = $('<div id="' + id + '"><p></p></div>').hide().appendTo
					('body'); 
			}
			return $box; 
		}
	});

/**
 * Override javascript alert() and wrap it into a jQuery-UI Dialog box
 *
 * @depends $.getOrCreateDialog
 *
 * @param { String } the alert message
 * @param { Object } jQuery Dialog box options
 */
	function alert(message, options)
	{

		var defaults = 
		{
			modal: true, resizable: false, buttons: 
			{
				Ok: function()
				{
					$(this).dialog('close');
				}
			}
			, show: 'fade', hide: 'fade', minHeight: 50, dialogClass: 'modal-shadow'
		}

		$alert = $.getOrCreateDialog('alert');
		// set message
		$("p", $alert).html(message);
		// init dialog
		$alert.dialog($.extend({}
		, defaults, options));
	}

/**
 * Override javascript confirm() and wrap it into a jQuery-UI Dialog box
 *
 * @depends $.getOrCreateDialog
 *
 * @param { String } the alert message
 * @param { String/Object } the confirm callback
 * @param { Object } jQuery Dialog box options
 */
	function confirm(message, callback, options)
	{

		var defaults = 
		{
			modal: true, resizable: false, buttons: 
			{
				Ok: function()
				{
					$(this).dialog('close');
					return (typeof callback == 'string') ? window.location.href =
						callback: callback();
				}
				, Cancel: function()
				{
					$(this).dialog('close');
					return false;
				}
			}
			, show: 'fade', hide: 'fade', minHeight: 50, dialogClass: 'modal-shadow'
		}

		$confirm = $.getOrCreateDialog('confirm');
		// set message
		$("p", $confirm).html(message);
		// init dialog
		$confirm.dialog($.extend({}
		, defaults, options));
	}
})(jQuery);