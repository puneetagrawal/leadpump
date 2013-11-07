# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'))
  subscription.setupForm()

subscription =
  setupForm: ->
    $('.submitSignUpForm').click ->
        alert(">>>>>>>>>>>>>>>>>>")
        if $("input[name='acceptConditions']").is(":checked")
          if($("input:radio[name='paymentOptionRadio']:checked").attr('class') == 'creditCard')
            $(".submitSignUpForm").html('<img src="/assets/ajax-loader.gif" style="float:right;margin-right:40px">')
            if $('#card_number').length
              subscription.validateCard()
              return false
            else
              true
          else
             $('#new_user')[0].submit()   
        else  
          alert("Please accept Term and conditions")
          false
  
  
  handleStripeResponse: (status, response) ->
    if status == 200
      $('#user_subscription_attributes_stripe_card_token').val(response.id)
      alert($('#user_subscription_attributes_stripe_card_token').val())
      subscription.addHiddenField()
      $('#new_user')[0].submit()
    else
      $('#stripe_error').text(response.error.message)
      $("html, body").animate({ scrollTop: 0 }, "fast");
      $(".submitSignUpForm").html('<a id="signupBtn" href="" class="btn green pull-right">Create My Account</a>')

  addHiddenField: ->
      if($('#user_discountOnUsers').is(':visible'))      
        $('#du').val($('#user_discountOnUsers').val())
      if($("#user_planType_2").is(':checked'))
        $('#dp').val(2)
      if($("#user_locationType").is(':visible'))
        $('#dl').val($("#user_locationType").val())          

  validateCard: ->
      card =
        name: $('#person_name').val()
        type: $('#credit_card').val()
        number: $('#card_number').val()
        cvc: $('#card_code').val()
        expMonth: $('#card_month').val()
        expYear: $('#card_year').val()
      Stripe.createToken(card, subscription.handleStripeResponse)

$(".submitSignUpForm").html('<a id="signupBtn" href="" class="btn green pull-right">Create My Account</a>')