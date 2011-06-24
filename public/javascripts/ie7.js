$(function(){
	fixIe7Layout();
	
	$('html').ajaxStop(function(){
		fixIe7Layout();
	});
});

function fixIe7Layout() {
	$('.reset_password').css('padding-left', '0').css('padding-top', '11px');
	$('#login_page').css('padding-bottom', '6px');
	$('header').css('margin-bottom', '35px');
	
	$('#activities_list .quickView').css('margin-top', '-18px');
	$('#activities_list .quickView activity').css('margin-top', '-2px');
	
	$('#activityFilter .filter').css('width', '82px');
	$('#break_submit').css('width', '100px');
	
	$('#todotodays_list .quickView').css('margin-top', '-18px');
	$('#todotodays_list .quickView activity').css('margin-top', '-2px');
	
	$('#activity_submit').css('width', '150px');
	
	$('.ui-slider').css('margin-top', '-21px');
	
	$('.explanation').css('margin-left', '28px').css('margin-top', '-19px');
	
	$('#analytics_filter_submit').css('height', '26px');
	
	$('#project_submit').css('width', '140px');
	
	
	
	$('#mainMenu').css('margin-top', '-8px');
	$('#loginMenu').css('margin-top', '-8px');
	$('.addthis_toolbox').css('margin-top', '-24px');
	$('.addthis_counter').css('margin-top', '0px');
	$('#features .article').height('260px');
	
	$('.toolbar select').css('width', '340px');
	$('#activity_project_id').css('width', '686px');
}