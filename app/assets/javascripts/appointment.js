$(document).ready(function () {

    $(document).on("change", "#date_filter", function () {
        var date = $(this).val();
        $.ajax({
            url: "/appointments/filter_app",
            data: {
                "appointment_date": date
            }
        });
    });

    $('#appCalender').datepicker({
        format: 'mm/dd/yy',
        flat: true,
        calendars: 1,
        starts: 1
    }).on('changeDate', function (ev, date) {
            $(".appt_table").html('<img src="/assets/ajax-loader.gif" style="margin: 25% 50%;">')
            d = ev.date;
            var curr_date = d.getDate();
            var curr_month = d.getMonth() + 1; //Months are zero based
            var curr_year = d.getFullYear();
            date = curr_month + "/" + curr_date + "/" + curr_year;
            url = '/appointments/filter_app';
            $.post(url, {appointment_date: date}, function (data) {
            });
        });

});