$(document).ready(function(){
	initCompanyCreateOrUpdate();
});

function initCompanyCreateOrUpdate(){
	$(".userEdit").click(function(){
		$('.formfields').html('<img src="/assets/ajax-loader.gif" style="margin:165px;float:left;">')
		id = $(this).closest('tr').attr('id');
		userId = id.split("_")[1]
		url = '/company/'+userId+'/edit'
		$.get(url, {}, function (data) {
			$(".headmsg").text("Update User");
			$(".submitUserBtn").html('<input type="button" class="btn yellow compSubmit" value="Update User">');	
			initCompanyCreateOrUpdate();			
		});
	});

	$(".compSubmit").click(function(){
		btnHtml = $(this).parent().html();
		$(this).parent().html('<img src="/assets/ajax-loader.gif" style="margin-left: 40px;>');
		id = $("#user_id").val();
		url = '/update/'+id+'';
		$.get(url, {inputs:formfields()}, function (data) {
			$('.submitUserBtn').html(btnHtml);	
			initCompanyCreateOrUpdate();
		});
	});		
}

