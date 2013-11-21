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
//= require lead


$(document).ready(function(){
 	$("#social_invite").keyup(function(e) {
	   $("#share_text").text($(this).val());
	});

	$("#social_invite").keydown(function(e) {
	    $(".twitter-share-button").hide();
	});

	$("#social_invite").focusout(function(){
		 
		twttr.widgets.createShareButton(
				  "http://192.168.3.177:3000/tweet/ref?token="+tweet_token,
			  document.getElementById('new-button'),
			  function (el) {
			    console.log("Button created.")
			  },
			  {
			    count: 'none',
			    text: $("#share_text").text(),
			    
			  }
			);
	})

   $.getScript('https://platform.twitter.com/widgets.js', function(){
  	 	twttr.widgets.load();
	}); 


 	$('#app_date').datepicker({ dateFormat: 'yy-mm-dd' }).val(); 
 	$('#date_filter').datepicker({ dateFormat: 'yy-mm-dd' }).val(); 
	$('#defaultCountdown').countdown({until: new Date(2014, 8 - 1, 8)});


 $(document).on('change', '.lead_source_sel', function () {
        if($(this).val() == "Other") {
	      $("#text_div").html('<label for="lead_ "> </label><input type="text" value="" placeholder="Please specify" name="lead[lead_source]" id="lead_lead_source">');
	    }
	    else {
	      $("#text_div").html('');
	    }
    });

  $(document).on('change', '.goal_sel', function () {
        if($(this).val() == "Other") {
	      $("#text_div_2").html('<label for="lead_ "> </label><input type="text" value="" size="30" placeholder="Please specify" name="lead[goal]" id="lead_goal">');
	    }
	    else {
	      $("#text_div_2").html('');
	    }
    });
	
	
	initialization();
	initLeadActiveSelect();
	removeFlash();	

});

// function display_date_range(list) {
//     if(list.options[list.selectedIndex].value == 9) {
//       $("text_div").show();
//     }
//     else {
//       $("text_div").hide();
//     }
//   }


function formfields(){
	new_obj = {}
	$.each($('.forms').serializeArray(), function(i, obj){
		new_obj[obj.name] = obj.value		 
	});
	return new_obj
}

function initLeadActiveSelect(){
	$(".leadActive select").change(function(){
		saveLeadStatus($(this).parent().attr('id'), $(this).val())
	});

}

function fillPopupContent(id) {
	id = id.split("_")[1];
	urls = window.location.pathname;
	url = '/home/fillpopupcontent';
	$.get(url, {id:id,urls:urls}, function (data) {			
	});
}

function initialization(){
	$(".container").on('click', '.assignLead', function (){
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
	$("#planType_1").attr('checked', 'checked');
	$("#planType_2").attr('checked', false);
	//$("#discountOnUsers").val(1);

	if ($("#discountOnUsers").val()){
		caclulateAmount()
	}			
	
	$(".container").on('click', '.span', function (){
		changeleadstatus($(this).parent().attr('id'))
	})

	$(".container").on('change', '#status_lead', function (){
		saveLeadStatus($(this).parent().attr('id'), $(this).val())
	});
	$(".cancelFancybox").click(function (){
		$.fancybox.close();
	});

	$("#assignLeadSelect").on('change', '.leadAssignSelect', function (){
		leadId = $("#leadid").val();
		assignLeadToUser($(this).val(), leadId);
	});
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
		$("#asignBtn_"+leadId).html('| <a class="leadAction assignLead red_lead" href="javascript:void(0)">Reassign</a>');
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
		$("#status_"+id).html('<span class="span">'+data.status+'</span>')	
	});
}

function showSuccessMsg(msg){
	$(".successMsg").addClass('alert alert-success').text(msg);
	$("html, body").animate({ scrollTop: 0 }, "slow");
	setTimeout(hideSuccessMsg, 3000);
}

function hideSuccessMsg(){
	if($(".successMsg").length){
		$(".successMsg").removeClass('alert alert-success').text('');		
	}
	if($(".flashes").length){
		$(".flashes").removeClass('alert alert-success').text('');	
	}
}

function removeFlash(){
	setTimeout(hideSuccessMsg, 3000);
}