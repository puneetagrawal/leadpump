// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_nested_form
//= require_tree
//= require autocomplete-rails
//= require bootstrap-datepicker
//= require appointment


$(document).ready(function(){
	// $("#app_date").datepicker({
 //    	 autoclose: true
 //    	 dateFormat: 'dd-mm-yy'
 //    }).on('changeDate', function(selected){
 //    	app_date = new Date(selected.date.valueOf());
 //    	app_date.setDate(app_date.getDate(new Date(selected.date.valueOf())));
 //   	});

 	$('#app_date').datepicker({ dateFormat: 'yy-mm-dd' }).val(); 
 	$('#date_filter').datepicker({ dateFormat: 'yy-mm-dd' }).val(); 
	$('#defaultCountdown').countdown({until: new Date(2014, 8 - 1, 8)});
	
	initsignUpRadioBtn();
	initLeadActiveSelect();
	
});

function initLeadActiveSelect(){
	// $(".viewLead").click(function(e) {
	// 	id = $(this).attr('id');
	// 	if(!$(e.target).is('.leadAction, #status_lead, #status_lead opt')){
	// 		$.fancybox.open({
	// 			href: '#dashboardPopup',
	// 			height: 385,
	// 			width: 510,
	// 			type: 'inline',
	// 			'beforeLoad' : function() {
	// 				fillPopupContent(id)
	// 			}
	// 		});
	// 	}
	// });

	$(".leadActive select").change(function(){
		saveLeadStatus($(this).parent().attr('id'), $(this).val())
	})
}

function fillPopupContent(id) {
	id = id.split("_")[1];
	urls = window.location.pathname;
	url = '/home/fillpopupcontent';
	$.get(url, {id:id,urls:urls}, function (data) {			
	});
}

function initsignUpRadioBtn(){

	$(".assignLead").click(function(){
		leadId = $(this).parent().attr('id').split("_")[1];
		getAutoCompleteForLeadAssign(leadId);
	});

	$('input[name="paymentOptionRadio"]').change(function(){
		if($(this).attr('class') == 'creditCard'){
			$("#creditCardDiv").show();
			$("#couponDiv").hide();
		}
		else{
			$("#couponDiv").show();
			$("#creditCardDiv").hide();
		}
	});


	$("#discountOnUsers").change(function(){
		no_of_users = $(this).val()
		options = ''
		for(i=1;i<=no_of_users;i++){
			options += '<option value="'+i+'">'+i+'</option>'	
		}
		$("#no_of_locations").html(options)
		caclulateAmount()
	})

	$("#planType_1, #planType_2").click(function(){
		caclulateAmount()	
	})
	$("#planType_1").attr('checked', 'checked')
	$("#discountOnUsers").val(1)

	if ($("#discountOnUsers").val()){
		caclulateAmount()
	}			
	$(".leadFilterByName").change(function(){
		if($(this).val() != ''){
			leadFilterByName($(this).val())	
		}		
	});	
	


	initStatusSelectBox();
	initUserStatusSelectBox()
}

function initUserStatusSelectBox(){
	$(".userActive span").click(function(){
		changeUserstatus($(this).parent().attr('id'))
	})	
}

function changeUserstatus(userId){
	userId = userId.split("_")[1]
	url = '/company/changeuserstatus';
	$.get(url, {userId:userId}, function (data) {	
		// $("#leadActive_"+leadId).html()	
	});
}

function initStatusSelectBox(){
	$(".leadActive span").click(function(){
		changeleadstatus($(this).parent().attr('id'))
	})		
}

function caclulateAmount(){
	no_of_users = 1;
	payment_type = 'monthly';
	planId = $("#planPerUserId").val();
	no_of_users = $("#discountOnUsers").val();	
	
	if($("input[name='planType']").is(":checked")){		
		if($("input[name='planType']:checked").val() > 1){
			payment_type = "yearly";		
		}		
	}
	url = '/home/calculateAmount'
	$.get(url, {du:no_of_users,dp:payment_type, plan_per_user_range:planId}, function (data) {
		$("#pu").html(data.chargesPerUserStr);
		$("#td").html(data.disAmountStr);
		$(".payAmountTxt").html(data.amountStr);
		$(".tAmount").html("$ "+data.amount);		
	});
}

function getAutoCompleteForLeadAssign(id){	
	$.fancybox.open({
		href: '#leadAssignPopup',
		type: 'inline',
		'beforeLoad' : function() {
			url = '/leads/leadassign';
			$.post(url, {leadId:id}, function (data) {		
			});
		}
	});
}	

function assignLeadToUser(userId, leadId){
	url = '/leads/leadassigntouser';
	$.post(url, {leadId:leadId, userId:userId}, function (data) {	
		$("#emp_"+leadId).html(data.name);
		$("#asignBtn_"+leadId).remove();
		$("#users_"+leadId).remove();	
		$.fancybox.close();
	});
}

function changeleadstatus(id){
	id = id.split("_")[1]
	urls = window.location.pathname;
	url = '/home/changestatus'
	$.post(url, {leadId:id, urls:urls}, function (data) {	
		// $("#leadActive_"+leadId).html()	
	});
}

function saveLeadStatus(id, status){
	id = id.split("_")[1]
	urls = window.location.pathname;
	url = '/home/saveleadstatus';
	$.post(url, {leadId:id,status:status, urls:urls}, function (data) {
		$("#status_"+id).html('<span>'+data.status+'</span>')	
		initStatusSelectBox()
	});
}

function leadFilterByName(userId){
	$("#leadListContent").html('<img src="/assets/ajax-loader.gif" style="margin:100px 350px 300px">')
	url = '/leads/filterbyname';
	$.post(url, {userId:userId}, function (data) {	
		initStatusSelectBox()
	});
}

function leadSearchFilter(leadId){
	url = '/leads/leadsearchfilter';
	$.get(url, {leadId:leadId}, function (data) {	
		initStatusSelectBox()
	});
}