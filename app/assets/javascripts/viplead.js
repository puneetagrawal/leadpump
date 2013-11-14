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