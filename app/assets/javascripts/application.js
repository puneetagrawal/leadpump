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

}

function caclulateAmount(){
	
}
