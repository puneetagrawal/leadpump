$(document).ready(function(){
	initCompanyCreateOrUpdate();
});

function initCompanyCreateOrUpdate(){
	$(".userEdit").unbind();
	$(".container").on('click', '.userEdit', function (){
		companyEdit(this);
	});
	$(".compSubmit").unbind();
	$(".container").on('click', '.compSubmit', function (){
		companySubmit(this);
	});	
	$(".land_page_submit").unbind();
	$(".land_page_submit").click(function (){
		$(".forms").submit();
	});

	$("#landing_page_land_type").unbind();
	$("#landing_page_land_type").change(function (){
		if($(this).val() == "External landing page"){
			$(".internal_land_page").hide();
			$(".land_page_preview").hide();
			$(".externallink").show();
		}
		else{
			$(".internal_land_page").show();
			$(".land_page_preview").show();
			$(".externallink").hide();
		}
	});

	$(".land_page_preview").unbind();
	$(".land_page_preview").click(function (){
		$(this).siblings('span').html('<img src="/assets/ajax-load.gif" style="width:20px;height:20px;margin:10px">');
		url = '/previewsave';
		$.post(url, {inputs:formfields()}, function (data) {
			$("#title span").html('');
			$("#link").attr('href',ROOT_PATH+"preview/"+data.temp);
			fakeClick(document.getElementById('link'));
		});
	});	

	$(".submitFmes").unbind();
	$(".submitFmes").click(function(){
		$(this).html('<img src="/assets/ajax-loader.gif">');
		url = '/savefbmes';
		subject = $.trim($("#fbsubject").val());
		text = $.trim($(this).siblings('textarea').val());
		alert(text.length)
		if(subject.length > 140){
			alert("Subject cannot be greater than 140 characters.");
			$('.submitFmes').html('<a href="javascript:void(0)" class="btn yellow">Submit</a>');
		}
		else if(text.length > 220){
			alert("Message cannot be greater than 220 characters.");
			$('.submitFmes').html('<a href="javascript:void(0)" class="btn yellow">Submit</a>');
		}
		else{
			$.post(url, {text:text,subject:subject}, function (data) {
				alert("Message save successfully.");
				$('.submitFmes').html('<a href="javascript:void(0)" class="btn yellow">Submit</a>');
			});
		}
	});

	$(".submitTmes").unbind();
	$(".submitTmes").click(function(){
		debugger;
		$(this).html('<img src="/assets/ajax-loader.gif">');
		url = '/savetwmes';
		text = $.trim($(this).siblings('textarea').val());
		if (text.length <= 140){
			$.post(url, {text:text}, function (data) {
				alert("Message save successfully.");
				$('.submitTmes').html('<a href="javascript:void(0)" class="btn yellow">Submit</a>');
			});
		}
		else{
			alert("Message cannot be greater than 140 characters.");
			$('.submitTmes').html('<a href="javascript:void(0)" class="btn yellow">Submit</a>');
		}
	});
	$(".submitGmes").unbind();
	$(".submitGmes").click(function(){
		$(this).html('<img src="/assets/ajax-loader.gif">');
		url = '/savegmmes';
		text = $(this).siblings('textarea').val();
		subject = $.trim($("#emailsubject").val());
		if(subject.length <= 140){
			$.post(url, {text:text,subject:subject}, function (data) {
				alert("Message save successfully.");
				$('.submitGmes').html('<a href="javascript:void(0)" class="btn yellow">Submit</a>');
			});
		}
		else{
			alert("Subject Line cannot be greater than 140 characters.");
			$('.submitGmes').html('<a href="javascript:void(0)" class="btn yellow">Submit</a>');
		}
	});	
}

function fakeClick(anchorObj) {
   if(document.createEvent) {
      var evt = document.createEvent("MouseEvents"); 
      evt.initMouseEvent("click", true, true, window, 
          0, 0, 0, 0, 0, false, false, false, false, 0, null); 
      var allowDefault = anchorObj.dispatchEvent(evt);
  }
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
	$(obj).parent().html('<img src="/assets/ajax-loader.gif" style="margin-left: 40px;">');
	id = $("#user_id").val();
	url = '/company/update/'+id+'';
	$.get(url, {inputs:formfields()}, function (data) {
		showSuccessMsg("User Updated Successfully");
	});
}

