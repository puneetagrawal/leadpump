// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery-ui
//= require jquery.remotipart
//= require jquery_nested_form

//= require autocomplete-rails
//= require bootstrap-datepicker
//= require appointment
//= require fullcalendar.min
//= require gcal
//= require lead
//= require company
//= require admin
//= require invites

//= require jquery.fancybox
//= require strip
//= require viplead
//= require seeusergauge
//= require saleprod
//= require ckeditor-jquery
//= require wl

right_img = '<img src="/assets/right.png" style="width: 15px;margin: 0 2px 0 -20px;">';
$(document).ready(function () {
    pic_uid = '';
    $('#app_date').datepicker({ dateFormat: 'yy-mm-dd', minDate: 0 }).val();
    $('#date_filter').datepicker({ dateFormat: "yy-mm-dd" }).val();
    $('.filter-date').datepicker({ dateFormat: "yy-mm-dd"}).val();

    $(document).on('click', '.autoResponder', function () {
        // alert("message submit");
        // var sub = $("#emailsubject").val();
        // var msg = $(".ckeditor").val();
        // alert(msg);
        element = $(this);
        var sub = $("#emailsubject").val();
        var msg = $(".ckeditor").val();
        $.post(url, {sub: sub, msg: msg}, function (data) {
        });
    });


    // $(".start_feed").click(function(){
    // 	feed_id = $(this).closest('tr').attr('id').split("_")[1]
    // 	$.fancybox.open({
    // 		href: '#upgrade_terms',
    // 		type: 'inline',
    // 		'beforeLoad' : function() {
    // 			url = '/fetch_upgrade_plan';
    // 			$.post(url, {}, function (data) {
    // 			});
    // 		}
    // 	});
    // });

    $(document).on("click",".upgrade_img", function () {
        url = '/fetch_upgrade_plan';
        $.post(url, {}, function (data) {
        });
    });

    

    $(".plan_upg_mail").click(function () {
        $(this).html('<img src="/assets/ajax-loader.gif">');
        url = "/plan_upg_mail";
        $.post(url, {}, function (data) {
            alert("Message sent successfully");
            $(this).html('Send Request');
            $.fancybox.close();
        });
    });

    $(document).on("click",".cancel_plan", function () {
        $.fancybox.open({
            href: '#cancel_sub',
            type: 'inline'

        });
    });

    $(document).on("click", ".cancel_subscription", function () {
        $(this).html('<img src="/assets/ajax-loader.gif" style="width:18px;height:18px">');
        url = "/plan_cancel";
        $.post(url, {}, function (data) {
            window.location = ROOT_PATH+"thanks";
        });
    });

    $("#myTab").click(function () {
        $('#home_link').addClass('decoration');
    });

    $('#onlinemall_description').ckeditor({
        toolbar: 'Full',
        enterMode: CKEDITOR.ENTER_BR,
        shiftEnterMode: CKEDITOR.ENTER_P
    });

    $(document).on('change', "#select_vip_entry", function () {
        var search_val = $(this).val();
        $.ajax({
            url: "/viplead/filter_rec",
            data: {
                "search_val": search_val
            }
        });
    });

    $(document).on('change', "#select_opt_entry", function () {
        var search_val = $(this).val();
        $.ajax({
            url: "/viplead/filter_opt",
            data: {
                "search_val": search_val
            }
        });
    });

    $(document).on('change', '.lead_source_sel', function () {
        if ($(this).val() == "Other") {
            $("#text_div").html('<label for="lead_ "> </label><input type="text" value="" placeholder="Please specify" name="lead[lead_source]" id="lead_lead_source">');
        }
        else {
            $("#text_div").html('');
        }
    });

    $(document).on('change', '.goal_sel', function () {
        if ($(this).val() == "Other") {
            $("#text_div_2").html('<label for="lead_ "> </label><input type="text" value="" size="30" placeholder="Please specify" name="lead[goal]" id="lead_goal">');
        }
        else {
            $("#text_div_2").html('');
        }
    });

    $(document).on('click', '.user_delete', function () {
        // $(this).parent().parent().parent().remove();
        var search_val = $(this).parent().parent().attr("data-id");
        $.ajax({
            url: "/admin/remove_user",
            data: {
                "search_user": search_val
            }
        });

    });

    initialization();
    initLeadActiveSelect();
    removeFlash();

    $(document).on('click', '.fbfetchfreinds', function () {
        onloginCall();
    });

    $(document).on('change', '.action_select', function () {
        action_change($(this));
    });


    $(document).on('click', '.viewContact', function () {
        id = $(this).closest('tr').attr('id').split("_")[1];
        $.fancybox.open({
            href: '#contactDetails',
            type: 'inline',
            'beforeLoad': function () {
                url = '/opt_in_leads/viewContact';
                path = window.location.pathname;
                $.post(url, {id: id, path: path}, function (data) {
                });
            }
        });
    });
    $(document).on('mouseenter', 'td.leadAction', function () {
        view = false;
    });
    $(document).on('mouseenter', 'td.leadAction *', function () {
        view = false;
    });

    $(document).on('mouseenter', '.listView', function () {
        view = true
    });

    $(document).on('click', '.skip_profile', function () {
        $parent = $(this).parent();
        $this = $parent.html();
        $parent.html('<img src="/assets/ajax-loader.gif">');
        url = "/skip_profile";
        var id = $(this).attr('data-id');
        $.post(url, {id: id}, function (data) {
            $parent.html($this);
        });
    });

    $(document).on('click', '.listView', function () {
        if (view) {
            $.fancybox.open(this, {
                href: '#viewPopup',
                type: 'inline',
                'beforeLoad': function () {
                    fillPopupContent($(this.element), '');
                }
            });
        }
    });

    $(document).on("click", "#myTab li a", function () {
        id = $(this).attr('data-target');
        if (!$(this).hasClass('active')) {
            $('.active').removeClass('active');
            $(this).parent('li').addClass('active');
            $("" + id).addClass('active');
        }
    });

    $(document).on("change", "#vipleadlist", function () {
        $("#vlList").html('<img src="/assets/ajax-loader.gif" style="margin:11% 0 10% 50%">');
        var vip = $(this).val();
        if ($(this).val().length == 0) {
            $.ajax({
                url: "/vipleads"
            });
        }
    });

    $(document).on("click", ".done", function () {
        complete_feed = $("#complete").is(':checked');
        handle_feed_row(leadId, complete_feed);
    });

    setFooterPostion();

});

function setFooterPostion() {
    // var heart = $(".container wrapper").height() > $(window).height() - 165 ? $(".container wrapper").height() + 165 : $(window).height() - 155;
    // $(".wrapper").height(heart);
    if ($('#footer').length) {
        var docHeight = $(window).height();
        var footerHeight = $('#footer').height();
        var footerTop = $('#footer').position().top + footerHeight;
        if (footerTop < docHeight) {
            $('#footer').css('margin-top', 10 + (docHeight - footerTop) + 'px');
        }
    }
}

function createplan() {
    url = "https://api.stripe.com/v1/plans";
    $.post(url, {}, function (data) {
    });
}

function formfields() {
    new_obj = {}
    $.each($('.forms').serializeArray(), function (i, obj) {
        new_obj[obj.name] = obj.value;
    });
    return new_obj
}

function initLeadActiveSelect() {
    $(".leadActive select").change(function () {
        saveLeadStatus($(this).parent().attr('id'), $(this).val());
    });
}

function fillPopupContent(obj, lead_id) {
    id = lead_id == '' ? $(obj).attr('id').split("_")[1] : lead_id;
    act = lead_id == '' ? $(obj).attr('data-action') : 'leadpopup'
    url = '/home/fillpopupcontent';
    uri = lead_id == '' ? window.location.pathname.indexOf("leads") > -1 ? "leads" : "home" : "cal";
    $.get(url, {id: id, act: act, uri: uri}, function (data) {
    });
}

function initialization() {
    $('input[name="paymentOptionRadio"]').change(function () {
        if ($(this).attr('class') == 'creditCard') {
            $("#creditCardDiv").show();
            $("#couponDiv").hide();
        }
        else {
            $("#couponDiv").show();
            $("#creditCardDiv").hide();
        }
    });


    $(document).on("change", ".fancybox-inner #discountOnUsers", function () {
        no_of_users = $(this).val();
        options = '';
        for (i = 1; i <= no_of_users; i++) {
            options += '<option value="' + i + '">' + i + '</option>'
        }
        $(".fancybox-inner #no_of_locations").html(options)
        caclulateAmount();
    })

    $(document).on("click", ".fancybox-inner #planType_1, .fancybox-inner #planType_2", function () {
        caclulateAmount();
    });

    // $(".container").on('click', '.span', function (event){
    // 	if(!view){
    // 		changeleadstatus($(this).parent().attr('id'));
    // 	}
    // });

    // $(".container").on('click', '.plan_span', function (event){
    // 	alterplantype($(this).parent().attr('id'));
    // });

    $(".container").on('change', '#status_lead', function () {
        saveLeadStatus($(this).parent().attr('id'), $(this).val())
    });

    $(".container").on('change', '#alter_plan', function () {
        savePlanType($(this).parent().attr('id'), $(this).val())
    });

    $(document).on("click", ".cancelFancybox", function () {
        $.fancybox.close();
    });


    $(document).on("click",".submitlogo",function () {
        pic_uid = '';
        if ($("#u_id").length && $(this).closest('td').length) {
            pic_uid = $(this).closest('td').attr('id').split("_")[1];
            $('.file_' + pic_uid).click();
        }
        else if ($(this).parent().siblings('li.home_das').length) {
            pic_uid = $(this).parent().siblings('li.home_das').attr('id').split("_")[1];
            $('.file_' + pic_uid).click();
        }
        else {
            $('#picture_avatar').click();
        }
    });

    $(document).on("click", ".submit_company_logo", function () {
        $('#picture_company_logo').click();
    });

    $(document).on("change", "#picture_company_logo", function () {
        $('#c_logo').submit();
    });

    $(document).on("click", ".submit_profile_pic", function () {
        $('#picture_avatar').click();
    });

    $(document).on("click", ".submit_fb_logo", function () {
        $('#picture_fb_logo').click();
    });

    $(document).on("change", "#picture_fb_logo", function () {
        $('form#fb_logo').submit();
    });

    $(document).on("change", "#picture_avatar", function () {
        if(pic_uid != ''){
            $(".uid_"+pic_uid).submit();
        }
        else{
            $('#p_logo').submit();
        }
    });

    $(document).on("click", ".save_referals", function () {
        id = $("#ref").val();
        ref = $("#no_of_refs").val();
        url = '/save_refs';
        $.post(url, {id: id, ref: ref}, function (data) {
            $.fancybox.close();
        });
    });

    $(document).on("click", ".up_comp_logo", function () {
        $('#picture_company_logo').click();
    });

    $(document).on("click", ".ref_yes", function () {
        $("#ref").val("1");
        $('.no_ref').show();
    });

    $(document).on("click", ".ref_no", function () {
        $("#ref").val("0");
        $('.no_ref').hide();
    });

    $(document).on("click", ".submitviplogo", function () {
        $('#picture_viplogo').click();
    });
    $(document).on("change", "#picture_company_logo", function () {
        $("#company-logo").submit();
    });

    $("#picture_viplogo").change(function () {
        $('#viplogo').submit();
    });

    $(".pic_avt").change(function () {
        savepic();
    });

    $("#picture_avatar").change(function () {
        savepic();
    });

    $(document).on('keyup', '.isNormalText', function () {
        isNormalText(this);
    });

    $(document).on('keyup', '.phone_text', function () {
        change_phone_format(this);
    });

    $(document).on('click', '.closealert', function () {
        closealert(this);
    });
    $(document).on('click', '#billing_address', function () {
        $(".fancybox-inner #billing_address1").attr('checked', false);
        $(".diff_address").hide();
        $(".same_address").show();
    });
    $(document).on('click', '#billing_address1', function () {
        $(".fancybox-inner #billing_address").attr('checked', false);
        $(".same_address").hide();
        $(".diff_address").show();
    });
    $(document).on('click', '.acc_set_btn', function () {
        $(".app_header").html('<img src="/assets/ajax-loader.gif" style="margin:11% 0 10% 50%">')
        var btn_name =  $(this).attr('data-form');
        url = '/acc_setting_address';
        $.get(url, {btn_name: btn_name}, function (data) {
        });
    });

    $(document).on('click', '.save_addres', function (data){
        $(this).html('<img src="/assets/ajax-loader.gif">');
        $("#acc_set").submit();
    });
}

function closealert(obj) {
    $(obj).parent().fadeOut('slow');
}

function savepic() {
    if (pic_uid != '') {
        $('.uid_' + pic_uid).submit();
    }
    else {
        $('#c_logo').submit();
    }
}

function caclulateAmount() {
    no_of_users = 1;
    payment_type = 'monthly';
    planId = $(".fancybox-inner #planPerUserId").val();
    no_of_users = $(".fancybox-inner #discountOnUsers").val();

    if ($("input[name='planType']").is(":checked")) {
        if ($("input[name='planType']:checked").val() > 1) {
            payment_type = "yearly";
        }
    }
    url = '/home/calculateAmount'
    $.get(url, {du: no_of_users, dp: payment_type, plan_per_user_range: planId}, function (data) {
        // $("#pu").html(data.chargesPerUserStr);
        // $("#td").html(data.disAmountStr);
        $(".payAmountTxt").html(data.amountStr);
        // $(".tAmount").html("$ "+data.amount);
    });
}


// function changeleadstatus(id){
// 	id = id.split("_")[1]
// 	urls = window.location.pathname;
// 	url = '/home/changestatus'
// 	$.post(url, {leadId:id, urls:urls}, function (data) {
// 		// $("#leadActive_"+leadId).html()
// 	});
// }

function saveLeadStatus(id, status) {
    id = id.split("_")[1]
    urls = window.location.pathname;
    url = '/home/saveleadstatus';
    $.post(url, {leadId: id, status: status, urls: urls}, function (data) {
        //$("#status_"+id).html('<span class="span">'+data.status+'</span>')
    });
}

// function alterplantype(id){
// 	id = id.split("_")[1]
// 	url = '/admin/alterplantype'
// 	$.post(url, {userId:id}, function (data) {
// 	});
// }

function savePlanType(id, plan) {
    id = id.split("_")[1]
    url = '/admin/saveplantype';
    $.post(url, {userId: id, planId: plan}, function (data) {
        //$("#plan_"+id).html('<span class="plan_span">'+data.plan+'</span>');
    });
}

function showSuccessMsg(msg) {
    $("html, body").animate({ scrollTop: 0 }, "slow");
    $(".successMsg").addClass('alert alert-success').text(msg).fadeIn('slow').animate({top: "80px"});
    setTimeout(hideSuccessMsg, 3000);
}

function hideSuccessMsg() {
    if ($(".flashes").text().length) {
        $(".flashes").animate({top: "10px"}, 2000).fadeOut('slow');
    }
}

function removeFlash() {
    setTimeout(hideSuccessMsg, 2500);
}

function statSearchFilter(userId) {
    // url = '/usersearchinadmin';
    // $.get(url, {userId:userId}, function (data) {
    // });
}

function isNormalText(event) {
    var re = /[^- ^0-9]/g;
    var text = event.value.replace(re, '');
    $(event).val(text);
}

function change_phone_format(event) {
    var len = $(event).val();
    var text = "";
    if (len.length == 3 || len.length == 7) {
        text = len + '-';
        $(event).val(text);
    }
}

function optSearchFilter(optId) {
    url = '/optsearchfilter';
    $.get(url, {optId: optId}, function (data) {
    });
}

function test2() {
    url = '/print_pass';
    $.get(url, {optId: "optId"}, function (data) {
    });
}

function action_change($this) {
    var sel_val = $this.val();
    var leadId = $this.parent().attr('id').split("_")[1];
    if (sel_val == "Assign" || sel_val == "Reassign") {
        getAutoCompleteForLeadAssign(leadId);
    }
    else if (sel_val == "Task" || sel_val == "ReTask") {
        openTask($this);
    }
    else if (sel_val == "Delete") {
        deleteFancyBox($this);
    }
    else if (sel_val == "Edit") {
        leadEdit($this);
    }
}

