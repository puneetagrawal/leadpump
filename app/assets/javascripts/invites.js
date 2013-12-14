$(document).ready(function(){
	if(emailAuth){
		$.fancybox.open({
			href: '#gmailContactsPopup',
			height: 385,
			width: 510,
			type: 'inline',
			'beforeLoad' : function() {
				fetchEmailContact();
			}
		});
	}
});

function fetchEmailContact(){
	$(".forms").addClass('hide');
	uri = window.location.pathname;
	if(uri.indexOf("yahoo") > -1){
		$(".social-yahoo").removeClass('hide');
	}
	else{
		$(".social-email").removeClass('hide');	
	}
	url = '/fetchContacts';
	$.get(url, {uri:uri}, function (data) {			
	});
}