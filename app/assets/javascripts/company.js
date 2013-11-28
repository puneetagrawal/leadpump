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


	$(".submitFmes").click(function(){
		$(this).html('<img src="/assets/ajax-loader.gif">');
		url = '/savefbmes';
		text = $.trim($(this).siblings('textarea').val());
		$.get(url, {text:text}, function (data) {
			alert("Message save successfully.");
			$('.submitFmes').html('<a href="javascript:void(0)" class="btn yellow">Submit</a>');
		});
	});
	$(".submitTmes").click(function(){
		$(this).html('<img src="/assets/ajax-loader.gif">');
		url = '/savetwmes';
		text = $.trim($(this).siblings('textarea').val());
		$.get(url, {text:text}, function (data) {
			alert("Message save successfully.");
			$('.submitTmes').html('<a href="javascript:void(0)" class="btn yellow">Submit</a>');
		});
	});
	$(".submitGmes").click(function(){
		$(this).html('<img src="/assets/ajax-loader.gif">');
		url = '/savegmmes';
		text = $(this).siblings('textarea').val();
		$.get(url, {text:text}, function (data) {
			alert("Message save successfully.");
			$('.submitGmes').html('<a href="javascript:void(0)" class="btn yellow">Submit</a>');
		});
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

