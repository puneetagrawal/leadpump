$(document).ready(function(){
	initSocialInviter();	
});

function initSocialInviter(){
	$(".proceed_step1").click(function(){
		movetostep1(this);
	});
	$(document).on('click', '.social_options ul li', function (){
		name = $(this).attr('name');
		executeSecondStep(name);
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
			$.get(url, {username:username}, function (data) {
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
			url = '/sendIvitationToGmailFriend';
			$.get(url, {emaillist:emaillist}, function (data) {
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

function movetostep1(obj){
	var exit = false;
	skip = $(obj).attr('id');
	if(skip != 'skip'){
		$(".viprow").each(function() {
			exit = false;
			$(this).find('p input').each(function(){
				if($(this).val() == '') { 
					exit = true;
					alert(" Please fill all fields, then proceed further..!!");
					return false;
				}
			});
			if (exit){
				return false;
			}
		});
	}
	if(!exit){
		executeFirstStep(obj, skip);	
	}
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
	$(".social_options ul li").each(function(){$(this).addClass("hide")});
	$("."+name).removeClass('hide');
	$(".stepNo3").removeClass('disabled');
}

function vipleadSearchFilter(vipleadId){
	url = '/vipleadsearchfilter';
	$.get(url, {viplead:vipleadId}, function (data) {	
	});
}

