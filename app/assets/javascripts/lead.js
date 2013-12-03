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
	$("#deleteContent").on('click', '.leadDeleteBtn', function (){
		deleteLead(this);
	});
	$(".container").on('click', '.task', function (){
		openTask(this);
	});
	$("#assignLeadSelect").on('change', '.createLeadTask', function (){
		leadId = $("#leadid").val();
		assignLeadToUser($(this).val(), leadId);
	});
	$("#test").keyup(function(e){
		if(e.keyCode == 13){
			leadSearchFilter($(this).val())
		}
	});

}

function tasksave(){
	$(".taskBtn").click(function (){
		$(this).html('<img src="/assets/ajax-loader.gif" style="">');
		task = $("#createLeadTask").val();
		date = $("#app_date").val();
		time = $("#app_date").val()+" "+$("#hr").val()+":"+$("#min").val()+":"+$("#zon").val();
		leadId = $("#leadid").val();
		if(task == ''){
			alert("please schedule task");
		}
		else if(date == ''){
			alert("please select date");
		}
		else if($("#hr").val() == ''){
			alert("please schedule time");
		}
		else {
			url = '/leads/saveappointment';
			$.get(url, {task:task,date:date,time:time,leadId:leadId}, function (data) {
				alert(data.msg);
				$(this).html('<input type="button" style="margin:-10px 0 0 !important;width:30%;background:none repeat scroll 0 0 #FFDE52;padding:7px" id="submitApoint" value="submit" name="submitApoint">');
				$("#viewLead_"+leadId).find(".task").text("ReTask");
				$.fancybox.close();
			});
		}
		$(this).html('<input type="button" style="margin:0 !important;width:30%;background:none repeat scroll 0 0 #FFDE52" id="submitApoint" value="submit" name="submitApoint">');
	});
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
