$(document).ready(function(){
	$(document).on('click', '.signup_1',function(){
		$("#signup_user").submit();
	});

	$(document).on('click', '.allow_email',function(){
		url = '/send_verification_mail';
		var email  = $("#email").val();
		$.post(url, {email:email}, function (data) {
			$(".small_popup").html(data.msg);
		});
	});

	$(document).on('click', '.unallow_email',function(){
		$(".email_provided").text('Please provide valid email.');
		$.fancybox.close();
	});

	$(document).on('click', '.signup_next',function(){
		var $parent = $(this).parent();
		var $this = $parent.html(); 
		var id = $(this).attr('data-id');
		id = parseInt(id);
		$parent.html('<img src="/assets/ajax-loader.gif" style="margin:20px 0 0 0;">');
		if(id == 2){
			if($("#password").val() != ""){
				$(".pwd_error").html('');
				save_password($parent, $this, id);	
			}
			else{
				$(".pwd_error").html('Please enter password');
				$parent.html('<input type="button" class="next_btnlarge signup_next" data-id="2" value="Next" style="width:200px;"/>')
			}
		}
		else if(id == 3){
			$("#add_form").submit();	
		}
		else if(id == 4){
			$("#payment_form").submit();
		}
	});

	$(document).on('click', '.signup_next1',function(){
		var $parent = $(this).parent();
		var $this = $parent.html(); 
		$parent.html('<img src="/assets/ajax-loader.gif" style="margin:20px 0 0 0;">');
	});
});

function save_password(par, obj, id){
	url = "/save_password";
	$.post(url, {password:$("#password").val(),user:$("#user").val()}, function (data) {
		par.html(obj)
		par.parent().animate({left: '-400px'}, 500).hide();
		$("#step"+id).show();
		$(".head_user").text("Fill Your Billing Address");
	});
}


