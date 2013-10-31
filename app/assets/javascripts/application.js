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
//= require_tree .


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


	$("#user_discountOnUsers").change(function(){
		no_of_users = $(this).val()
		options = ''
		for(i=1;i<=no_of_users;i++){
			options += '<option value="'+i+'">'+i+'</option>'	
		}
		$("#no_of_locations").html(options)
		caclulateAmount()
	})

	$("#user_planType_1, #user_planType_2").click(function(){
		caclulateAmount()	
	})
	$("#user_planType_1").attr('checked', 'checked')
	$("#user_discountOnUsers").val(1)

	if ($("#user_discountOnUsers").val()){
		alert(">>>>>>")
		alert($("#user_discountOnUsers").val())
		caclulateAmount()
	}
	
	
}

function caclulateAmount(){
	no_of_users = 1
	no_of_locations = 1
	payment_type = 'monthly'
	planId = $("#user_subscriptions_attributes_0_plan_id").val()
	no_of_locations = $("#no_of_locations").val()
	no_of_users = $("#user_discountOnUsers").val()		
	
	if($("input[name='user[planType]']").is(":checked")){		
		if($("input[name='user[planType]']:checked").val() > 1){
			payment_type = "yearly"		
		}		
	}
	url = '/home/calculateAmount'
	$.get(url, {du:no_of_users, dl:no_of_locations, dp:payment_type, planId:planId}, function (data) {
		$("#pu").html(data.chargesPerUserStr)
		$("#td").html(data.disAmountStr)
		$("#ta").html(data.amountStr)
		$("#tpa").val(data.amount)
        })
}
