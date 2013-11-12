
$(document).ready(function(){
	$(".leadFilterByName").change(function(){
		if($(this).val() != ''){
			leadFilterByName($(this).val())	
		}		
	});	
	initLeadCreateOrUpdate();	
});

function initLeadCreateOrUpdate(){
	$(".leadEdit").click(function(){
		leadEdit(this);
	});

	$(".leadSubmit").click(function(){
		leadSubmit(this);
	});		
	initLeadActiveSelect();
	initialization();
}

function leadEdit(obj){
	$('.formfields').html('<img src="/assets/ajax-loader.gif" style="margin:165px;float:left;">')
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