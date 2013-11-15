$(document).ready(function(){
	initCompanyCreateOrUpdate();
});

function initCompanyCreateOrUpdate(){
	$(".container").on('click', '.userEdit', function (){
		companyEdit(this);
	});

	$(".container").on('click', '.compSubmit', function (){
		companySubmit(this);
	});		
}

function companyEdit(obj){
	$('.formfields').html('<img src="/assets/ajax-loader.gif" style="margin:165px 169px 0;float:left;">')
	id = $(obj).closest('tr').attr('id');
	userId = id.split("_")[1]
	url = '/company/'+userId+'/edit'
	$.get(url, {}, function (data) {
		$(".headmsg").text("Update User");
		$(".submitUserBtn").html('<input type="button" class="btn yellow compSubmit" value="Update User">');	
	});
}

function companySubmit(obj){
	btnHtml = $(obj).parent().html();
	$(obj).parent().html('<img src="/assets/ajax-loader.gif" style="margin-left: 40px;">');
	id = $("#user_id").val();
	url = '/company/update/'+id+'';
	$.get(url, {inputs:formfields()}, function (data) {
		$('.submitUserBtn').html(btnHtml);	
		showSuccessMsg("User Updated Successfully");
	});
}

