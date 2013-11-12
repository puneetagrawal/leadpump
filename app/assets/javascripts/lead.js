$(document).ready(function(){
	initLeadCreateOrUpdate();
});

function initLeadCreateOrUpdate(){
	$(".leadEdit").click(function(){
		$('.formfields').html('<img src="/assets/ajax-loader.gif" style="margin:165px;float:left;">')
		id = $(this).closest('tr').attr('id');
		leadId = id.split("_")[1]
		url = '/leads/'+leadId+'/edit'
		$.get(url, {}, function (data) {
			$(".headmsg").text("Update Lead");
			$(".submitLeadBtn").html('<input type="button" class="btn yellow leadSubmit" value="Update Lead">');	
			initLeadCreateOrUpdate();			
		});
	});

	$(".leadSubmit").click(function(){
		$(this).parent().html('<img src="/assets/ajax-loader.gif" style="margin-left: 40px;>');
		id = $("#lead_id").val();
		url = '/update/'+id+'';
		$.get(url, {inputs:formfields()}, function (data) {
			initLeadCreateOrUpdate();
		});
	});		
}

