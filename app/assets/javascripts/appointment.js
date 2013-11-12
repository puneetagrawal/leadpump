$(document).on("change", "#date_filter", function(){
    var date = $(this).val();
    $.ajax({ 
      url: "/appointments/filter_app",
      data: { 
       "appointment_date": date
          }
   });
  })