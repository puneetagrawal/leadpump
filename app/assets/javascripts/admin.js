$(document).ready(function(){
	mallid = '';
	dltid = '';
	plid = '';
	$('.pagination a').attr('data-remote', 'true');
	$(".mallsubmit").click(function(){
		var isValid = $("#onlinemall_mallpic_attributes_0_avatar").val()
		if (isValid != '') {
			$("#new_onlinemall").submit()
		}
		else {
			alert("please add image")
		}
	});

	$(".admincreateuser").click(function(){
		admincreateuserpopup();
	});

	$(".admincreatecompany").click(function(){
		admincreatecmpypopup();
	});

	$(document).on('click', ".createUser", function () {
		admincreateuser(this);
	});

	$(document).on('click', ".createCmpy", function () {
		admincreatecmpy(this);
	});

	$('.mall_chek').click(function(){
		checked = $(this).is(':checked'); 
		id = $(this).attr('id').split("_")[1];
		url = '/mallitemassign';
		$.get(url, {id:id,checked:checked}, function (data) {			
		});
	});

	$(document).on('click', ".edit_icon", function () {
		$(".formfields").html('<img src="/assets/ajax-loader.gif" style="margin:35%">');
		id = $(this).closest('tr').attr('id').split("_")[1];
		url = '/onlinemall/'+id+'/edit'
		$.get(url, {id:id}, function (data) {
			mallid = id;
			$(".heading").text("Update Mall Item");
			$(".submitmallbtn").html('<input type="button" value="Edit Mall Item" class="btn yellow malledit">');				
		});
	});

	$(document).on('click', ".malledit", function () {
		$("#edit_onlinemall_"+mallid).submit();
	});

	$(document).on('click', ".mallBtn", function () {
		$(this).html('<img src="/assets/ajax-loader.gif" style="">');
		url = '/mallremove'
		$.get(url, {id:dltid}, function (data) {
			alert(data.msg);
			$("#mallitem_"+dltid).remove();
			$.fancybox.close()
		});
	});

	$(document).on('click', ".delete_icon", function () {
		id = $(this).closest('tr').attr('id').split("_")[1];
		dltid = id;
		$.fancybox.open({
			href: '#deleteMallPopup',
			type: 'inline'
		});
	});

	$(document).on('click', ".viewmallitem", function () {
		id = $(this).attr('id').split("_")[1];
		url = '/viewmallitem';
		$.get(url, {id:id}, function (data) {
			
		});
	});

	$("#searchUserAc").keyup(function(e){
		if(e.keyCode == 13){
			userSearchFilter($(this).val());
		}
	});

	//$("#userlistadmin").keyup(function(e){
		//if(e.keyCode == 13){
			//paymentSearchAdminFilter($(this).val());
		//}
	//});

	//$("#vipleadlistadmin").keyup(function(e){
		//if(e.keyCode == 13){
		//	vipleadSearchAdminFilter($(this).val());
		//}
	//});
	
	//gaurav
	$("#vip_to_date").unbind();
	$(document).on("change", "#vip_to_date", function (){
		var to_date = $(this).val();
		var from_date = $('#vip_from_date').val();
		if (from_date.length == 0)
		{
			alert("Please insert the From Date field.");
			$('#vip_to_date').val("");
		}
		else if ((from_date.length != 0) && (to_date.length != 0))
		{
			$.ajax({ 
				url: "/filter_vip",
				data: { 
					"vip_to_date": to_date,
					"vip_from_date": from_date
				}
			});
		}
		else if (to_date.length == 0)
		{
			$.ajax({
				url: "/filter_vip"
			});
		}

	});

	$(document).on("change", "#invite_to_date", function (){
		var to_date = $(this).val();
		var from_date = $('#invite_from_date').val();
		if (from_date.length == 0)
		{
			alert("Please insert the From Date field.");
			$('#invite_to_date').val("");
		}
		else if ((from_date.length != 0) && (to_date.length != 0))
		{
			$.ajax({ 
				url: "/filter_invite",
				data: { 
					"invite_to_date": to_date,
					"invite_from_date": from_date
				}
			});
		}
		else if (to_date.length == 0)
		{
			$.ajax({
				url: "/filter_invite"
			});
		}

	});

	$(document).on("click", ".invite_stats", function (){
		id = $(this).closest('tr').attr('id').split("_")[1];
		$.fancybox.open({
			href: '#viewPopup',
			type: 'inline',
			'beforeLoad' : function() {
				$("#myModal").css({top:"25%"});
				url = '/invitestatsbyadmin';
				$.get(url, {inviteid:id}, function (data) {
				});
			}
		});
	});

	$("#payment_to_date").change(function (){
		var to_date = $(this).val();
		var from_date = $('#payment_from_date').val();
		$(this).html('<img src="/assets/ajax-loader.gif" style="">');
		if ($('#payment_from_date').val().length == 0)
		{
			alert("Please insert the Payment From Date field.");
			$(this).val("");
		}
		else if (($('#payment_from_date').val().length != 0) && ($('#payment_from_date').val().length != 0))
		{
			$.ajax({ 
				url: "/filter_payment",
				data: { 
					"payment_to_date": to_date,
					"payment_from_date": from_date
				}
			});
		}
		else if ($('#payment_to_date').val().length == 0)
		{
			$.ajax({
				url: "/filter_payment"
			});
		}
	});
	$("#user_to_date").unbind();
	$("#user_to_date").change(function (){
		$('#select_user_entry')[0].selectedIndex = 0;
		$('#plan_id')[0].selectedIndex = 0;
		$('#user_id')[0].selectedIndex = 0;
		var to_date = $(this).val();
		var from_date = $('#user_from_date').val();
		if (from_date == ''){
			alert("Please insert the From Date field.");
			return false
		}
		else if ((from_date.length != 0) && (to_date.length != 0)){
			$(this).html('<img src="/assets/ajax-loader.gif" style="">');
			$.ajax({ 
				url: "/filter_user",
				data: { 
					"user_to_date": to_date,
					"user_from_date": from_date
				}
			});
		}
		else if (to_date.length == 0)
		{
			$.ajax({
				url: "/filter_user",
			});
		}
	});

	//$(document).on("change","#userlistadmin",function (){
//		if ($(this).val().length == 0)
//		{
//			$.ajax({
//				url: "/admin/payment"
//			});
//		}
//	});

	$(document).on("click", ".planedit", function (){
		id = $(this).closest('tr').attr('id');
		plid = id.split("_")[1];
		$.fancybox.open({
			href: '#editPlanPopup',
			type: 'inline',
			'beforeLoad' : function() {
				url = '/editplanbyadmin';
				$.get(url, {planid:plid}, function (data) {
				});
			}
		});
	});

	$(document).on("click", "#setunlimited", function (){
		$.fancybox.open({
			href: '#editPlanPopup',
			type: 'inline',
			'beforeLoad' : function() {
				url = '/setunlimited';
				$.get(url, {plid:plid}, function (data) { 
					$("#leads_"+plid).html("unlimited");
					alert(data.msg);
					$.fancybox.close();
				});
			}
		});
	});	
	$(document).on("click", ".editplanbtn", function (){
		$(this).html('<img src="/assets/ajax-loader.gif" style="">');
		url = '/updateplan';
		leads = $("#leads").val();
		price = $("#price").val();
		$.get(url, {plid:plid,leads:leads,price:price}, function (data) { 
			alert(data.msg);
			$("#price_"+plid).html(price);
			$("#leads_"+plid).html(leads);
			$(this).html('');
			$.fancybox.close();
		});
	});	

	$("#ajax_paginate").find("a").each(function(){
		var linkElement = $(this);
		var paginationURL = linkElement.attr("href");
		linkElement.attr({"url":paginationURL, "href": "#"});
		linkElement.click(function(){
			$("#user_record").html('<img src="/images/loader.gif">');
			$("#user_record").load($(this).attr('url'));
			return false;
		});
	});	

	$(document).on('change', "#plan_id", function () {
   		$("#user_record").html('<img src="/assets/ajax-loader.gif" style="margin:11% 0 10% 50%">');
        var plan_id = $(this).val();
        var userno = $('#select_user_entry').val();
        var userid = $('#user_id').val();
		    $.ajax({
		    url: "/admin/user_per_plan",
		    data: { 
		     "plan_id": plan_id, "userno": userno, "userid": userid
 		   }   
 		});   
    });
  
    $(document).on('change', "#user_id", function () {
   		$("#user_record").html('<img src="/assets/ajax-loader.gif" style="margin:11% 0 10% 50%">');
       	var userid = $(this).val();
       	var plan_id = $('#plan_id').val();
        var userno = $('#select_user_entry').val();
		   $.ajax({
		    url: "/admin/user_per_cmpy",
		    data: { 
		     "plan_id": plan_id, "userno": userno, "userid": userid
 		   }   
 		});   
    });

	$("#select_user_entry").change(function () {
       var userno = $(this).val(); 
       var plan_id = $('#plan_id').val();
        var userid = $('#user_id').val();
		   $.ajax({
		    //url: "/admin/user_per_plan",
		    url: "/admin/user_per_cmpy",
		    data: { 
		     "plan_id": plan_id, "userno": userno, "userid": userid
 		   }   
 		});   
    });	

   $(document).on("click", ".pagination a", function(){   
   	var search_val = $("#select_user_entry").val(); 
   	console.log("ajax");
		   $.ajax({
		    data: { 
		     "search_val": search_val
 		   }
 		});  
    });
});

function admincreateuserpopup(){
	$.fancybox.open({
		href: '#createTask',
		type: 'inline',
		'beforeLoad' : function() {
			url = '/admin/usercreatepopup';
			$.get(url, {}, function (data) {		
				$(".error").html('');
			});
		}
	});
}

function admincreatecmpypopup(){
	$.fancybox.open({
		href: '#createTask',
		type: 'inline',
		'beforeLoad' : function() {
			url = '/admin/cmpycreatepopup';
			$.get(url, {}, function (data) {		
				$(".error").html('');
			});
		}
	});
}

function admincreateuser(obj){
	$(obj).html('<img src="/assets/ajax-loader.gif">');
	company = $("#users").val();
	name = $("#name").val();
	email = $("#email").val();
	if(company == '' || name == '' || email == ''){
		$(".error").html("All fields are required.");
		$(obj).html('<input type="button" class="btn yellow" value="Create" name="submitApoint">');
	}
	else{
		url = '/createUser';
		$.get(url, {email:email,company:company,name:name}, function (data) { 
			$(obj).html('<input type="button" class="btn yellow" value="Create" name="submitApoint">');
		});
	}
}

function admincreatecmpy(obj){
	$(obj).html('<img src="/assets/ajax-loader.gif">');
	name = $("#cmpyname").val();
	email = $("#cmpyemail").val();
	if(name == '' || email == ''){
		$(".error").html("All fields are required.");
		$(obj).html('<input type="button" name="submitCmpy" value="Create" class="btn yellow">');
	}
	else{
		url = '/createCmpy';
		$.get(url, {cmpyemail:email,cmpyname:name}, function (data) { 
			$(obj).html('<input type="button" name="submitCmpy" value="Create" class="btn yellow">');
		});
	}
}

function vipleadSearchAdminFilter(vipleadId){
	url = '/vipleadsearchadminfilter';
	$.get(url, {viplead:vipleadId}, function (data) { 
	});
}

function paymentSearchAdminFilter(userId){
	url = '/paymentsearchfilter';
	$.get(url, {user:userId}, function (data) { 
	});
}

function userSearchFilter(userId){
	url = '/usersearchinadmin';
	$.get(url, {userId:userId}, function (data) {	
	});
}

function invitesearchfilter(statid){
	url = "/invitesearchfilter";
	$.get(url, {stat: statid}, function (data) {
	});
}


