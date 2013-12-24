$(document).ready(function(){
	$('.seeusergauge ul li').click(function(){
		  $(this).find('.pull-left').append('<img class="seeuserload" src="/assets/small-load.gif" style="margin-left:30%" />');
		  id = $(this).attr('id').split("_")[1];
		  url = '/viewusergauge';
		  $.get(url, {id:id}, function (data) {	
		  $('.seeuserload').remove();		
		  });
	}); 
});