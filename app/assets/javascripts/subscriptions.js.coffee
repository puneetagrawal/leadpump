# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'))
  subscription.setupForm()

subscription =
  setupForm: ->
    $(document).on 'click', '.pay_btn', () ->
      if $("#terms").is(':checked')
        if $('#card_number').length
          $('.pay_btn').html('<img src="/assets/ajax-loader.gif" style="margin:20px 0 0 0;">');
          subscription.validateCard()
        else
          true
      else
        alert("Please accept term and conditions");
        return false
        
  
  handleStripeResponse: (status, response) ->
    if status == 200
      $('#stripe_card_token').val(response.id)
      $('#payment_form').submit()
    else
      $('#stripe_error').text(response.error.message)
      $(".pay_btn").html('<input type="button" style="width:200px;" value="Next" data-id="4" class="next_btnlarge">')

  validateCard: ->
      card =
        email: $('#user_email').val()
        name: $('#customerName').val()
        type: $('#credit_card').val()
        number: $('#card_number').val()
        cvc: $('#card_code').val()
        expMonth: $('#card_month').val()
        expYear: $('#card_year').val()
      Stripe.createToken(card, subscription.handleStripeResponse)

