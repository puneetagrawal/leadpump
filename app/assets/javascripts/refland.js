$(document).ready(function(){
	$('.ref_submit').unbind();
	$(".ref_submit").click(function () {
		saveReferral(this);
	});

});
function saveReferral(obj){
	$(".ref_lead_error").html('');	
	$(obj).html('<img src="/assets/ajax-loader.gif" style="">');
	name = $("#name").val();
	email = $("#email").val();
	ref_id = $("#ref_id").val();
	source = $("#source").val();
	phone = $("#phone").val();
	sec = $("#sec").val();
	if(name && email && ref_id){
		url = '/savereferral';
		$.get(url, {sec:sec, name:name, email:email, phone:phone,source:source,ref_id:ref_id}, function (data) {
			$(obj).html('<button class="ref_submit" type="button">Submit</button>');
			if(data.url){
				alert("sdfsdfddddd")
				window.location = data.url;
			}
			else if(data.error){
				alert("sdfsdfddddd")
				alert(data.error)
			}
			else if(data.msg){
				alert("fidst")
				alert(data.msg)
			}
		});	
	}
	else{
		alert("Please fill required fields")
		$(obj).html('<button class="ref_submit" type="button">Submit</button>');
	}
	
}