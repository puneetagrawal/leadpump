$(document).ready(function(){
	initSocialInviter();
	email_list = [];
});

function initSocialInviter(){
	$(".proceed_step1").unbind();
	$(".proceed_step1").click(function(){
		movetostep1(this);
	});

	$("#inviter_select").change(function(){
		changeInviter(this);
	});

	$(document).on('click', '.select_all', function (){
		$("#select_all").prop('checked','checked');
		selectAll();
	});

	$(document).on('click', '.select_none', function (){
		$("#deselect_all").prop('checked','');
		deselectAll();
	});

	$(document).on('click', '.social_options ul li', function (){
		name = $(this).attr('name');
		executeSecondStep(name);
	});
	$(".vipseting").click(function (){
		openvipsetings();
	});
	$(".editvipseting").click(function (){
		savevipsetings(this);
	});
	$(document).on('click', '.viewVipLead', function (){
		id = $(this).closest('tr').attr('id').split("_")[1]
		$.fancybox.open({
			href: '#dashboardPopup',
			type: 'inline',
			'beforeLoad' : function() {
				url = '/showvipleads';
				$.get(url, {id:id}, function (data) {
				});
			}
		});	
	});
	$(document).on('click', '.sendFbmail', function (){
		$(this).html('<img src="/assets/ajax-loader.gif" style="">');
		username = [];
		$(".fbchekbox").each(function(){
			if($(this).is(":checked")){
				username.push($(this).attr('id').split("_")[1]+"@facebook.com");	
			}
		});

		if(username.length){
			url = '/sendIvitationToFbFriend';
			$.post(url, {username:username}, function (data) {
				alert(data.msg);
				$.fancybox.close();
				$(this).html('<a class="btn yellow" href="javascript:void(0)">Send Invitations</a>');
			});	
		}
		else{
			alert("please select members.");
			$(this).html('<a class="btn yellow" href="javascript:void(0)">Send Invitations</a>');
		}
	});

	$(document).on('click', '.sendReferralEmailBtn', function (){
		$(this).html('<img src="/assets/ajax-loader.gif" style="">');
		emaillist = [];
		$(".gmailContactChekbox").each(function(){
			if($(this).is(":checked")){
				emaillist.push($(this).parent().siblings('.email_label').text());	
			}
		});

		if(emaillist.length){
			u_email = $("#user_email").val()
			url = '/sendIvitationToGmailFriend';
			$.post(url, {emaillist:emaillist,u_email:u_email}, function (data) {
				alert(data.msg);
				$(this).html('<a class="btn yellow" href="javascript:void(0)">Send Invitations</a>');
				$.fancybox.close();
			});	
		}
		else{
			alert("please select members.");
			$(this).html('<a class="btn yellow" href="javascript:void(0)">Send Invitations</a>');
		}
	});
}

function changeInviter(obj){
	WL.logout();
	if($(obj).val() == "yahoo"){
		$(".inviter-container").html('<a class="btn yellow" href="/contacts/yahoo">Connect via Yahoo</a>');
	}
	else if($(obj).val() == "gmail"){
		$(".inviter-container").html('<a class="btn yellow" href="/contacts/gmail">Connect Via Gmail</a>');
	}
	else if($(obj).val() == "Hotmail"){
		$(".inviter-container").html('<a onclick="testt()" class="btn yellow" href="javascript:void(0)">Connect via Hotmail</a>');
	}
	else if($(obj).val() == "Msn"){
		$(".inviter-container").html('<a onclick="testt()" class="btn yellow" href="javascript:void(0)">Connect via Msn</a>');
	}
	else if($(obj).val() == "Outlook"){
		$(".inviter-container").html('<a onclick="testt()" class="btn yellow" href="javascript:void(0)">Connect via Outlook</a>');
	}
	
}

function selectAll(){
	if($(".chekboxess").length > 0){
		$(".chekboxess").each(function(){
			$(this).prop('checked', "checked");
		});
	}
}

function deselectAll(){
	var select = true;
	if($(".chekboxess").length > 0){
		$(".chekboxess").each(function(){
			if($(this).is(":checked")){
				$(this).prop('checked', false);
			}
		});
	}
}

function openvipsetings(){
	$.fancybox.open({
		href: '#vipseting',
		type: 'inline'
	});	
}

function savevipsetings(obj){
	$(obj).html('<img src="/assets/ajax-loader.gif">');
	vipon = '';
	if($(".viponsetting").is(":checked")){
		vipon = "true";
	}
	vipvalue = $("#noofvip").val();
	if(vipvalue == ''){
		vipvalue = 3;
	}
	url = '/savevipsetings';
	$.get(url, {vipon:vipon,vipvalue:vipvalue}, function (data) {	
		alert("successfully updated");
		$(obj).html('<input type="button" value="submit" name="vipsetting" class="btn yellow">');
		$.fancybox.close();
	});
}

function movetostep1(obj){
	var exit = false;
	skip = $(obj).attr('id');
	// if(skip != 'skip'){
	// 	$(".viprow").each(function() {
	// 		exit = false;
	// 		// $(this).find('p input').each(function(){
	// 		// 	if($(this).val() == '') { 
	// 		// 		exit = true;
	// 		// 		alert(" Please fill all fields, then proceed further..!!");
	// 		// 		return false;
	// 		// 	}
	// 		// });
	// 		if (exit){
	// 			return false;
	// 		}
	// 	});
	// }
	// if(!exit){
	// 	executeFirstStep(obj, skip);	
	// }
	executeFirstStep(obj, skip);
}

function executeFirstStep(obj, skip){
	btntxt = $(obj).text();
	$(obj).html('<img src="/assets/ajax-loader.gif" style="margin-left: 40px;">');
	url = '/vipleads';
	$.post(url, {inputs:formfields(), skip:skip}, function (data) {
		if(data.error){
			alert(data.error);
			$(obj).html('<a id="proceed_step_1" class="btn yellow" href="javascript:void(0)">Proceed to Next Step</a>');
		}
		else{
			$(".stepNo1").addClass('step-visited disabled').prepend('<i class="icon-ok icon-white step-mark"></i>');
			$(".stepNo2").removeClass('disabled');
		}
	});
}

function executeSecondStep(name){
	if(!$(".stepNo2").hasClass('step-visited')){
		$(".stepNo2").addClass("step-visited").prepend('<i class="icon-ok icon-white step-mark"></i>');
	}
	if(name != "common"){
		$(".social_options ul li").each(function(){
			if(!$(this).hasClass('hide')){
				$(this).addClass("hide")	
			}
		});
		$("."+name).removeClass('hide');
	}
	else{
		$.fancybox.open({
			href: '#socialinvitepopup',
			type: 'inline',
			'afterLoad' : function() {
				$("#inviter_select").val('');
				$(".inviter-container").html('');
			}
		});	
	}
}

function vipleadSearchFilter(vipleadId){
	url = '/vipleadsearchfilter';
	$.get(url, {viplead:vipleadId}, function (data) {	
	});
}




