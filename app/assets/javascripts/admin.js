$(document).ready(function(){
	mallid = '';
	dltid = '';
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
		$("#edit_onlinemall_"+mallid).submit();
 	});

 	$(document).on('click', ".mallBtn", function () {
 		$(this).html('<img src="/assets/ajax-loader.gif" style="">');
		url = '/mallremove'
		$.get(url, {id:dltid}, function (data) {
			alert(data.msg);
			$("#mallitem_"+dltid).remove();
			$.fancybox.close()
		});
 	});

 	$(document).on('click', ".delete_icon", function () {
		id = $(this).closest('tr').attr('id').split("_")[1];
		dltid = id;
		$.fancybox.open({
			href: '#deleteMallPopup',
			type: 'inline'
		});
	});

	$(document).on('click', ".viewmallitem", function () {
		id = $(this).attr('id').split("_")[1];
		url = '/viewmallitem';
		$.get(url, {id:id}, function (data) {
			
		});
	});

});