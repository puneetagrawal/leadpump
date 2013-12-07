$(document).ready(function(){
	$('.seeusergauge ul li').click(function(){
		  id = $(this).attr('id').split("_")[1];
		  url = '/viewusergauge';
		  $.get(url, {id:id}, function (data) {			
		  });
	}); 
});