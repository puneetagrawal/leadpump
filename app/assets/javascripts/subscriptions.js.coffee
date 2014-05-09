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
          subscription.validateCard()
          
        else
          true
      else
        alert("Please accept term and conditions");
        return false
        
  
  handleStripeResponse: (status, response) ->
    if status == 200
      $('#stripe_card_token').val(response.id)
      
    else
      $('#stripe_error').text(response.error.message)
      $(".pay_btn").html('<input type="button" class="pay_btn next_btnlarge" data-id="4" value="Next" style="width:200px;"/>')

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

