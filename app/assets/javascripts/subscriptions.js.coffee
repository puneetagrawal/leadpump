# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'))
  window.btn = ''
  subscription.setupForm()


subscription =
  setupForm: ->
    $(document).on 'click', '.pay_btn', () ->
      if $(".fancybox-inner #terms").is(':checked')
        if $('#card_number').length
          window.btn = $('.pay_btn').html();
          $('.pay_btn').html('<img src="/assets/ajax-loader.gif" style="margin:20px 0 0 0;">');
          subscription.validateCard()
        else
          true
      else
        alert("Please accept term and conditions");
        return false
        
  
  handleStripeResponse: (status, response) ->
    if status == 200
      $('.fancybox-inner #stripe_card_token').val(response.id)
      $('.fancybox-inner #payment_form').submit()
    else
      $('.fancybox-inner #stripe_error').text(response.error.message)
      $(".pay_btn").html(window.btn)

  validateCard: ->
      card =
        email: $('.fancybox-inner #user_email').val()
        name: $('.fancybox-inner #customerName').val()
        type: $('.fancybox-inner #credit_card').val()
        number: $('.fancybox-inner #card_number').val()
        cvc: $('.fancybox-inner #card_code').val()
        expMonth: $('.fancybox-inner #card_month').val()
        expYear: $('.fancybox-inner #card_year').val()
      Stripe.createToken(card, subscription.handleStripeResponse)

