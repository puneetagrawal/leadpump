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
	$(".social-email").removeClass('hide');
	url = '/fetchContacts';
	$.get(url, {}, function (data) {			
	});
}