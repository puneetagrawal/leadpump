$(document).ready(function(){
	$(document).on('click', '.signup_1',function(){
		$(this).parent().parent('form').submit();
	});

	$(document).on('click', '.allow_email',function(){
		url = '/send_verification_mail';
		var email  = $("#email_ac").val();
		$.post(url, {email:email}, function (data) {
			$(".small_popup").html(data.msg);
		});
	});

	$(document).on('click', '.unallow_email',function(){
		$(".email_provided").text('Please provide valid email.');
		$.fancybox.close();
	});

	$(document).on('click', '.contact_btn',function(){
		$(".error_name").text('');
		$(".error_email").text('');
		var $parent = $(this).parent();
		var $this = $parent.html();
		$parent.html('<img src="/assets/loader_black.gif" style="margin:5% 0 0 50%;">');
		var email  = $("#contact_email").val();
		var name  = $("#contact_name").val();
		if(name == ''){
			$(".error_name").text('Please Enter Name');
			$parent.html($this);
		}
		else if(email == ''){
			$(".error_email").text('Please Enter Email');
			$parent.html($this);
		}
		else{
			$("#contact_form").submit();
		}
	});

	$(document).on('click', '.try_free_btn',function(){
		var id = $(this).find('a').attr('data-id');
		if(id && id != ''){
			id = id.split("_");
			$.fancybox.open({
		      href: '#register_steps',
		      type: 'inline',
		      'beforeLoad' : function() {
					url = '/choose_plan';
					$.post(url, {user:id[0],plan_range:id[1]}, function (data) {		
					});
				}
		    });
		}
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
			if($("#terms").is(':checked')){
				alert("dfdsfdfds");

			}
			else{
				alert("sdfsdfsdfddddddddddddddddd");
			}
			//$("#payment_form").submit();
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
		
	});
}


