$(document).ready(function(){
	mallid = '';
	dltid = '';
	plid = '';
	$(".mallsubmit").click(function(){
		var isValid = $("#onlinemall_mallpic_attributes_0_avatar").val()
		if (isValid != '') {
			$("#new_onlinemall").submit()
		}
		else {
			alert("please add image")
		}
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
	
	//gaurav
	$("#to_date").unbind();
	$(document).on("change", "#to_date", function (){
		var to_date = $(this).val();
		var from_date = $('#from_date').val();
		if ($('#from_date').val().length == 0)
		{
			alert("Please insert the From Date field.");
			$('#to_date').val("");
		}
		else if (($('#from_date').val().length != 0) && ($('#to_date').val().length != 0))
		{
			$.ajax({ 
				url: "/filter_vip",
				data: { 
					"vip_to_date": to_date,
					"vip_from_date": from_date
				}
			});
		}
		else if ($('#to_date').val().length == 0)
		{
			$.ajax({
				url: "/statisticsearchfilter"
			});
		}

	});

	$(document).on("click", ".invite_stats", function (){
		id = $(this).closest('tr').attr('id').split("_")[1];
		$.fancybox.open({
			href: '#invitePopup',
			type: 'inline',
			'beforeLoad' : function() {
				url = '/invitestatsbyadmin';
				$.get(url, {inviteid:id}, function (data) {
				});
			}
		});
	});
	
	$("#payment_to_date").unbind();
	$(document).on("change", "#payment_to_date", function (){
		var to_date = $(this).val();
		var from_date = $('#payment_from_date').val();
		if ($('#payment_from_date').val().length == 0)
		{
			alert("Please insert the Payment From Date field.");
			$(this).val("");
		}
		else if (($('#payment_from_date').val().length != 0) && ($(this).val().length != 0))
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
				url: "/userpaymentsearchfilter"
			});
		}
	});

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
					$("#leads_"+plid).html("Unlimited");
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
});

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


