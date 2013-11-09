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
//= require jquery_ujs
//= require jquery_nested_form
//= require_tree 
//= require bootstrap-datepicker


$(document).ready(function(){
	$("#app_date").datepicker({
    	 autoclose: true
    }).on('changeDate', function(selected){
    	app_date = new Date(selected.date.valueOf());
    	app_date.setDate(app_date.getDate(new Date(selected.date.valueOf())));
   	}); 
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

	$("#moreUserLink").click(function(){
		$('.moreUserLink').removeClass('hide')		
	})
	$(".multipleLocation").click(function(){
		$('#user_locationType').removeClass('hide')
		caclulateAmount()
	})

	$(".singleLocation").click(function(){
		$('#user_locationType').addClass('hide')
		caclulateAmount()
	})

	$("#user_discountOnUsers, #user_locationType").change(function(){
		caclulateAmount()
	})

	$("#user_planType_1, #user_planType_2").click(function(){
		caclulateAmount()	
	})
	$("#user_planType_1").attr('checked', 'checked')
	$(".singleLocation").attr('checked', 'checked')
}

function caclulateAmount(){
	no_of_users = 1
	no_of_locations = 1
	payment_type = 0
	planId = $("#user_subscriptions_attributes_0_plan_id").val()
	if ($("#user_locationType").is(":visible")) {
		no_of_locations = $("#user_locationType").val()
	}
	if($("#user_discountOnUsers").is(":visible")){
		no_of_users = $("#user_discountOnUsers").val()		
	}
	if($("input[name='user[planType]']").is(":checked")){		
		if($("input[name='user[planType]']:checked").val() > 1){
			payment_type = 10		
		}		
	}
	url = '/home/calculateAmount'
	$.get(url, {du:no_of_users, dl:no_of_locations, dp:payment_type, planId:planId}, function (data) {
		$("#pr").html(data.lcStr)
		$("#pu").html(data.bcStr)
		$("#td").html(data.totalDis)
		$("#ta").html(data.amount)
		$("#tpa").val(data.amount.split("$")[1])
        })
}
