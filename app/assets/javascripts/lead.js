$(document).ready(function(){
	leadid = ''
	$(".leadFilterByName").change(function(){
		if($(this).val() != ''){
			leadFilterByName($(this).val())	
		}		
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
 	url = '/leads/deleteLeadByajax'
	$.get(url, {leadId:leadid}, function (data) {
		$("#viewLead_"+leadid).remove();
		leadid = '';
		$(obj).html('');
		$.fancybox.close();
		alert("Lead Deleted Successfully");
		initLeadCreateOrUpdate();
	});
}

function initLeadCreateOrUpdate(){
	$(".leadEdit").click(function(){
		leadEdit(this);
	});

	$(".leadSubmit").click(function(){
		leadSubmit(this);
	});		
	$(".leadDelete").click(function(){
		deleteFancyBox(this);
	});
	$(".leadDeleteBtn").click(function(){
		deleteLead(this);
	});
	
	initLeadActiveSelect();
	initialization();
}



function leadEdit(obj){
	$('.formfields').html('<img src="/assets/ajax-loader.gif" style="margin:165px 169px 200px;float:left;">')
	id = $(obj).closest('tr').attr('id');
	leadId = id.split("_")[1];
	url = '/leads/'+leadId+'/edit'
	$.get(url, {}, function (data) {
		$(".headmsg").text("Update Lead");
		$(".submitLeadBtn").html('<input type="button" class="btn yellow leadSubmit" value="Update Lead">');	
		initLeadCreateOrUpdate();
	});
	
}

function leadSubmit(obj){
	$(".submitLeadBtn").html('<img src="/assets/ajax-loader.gif" style="margin-left: 40px;">');
	id = $("#lead_id").val();
	url = '/update/'+id+'';
	$.get(url, {inputs:formfields()}, function (data) {
		initLeadCreateOrUpdate();
		showSuccessMsg("Lead Updated Successfully");
	});
	
}

function leadFilterByName(userId){
	$("#leadListContent").html('<img src="/assets/ajax-loader.gif" style="margin:100px 350px 300px">')
	url = '/leads/filterbyname';
	$.post(url, {userId:userId}, function (data) {	
		initialization();
		initLeadCreateOrUpdate();
	});
}

function leadSearchFilter(leadId){
	url = '/leads/leadsearchfilter';
	$.get(url, {leadId:leadId}, function (data) {	
		initialization();
		initLeadCreateOrUpdate();
	});
}