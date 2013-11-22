$(document).ready(function(){
	initSocialInviter();	
});

function initSocialInviter(){
	$(".proceed_step1").click(function(){
		executeFirstStep(this);
	});
	$(".social_options ul li").click(function(){
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
	$(document).on('click', '.sendReferralEmailBtn', function (){
		emaillist = [];
		$("input[name='planType']").is(":checked")
		$(".gmailContactChekbox").each(function(){
			if($(this).is(":checked")){
				alert("chekked");
				emaillist.push($(this).closest('.email_label').text());
			}
			else{
				alert("notche");
			}
		});
		url = '/sendmailinvitations';
		$.get(url, {emaillist:emaillist}, function (data) {
	});
}

function executeFirstStep(obj){
	btntxt = $(obj).text();
	$(obj).html('<img src="/assets/ajax-loader.gif" style="margin-left: 40px;">');
	 url = '/vipleads';
	 	$.post(url, {inputs:formfields()}, function (data) {
			$(".stepNo1").addClass('step-visited disabled').prepend('<i class="icon-ok icon-white step-mark"></i>');
			$(".stepNo2").removeClass('disabled');
			initSocialInviter();
	 });
}

function executeSecondStep(name){
	$(".stepNo2").addClass("step-visited disabled").prepend('<i class="icon-ok icon-white step-mark"></i>');
	$(".social_options ul li").each(function(){$(this).addClass("hide")});
	$("."+name).removeClass('hide');
	$(".stepNo3").removeClass('disabled');
}

function vipleadSearchFilter(vipleadId){
	url = '/vipleadsearchfilter';
	$.get(url, {viplead:vipleadId}, function (data) {	
	});
}