$(document).ready(function(){
	$('.ref_submit').unbind();
	$(document).on('click', ".ref_submit", function () {
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

			if(data.error != ''){
				$(".ref_lead_error").html(data.error);	
				$(obj).html('<button class="ref_submit" type="button">Submit</button>');
			}
			else{
				$(".form").html('<span style="font-size:25px;right:45%;top:200px;position:fixed;">'+data.msg+'</span>');		
			}

			$(".form").html('<span style="font-size:25px;right:45%;top:200px;position:fixed;">'+data.msg+'</span>');	

		});	
	}
	else{
		alert("Please fill required fields")
		$(obj).html('<button class="ref_submit" type="button">Submit</button>');
	}
	
}