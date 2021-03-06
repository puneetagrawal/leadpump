$(document).ready(function(){
	leadid = '';
	
	initLeadCreateOrUpdate();
});

function deleteFancyBox(obj){
	id = $(obj).closest('tr').attr('id');
	leadid = id.split("_")[1];
	$.fancybox.open({
		href: '#deleteLeadPopup',
		type: 'inline'
	});
}

function deleteLead(obj){
 	$(obj).html('<img src="/assets/ajax-loader.gif" style="">');
 	url = '/home/deleteRowByajax';
 	uri = window.location.pathname;
	$.get(url, {leadId:leadid, uri:uri}, function (data) {
		$("#viewLead_"+leadid).remove();
		leadid = '';
		$(obj).text('Delete');
		$.fancybox.close();
		alert("Deleted Successfully");
	});
}

function initLeadCreateOrUpdate(){

	$(".container").on('change', '#auto_responder_lead', function (){
		manage_auto_responder($(this));
	});

	$(".container").on('click', '.leadEdit', function (){
		leadEdit(this);
	});
	$(".container").on('click', '.leadSubmit', function (){
		leadSubmit(this);
	});		
	$(".container").on('click', '.leadDelete', function (){
		deleteFancyBox(this);
	});
	$(document).on('click', '.leadDeleteBtn', function (){
		deleteLead(this);
	});
	$(".container").on('click', '.assignLead', function (){
		leadId = $(this).parent().attr('id').split("_")[1];
		getAutoCompleteForLeadAssign(leadId);
	});
	$("#assignLeadSelect").on('change', '.leadAssignSelect', function (){
		leadId = $("#leadid").val();
		assignLeadToUser($(this).val(), leadId);
	});
	$(".container").on('click', '.task', function (){
		openTask(this);
	});
	// $(".container").on('change', '.createLeadTask', function (){
	// 	leadId = $("#leadid").val();
	// 	assignLeadToUser($(this).val(), leadId);
	// });
	$("#test").keyup(function(e){
		if(e.keyCode == 13){
			leadSearchFilter($(this).val()) ;
		}
	});
	$(document).on('click', '.read_feed', function (){
		var name = $(this).text();
		var id = $(this).attr('id').split('_')[1];
		if($("#act_"+id).text() == "Finish" || name == "Complete"){
			feed_id = $("#act_"+id).attr('data-id');
			url = '/read_feed';
			uri = window.location.pathname.indexOf("leads") > -1 ? "leads" : "home";
			$.get(url, {feed:feed_id,uri:uri}, function (data) {
				$("#act_"+id).closest('ul').remove();
				$.fancybox.close();
			});
		}
	});
	$(document).on('click', '#lead_notes', function (e){
		var id = $(this).attr('data-id');
		var notes = $("#lead_text").val();
		var url = '/add_notes';
		var uri = window.location.pathname.indexOf("leads") > -1 ? "leads" : "home" ;
		$.get(url, {id:id,notes:notes,uri:uri}, function (data) {
			$("#lead_text").val('');
			$(".note").each(function(i) {
				$(this).remove();
			});
			$(".Note_row").after(data.note_row)
			if(data.cls != 'Finish'){
				$("#act_"+id).removeClass('listView').addClass('read_feed').text('Finish');
				$("#act_"+id).removeClass('red').addClass('green');
			}
		});
	});

	$(".leadFilterByName").change(function(){
	   $('#search_lead_form').submit();	
	});	

	$(document).on("click",".column_sort",function(){
		$("#sorted_by").val($(this).attr('data-sort'));
		$("#order").val($(this).attr('data-order'));
		$('#search_lead_form').submit();
	});
}

function manage_auto_responder($this){
	var lead_id = $this.closest('tr').attr('id').split("_")[1];
	var subscribe = $this.val() == "On" ? "true" : "false";
	var url = '/auto_responder_subscribe';
	$.get(url, {subscribe:subscribe, lead_id:lead_id}, function (data) {	
	});	
}

function tasksave(){
	$(".taskBtn").click(function (){
		var btn = $(this).html();
		$(this).html('<img src="/assets/ajax-loader.gif" style="margin:8px;">');
		var task = $("#createLeadTask").val();
		var date = $("#app_date").val();
		var hr = $("#hr").val() != '' ? $("#hr").val() : 0; 
		var min = $("#min").val() != '' ? ":"+$("#min").val() : ':'+0;
		var zon = $("#zon").val() != '' ? ":"+$("#zon").val() : ':'+am;
		var time = $("#app_date").val()+" "+hr+min+zon;
		leadId = $("#leadid").val();
		if(task == ''){
			alert("please schedule task");
			$(this).html(btn);
		}
		else if(date == ''){
			alert("please select date");
			$(this).html(btn);
		}
		else if($("#hr").val() == ''){
			alert("please schedule time");
			$(this).html(btn);
		}
		else {
			url = '/leads/saveappointment';
			$.get(url, {task:task,date:date,time:time,leadId:leadId}, function (data) {
				alert(data.msg);
				$('.fc-header').remove();
				$('.fc-content').remove();
				if(window.location.pathname.indexOf('calander') > -1){
					init_cal();
				}
				$(this).html(btn);
				$("#viewLead_"+leadId).find(".task").text("ReTask");
				$.fancybox.close();
			});
		}
		
	});
}

function handle_feed_row(leadId, complete_feed){
	if(complete_feed){
		$("#feed_"+leadId).remove();
	}
	else{
		$("#act_"+leadId).removeClass('red').addClass('green').html('Finish');
	}
}

function openTask(obj){
	id = $(obj).closest('tr').attr('id');
	leadid = id.split("_")[1];
	$.fancybox.open({
		href: '#createTask',
		type: 'inline',
		'beforeLoad' : function() {
			url = '/leads/createtask';
			
			$.get(url, {leadId:leadid}, function (data) {
			});
		}
	});
}

function leadEdit(obj){
	$('.formfields').html('<img src="/assets/ajax-loader.gif" style="margin:165px 169px 200px;float:left;">') ;
	id = $(obj).closest('tr').attr('id');
	leadId = id.split("_")[1];
	url = '/leads/'+leadId+'/edit';
	$.get(url, {}, function (data) {
		$(".headmsg").text("Update Lead");
		$(".submitLeadBtn").html('<input type="button" class="btn yellow leadSubmit" value="Update Lead">');	
	});
	
}

function leadSubmit(obj){
	$(".submitLeadBtn").html('<img src="/assets/ajax-loader.gif" style="margin-left: 40px;">');
	id = $("#lead_id").val();
	url = '/update/'+id+'';
	$.get(url, {inputs:formfields()}, function (data) {
		showSuccessMsg("Lead Updated Successfully");
	});
	
}


function leadSearchFilter(leadId){
	url = '/leads/leadsearchfilter';
	$.get(url, {leadId:leadId}, function (data) {	
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
		//$("#users_"+leadId).remove();	
		$.fancybox.close();
	});
}	