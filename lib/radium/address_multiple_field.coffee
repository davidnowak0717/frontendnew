Radium.AddressMultipleField = Radium.MultipleField.extend
  template: Ember.Handlebars.compile """
    {{#with view.current}}
      <div class="addresses">
        <div class="control-group whole">
          {{view Ember.TextField classNames="field input-xlarge" valueBinding="street" placeholderBinding="view.leader" readonlyBinding="view.readonly"}}
        </div>
        <div class="control-group whole">
          {{view Ember.TextField  valueBinding="city" classNames="field input-xlarge city" placeholder="City" readonlyBinding="view.readonly"}}
        </div>
        <div class="control-group broken">
          {{view Ember.TextField valueBinding="state" classNames="field state" placeholder="State" readonlyBinding="view.readonly" }}
          {{view Ember.TextField valueBinding="zipcode" classNames="field zip" placeholder="Zip code" readonlyBinding="view.readonly"}}
        </div>
      </div>
      <div>
        <a href="#"><i class="icon-location"></i></a>
      </div>
    {{/with}}
  """

  showAddNew: ( ->
    return if @get('readonly')
    index = @get('index')
    sourceLength = (@get('parentView.labels.length') - 1)
    return false if index == sourceLength
    return false if @get('parentView.currentIndex') == sourceLength

    return true if @get('current.street.length') > 1
    return true if @get('current.city.length') > 1
    return true if @get('current.state.length') > 1
    return true if @get('current.zip.length') > 1
    false
  ).property('showdropdown', 'parentView.currentIndex','current.street', 'current.city', 'current.state', 'current.zip')
