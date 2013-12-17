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
//= require jquery-ui
//= require jquery_nested_form
//= require jqxcare
//= require jqxchuart
//= require jqxgauge	
//= require Chart
//= require autocomplete-rails
//= require bootstrap-datepicker
//= require appointment
//= require lead
//= require company
//= require admin
//= require color_pic/landing_color_pic
//= require invites
//= require jquery.carouFredSel-6.2.1-packed
//= require jquery.fancybox
//= require strip
//= require viplead
//= require seeusergauge
//= require saleprod
//= require ckeditor-jquery

$(document).ready(function(){
 	$('#app_date').datepicker({ dateFormat: 'yy-mm-dd' }).val(); 
 	$('#date_filter').datepicker({ dateFormat: "yy-mm-dd" }).val(); 
 	$('.filter-date').datepicker({ dateFormat: "yy-mm-dd"}).val(); 
	$('.ckeditor').ckeditor({
		  // optional config
	}); 

	$('#onlinemall_description').ckeditor({
		
        toolbar: 'Full',
        enterMode : CKEDITOR.ENTER_BR,
        shiftEnterMode: CKEDITOR.ENTER_P
	});

    $(document).on('change', "#select_vip_entry", function () {
       var search_val = $(this).val(); 
		   $.ajax({
		    url: "/viplead/filter_rec",
		    data: { 
		     "search_val": search_val
 		   }   
 		});   
    });

    $(document).on('change', "#select_opt_entry", function () {
       var search_val = $(this).val(); 
		   $.ajax({
		    url: "/viplead/filter_opt",
		    data: { 
		     "search_val": search_val
 		   }   
 		});   
    });

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

   	$(document).on('click', '.user_delete', function (){
 	  	// $(this).parent().parent().parent().remove();
   		 var search_val = $(this).parent().parent().attr("data-id"); 
		   $.ajax({
		    url: "/admin/remove_user",
		    data: { 
		     "search_user": search_val
 		   }   
 		});   
	  	
	});
	
	initialization();
	initLeadActiveSelect();
	removeFlash();	

	$(document).on('click', '.fbfetchfreinds', function (){
  		onloginCall();
	});

	$(".viewContact").click(function(){
		id = $(this).closest('tr').attr('id').split("_")[1]
		$.fancybox.open({
			href: '#contactDetails',
			type: 'inline',
			'beforeLoad' : function() {
				url = '/opt_in_leads/viewContact';
				$.post(url, {leadId:id}, function (data) {		
				});
			}
		});
	});
	$(document).on('mouseenter', 'td.leadAction', function (){
	   view = false;
	});
	$(document).on('mouseenter', 'td.leadAction *', function (){
	   view = false;
	});
	 
	$(document).on('mouseenter', '.listView', function (){
	   view = true
	});

	$(document).on('click', '.listView', function (){
		if(view){
			$.fancybox.open(this,{
				href: '#viewPopup',
				type: 'inline',
				'beforeLoad' : function() {
					fillPopupContent($(this.element));
				}
			});
		}
	});

	$(document).on("click", "#myTab li a", function(){
		id = $(this).attr('data-target');
		if(!$(this).hasClass('active')){
			$('.active').removeClass('active');
			$(this).parent('li').addClass('active');
			$(""+id).addClass('active');
		}
    });

    $(document).on("change", "#vipleadlist", function (){
		$("#vlList").html('<img src="/assets/ajax-loader.gif" style="margin:11% 0 10% 50%">');
		var vip = $(this).val();
		if ($(this).val().length == 0)
		{
			$.ajax({
				url: "/vipleads"
			});
		}
	});
    
});

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

function fillPopupContent(obj) {
	id = $(obj).attr('id');
	id = id.split("_")[1];
	act = $(obj).attr('data-action');
	url = '/home/fillpopupcontent';
	$.get(url, {id:id,act:act}, function (data) {			
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
	
	$(".container").on('click', '.span', function (event){
		if(!view){
			changeleadstatus($(this).parent().attr('id'));	
		}
	});

	$(".container").on('click', '.accnt', function (event){
		alterplantype($(this).parent().attr('id'));	
	});

	$(".container").on('change', '#status_lead', function (){
		saveLeadStatus($(this).parent().attr('id'), $(this).val())
	});

	$(".container").on('change', '#alter_plan', function (){
		savePlanType($(this).parent().attr('id'), $(this).val())
	});

	$(document).on("click",".cancelFancybox", function (){
		$.fancybox.close();
	});

	$("#assignLeadSelect").on('change', '.leadAssignSelect', function (){
		leadId = $("#leadid").val();
		assignLeadToUser($(this).val(), leadId);
	});

	$(".submitlogo").click(function (){
		$('#picture_avatar').click();
	});

	$("#picture_avatar").change(function(){
		$('#new_picture').submit();
	});

	$(document).on('keyup', '.isNormalText', function (){
        isNormalText(this);
    });

    $(document).on('click', '.closealert', function (){
        closealert(this);
    });
}

function closealert(obj){
	$(obj).parent().fadeOut('slow');
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
		$("#asignBtn_"+leadId).html('| <a class="leadAction assignLead" href="javascript:void(0)">Reassign</a>');
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

function alterplantype(id){
	id = id.split("_")[1]
	url = '/admin/alterplantype'
	$.post(url, {userId:id}, function (data) {	
	});
}

function savePlanType(id, plan){
	id = id.split("_")[1]
	url = '/admin/saveplantype';
	$.post(url, {userId:id,planId:plan}, function (data) {
		$("#plan_"+id).html('<span class="accnt">'+data.plan+'</span>');	
	});
}

function showSuccessMsg(msg){
	$("html, body").animate({ scrollTop: 0 }, "slow");
	$(".successMsg").addClass('alert alert-success').text(msg).fadeIn('slow').animate({top:"80px"});
	setTimeout(hideSuccessMsg, 3000);
}

function hideSuccessMsg(){
	if($(".flashes").text().length){
		$(".flashes").animate({top: "10px"}, 2000).fadeOut('slow');
	}
}

function removeFlash(){
	setTimeout(hideSuccessMsg, 2500);
}

function statSearchFilter(userId){
	// url = '/usersearchinadmin';
	// $.get(url, {userId:userId}, function (data) {	
	// });
}

function isNormalText(event) {
    var re = /[^0-9]+/g;
    var text = event.value.replace(re, '');
    $(event).val(text);
}

function optSearchFilter(optId){
	url = '/optsearchfilter';
	$.get(url, {optId:optId}, function (data) {	
	});
}


