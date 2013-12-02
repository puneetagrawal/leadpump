$(document).ready(function(){
 	$('.mall_chek').click(function(){
 		  checked = $(this).is(':checked'); 
 		  id = $(this).attr('id').split("_")[1];
		   url = '/mallitemassign';
			$.get(url, {id:id,checked:checked}, function (data) {			
		  })
 	}); 
});