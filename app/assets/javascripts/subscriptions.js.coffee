# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'))
  btnHtml = $('.submitSignUpForm').html()
  subscription.setupForm()

subscription =
  setupForm: ->
    $('.submitSignUpForm').click ->
      if $("input[name='acceptConditions']").is(":checked")
        if($("input:radio[name='paymentOptionRadio']:checked").attr('class') == 'creditCard')
          $(".submitSignUpForm").html('<img src="/assets/ajax-loader.gif">')
          if $('#card_number').length
            subscription.processCard()
            false
          else
            true
        else
           $('#new_user')[0].submit()   
      else  
        alert("Please accept Term and conditions")
        false
  
  processCard: ->
    card =
      type: $('#credit_card').val()
      number: $('#card_number').val()
      cvc: $('#card_code').val()
      expMonth: $('#card_month').val()
      expYear: $('#card_year').val()
    Stripe.createToken(card, subscription.handleStripeResponse)
  
  handleStripeResponse: (status, response) ->
    if status == 200
      $('#user_subscriptions_attributes_0_stripe_card_token').val(response.id)
      $($('#user_subscriptions_attributes_0_stripe_card_token').val())
      $('#new_user')[0].submit()
    else
      $('#stripe_error').text(response.error.message)
      $("html, body").animate({ scrollTop: 0 }, "fast");
     
    $(".submitSignUpForm").html('<a id="signupBtn" href="" class="btn yellow pull-right">Create My Account</a>')
    
