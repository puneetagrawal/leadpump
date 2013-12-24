$(document).ready(function(){
	
	$(".addprod").click(function(){
		id = $(".prod-table tr:last").attr('id').split("_")[1];
		url = '/sale_prods/addnewprodrow';
		$.post(url, {id:id}, function (data) {
		});
	});
	$(document).on('click', '.remove_prod_row', function (){
		$(this).closest('tr').remove();
	});

	$('#salesCalender').datepicker({
		format: 'yy-mm-dd',
		flat: true,
		calendars: 1,
		starts: 1
	}).on('changeDate', function(ev, date) {
		$(".salesData").html('<img src="/assets/ajax-loader.gif" style="margin: 25% 50%;">')
        d = ev.date;
	    var curr_date = d.getDate();
	    var curr_month = d.getMonth() + 1; //Months are zero based
	    var curr_year = d.getFullYear();
	    date = curr_date + "/" + curr_month + "/" + curr_year
		url = '/sale_prods/showproduction';
		$.post(url, {date:date}, function (data) {
		});
    });

	$(document).on('click', '.report', function (){
		$(this).after('<img src="/assets/small-load.gif" class="report-load">');
		name = $(this).attr('name');
		id = $(this).closest('ul').attr('id').split("_")[1];
		url = '/sale_prods/showreport';
		$.post(url, {id:id,name:name}, function (data) {
			$('.report-load').remove();
		});
	});

});