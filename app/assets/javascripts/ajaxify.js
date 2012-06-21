var widgets = [];
widgets['#activityStatus'] = 'widgets/activity_status';
widgets['#recentActivities'] = 'widgets/recent_activities';
widgets['#upcomingActivities'] = 'widgets/upcoming_activities';
widgets['#overdueActivities'] = 'widgets/overdue_activities';
widgets['#upcomingAppointments'] = 'widgets/upcoming_appointments';

function updateMainListing() {
	listId = currentActivityListId();
	if( listId ) updateCurrentActivityList( listId );
	
	reloadAllWidgets();
}

function currentActivityListId() {
	if( $('#activities_list').length ){
		return '#activities_list';
	} else if( $('#todotodays_list').length ) {
		return '#todotodays_list';
	} else if( $('#activity_item').length ) {
		return '#activity_item';
	} else {
		return false;
	}
}

function updateCurrentActivityList(itemSelector) {

	if( ! itemSelector ) return;
	
	$.ajax({
		type: "GET",
		url: window.location.href,
		data: "",
		dataType: "text",
		success: function(msg){
			if( msg != 'KO' ) {
				updateActivitiesListing(itemSelector, msg);
			} else {
				window.location.href = base_url;
			}
		}
	});
}

function updateActivitiesListing(itemSelector, content) {
	removePagination();
	$(itemSelector).replaceWith(content);
	revealCurrentActivity();
}

function setupRemoteHandlers() {
	$('a[data-remote]').live('click.rails', function (e) {
			$(this).css('border', '2px solid red');
      $(this).callRemote();
      e.preventDefault();
  });
}

function refreshWidget(itemSelector, actionName, additional_data, callback) {
	$.ajax({
		type: "GET",
		url: base_url + actionName,
		data: (additional_data ? additional_data : ""),
		dataType: "text",
		success: function(msg){
			sectionId = $(msg).find('section').attr('id');
			$('#' + sectionId).parent().replaceWith(msg);
			hideEmptyWidgets();
			
			if( callback ) callback.call();
		}
	});
}

function reloadAllWidgets() {
	for( var itemSelector in widgets ) {
		refreshWidget( itemSelector, widgets[itemSelector] );
	}
}

function updateActivePomodoroWidget() {
	refreshWidget( getCurrentPomodoroContainer(), 'widgets/active_pomodoro', 'render_interruptions=false', function() { if( typeof timer === 'undefined' ) decreaseTimer(); $('#pomodoro_comments').elastic(); } );
}