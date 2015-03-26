Radium.CurrencyInputComponent = Ember.TextField.extend
  actions:
    formatValue: ->
      return if @isDestroyed || @isDestroying

      accountCurrency = accountController = @get('container').lookup('controller:account').get('accountCurrency')

      settings =
        precision: accountCurrency.precision
        thousand: accountCurrency.thousand
        decimal: accountCurrency.decimal

      val = accounting.formatNumber @get('value'), settings

      @set 'value', val

  type: "text"
  timeout: 1000

  timeoutReference: null

  keyDown: (e) ->
    if e.keyCode == 13
      return @sendAction 'submit'

    accountCurrency = @get('accountCurrency')

    if timeoutReference = @get('timeoutReference')
      clearTimeout(timeoutReference)

    timeoutReference = setTimeout =>
      @send('formatValue')
    , @get('timeout')

    @set 'timeoutReference', timeoutReference

  focusOut: ->
    @send('formatValue')