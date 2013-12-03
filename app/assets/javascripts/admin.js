$(document).ready(function(){
	mallid = '';
	$(".mallsubmit").click(function(){
		var isValid = $("#onlinemall_mallpic_attributes_0_avatar").val()
		if (isValid != '') {
			$("#new_onlinemall").submit()
		}
		else {
			alert("please add image")
		}
	});

 	$('.mall_chek').click(function(){
		checked = $(this).is(':checked'); 
		id = $(this).attr('id').split("_")[1];
		url = '/mallitemassign';
			$.get(url, {id:id,checked:checked}, function (data) {			
		});
 	});

 	$(document).on('click', ".edit_icon", function () {
 		$(".formfields").html('<img src="/assets/ajax-loader.gif" style="margin:35%">');
		id = $(this).closest('tr').attr('id').split("_")[1];
		url = '/onlinemall/'+id+'/edit'
			$.get(url, {id:id}, function (data) {
		    mallid = id;
			$(".heading").text("Update Mall Item");
			$(".submitmallbtn").html('<input type="button" value="Edit Mall Item" class="btn yellow malledit">');				
		});
 	});

 	$(document).on('click', ".malledit", function () {
 		var isValid = $("#onlinemall_mallpic_attributes_0_avatar").val()
		if (isValid != '') {
			$('.submitmallbtn').parent().html('<img src="/assets/ajax-loader.gif" style="">');
			id = mallid;
			new_obj = {}
			alert($('.forms').serializeArray())
			$.each($('.forms').serializeArray(), function(i, obj){
				new_obj[obj.name] = obj.value	
				alert(new_obj[obj.name]);	 
			});
			url = '/mall/update/'+id+'';
			$.get(url, {id:id,inputs:new_obj,test:"dfsdfsdfdsf"}, function (data) {
				$(".heading").text("Add A Mall Item");
				$('.submitmallbtn').html('<input type="button" value="Add A Mall Item" class="btn yellow">');				
			});
		}
		else{
			alert("Please select Image.")
		}
 		
 	});

});