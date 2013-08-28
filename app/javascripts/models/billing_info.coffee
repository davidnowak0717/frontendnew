Radium.BillingInfo = Radium.Model.extend
  gatewayIdentifier: DS.attr('string')
  token: DS.attr('string')
  organisation: DS.attr('string')
  billingEmail: DS.attr('string')
  reference: DS.attr('string')
  phone: DS.attr('string')
  country: DS.attr('string')
  vat: DS.attr('string')
  hasToken: Ember.computed.bool 'token'
