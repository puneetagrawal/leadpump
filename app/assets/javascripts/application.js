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
//= require autocomplete-rails


$(document).ready(function(){
	initsignUpRadioBtn()
	
})

function initsignUpRadioBtn(){
	$('input[name="paymentOptionRadio"]').change(function(){
		if($(this).attr('class') == 'creditCard'){
			$("#creditCardDiv").show()
			$("#couponDiv").hide()
		}
		else{
			$("#couponDiv").show()
			$("#creditCardDiv").hide()
		}
	})


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
		$("#ta").html(data.amountStr);
    });
}

function getAutoCompleteForLeadAssign(id){
	$(".selectBox").html('')
	url = '/leads/leadassign';
	$.post(url, {leadId:id}, function (data) {		
    });
}

function assignLeadToUser(userId, leadId){
	url = '/leads/leadassigntouser';
	$.post(url, {leadId:leadId, userId:userId}, function (data) {	
		$("#emp_"+leadId).html(data.name)
		$("#asignBtn_"+leadId).remove()
		$("#users_"+leadId).remove()	
    });
}