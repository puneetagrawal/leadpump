$(document).ready(function(){
	leadid = ''
	$(".leadFilterByName").change(function(){
		leadFilterByName($(this).val());	
	});	
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
 	$(obj).html('<img src="/assets/ajax-loader.gif" style="">')
 	url = '/home/deleteRowByajax'
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

	$(".container").on('click', '.leadEdit', function (){
		leadEdit(this);
	});
	$(".container").on('click', '.leadSubmit', function (){
		leadSubmit(this);
	});		
	$(".container").on('click', '.leadDelete', function (){
		deleteFancyBox(this);
	});
	$("#deleteLeadPopup").on('click', '.leadDeleteBtn', function (){
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
			leadSearchFilter($(this).val())
		}
	});
	$(document).on('click', '.read_feed', function (){
		var name = $(this).text();
		var id = $(this).attr('id').split('_')[1];
		if($("#act_"+id).text() == "Finish" || name == "Complete"){
			feed_id = $("#act_"+id).closest('tr').attr('data-feed');
			url = '/read_feed';
			$.get(url, {feed:feed_id}, function (data) {
				$("#act_"+id).closest('tr').remove();
				$.fancybox.close();
			});
		}
	});
	$(document).on('click', '#lead_notes', function (e){
		var id = $(this).attr('data-id');
		var notes = $("#lead_text").val();
		url = '/add_notes';
		$.get(url, {id:id,notes:notes}, function (data) {
			$(".note").each(function(i) {
				$(this).remove();
			});
			$(".Note_row").after(data.note_row)
			if(data.cls != 'Finish'){
				$("#act_"+id).removeClass('listView').addClass('read_feed').text('Finish')
				$("#act_"+id).removeClass('red').addClass('green');
			}
		});
	});

}

function tasksave(){
	$(".taskBtn").click(function (){
		$(this).html('<img src="/assets/ajax-loader.gif" style="margin:8px;">');
		task = $("#createLeadTask").val();
		date = $("#app_date").val();
		time = $("#app_date").val()+" "+$("#hr").val()+":"+$("#min").val()+":"+$("#zon").val();
		leadId = $("#leadid").val();
		var btn = '<input type="button" style="margin:-10px 0 0 !important;width:30%;background:none repeat scroll 0 0 #FFDE52;padding:7px" id="submitApoint" value="submit" name="submitApoint">'
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
	$('.formfields').html('<img src="/assets/ajax-loader.gif" style="margin:165px 169px 200px;float:left;">')
	id = $(obj).closest('tr').attr('id');
	leadId = id.split("_")[1];
	url = '/leads/'+leadId+'/edit'
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

function leadFilterByName(userId){
	$("#leadListContent").html('<img src="/assets/ajax-loader.gif" style="margin:100px 350px 300px">')
	url = '/leads/filterbyname';
	$.post(url, {userId:userId}, function (data) {	
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