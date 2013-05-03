require 'lib/radium/radio'

Radium.MultipleField = Ember.View.extend
  classNames: ['multiple-field']
  open: false
  readonly: Ember.computed.alias 'parentView.readonly'

  didInsertElement: ->
    @set 'current', @get('source').objectAt(@get('index'))

  addNew: ->
    @get('parentView').addNew()

  showDropDown: ( ->
    return false if @get('readonly')
    @get('parentView.childViews.length') > 1
  ).property('parentView.childViews.[]', 'readonly')

  showDelete: ( ->
    return false if @get('readonly')
    @get('parentView.childViews.length') > 1
  ).property('parentView.childViews.[]', 'readonly')

  showAddNew: ( ->
    return false if @get('readonly')
    name = @get('current.name')
    index = @get('index')
    currentIndex = @get('parentView.currentIndex')
    # sourceLength = (@get('parentView.labels.length') - 1)
    # return false if currentIndex == sourceLength

    @get('current.value.length') > 1 && index == currentIndex
  ).property('current.value', 'showdropdown', 'parentView.currentIndex')

  label: ( ->
    "#{@get('current.name')} #{@get('leader')}"
  ).property('leader', 'current.name')

  removeSelection: ->
    @get('parentView').removeSelection this

  toggleDropdown: ->
    @$('.dropdown-toggle').dropdown()

  layout: Ember.Handlebars.compile """
    <label class="control-label">{{view.label}}</label>
    <div class="controls" {{bindAttr class="view.parentView.isInvalid:is-invalid"}}>
      {{yield}}
    </div>
    {{#if view.showDropDown}}
      <div class="controls selector">
        <div class="btn-group mutiple-field" {{bindAttr class="view.open:open"}}>
          <button class="btn" {{action toggleDropdown target="view" bubbles="false"}}>
            {{view.current.name}}
          </button>
          <a class="btn dropdown-toggle" data-toggle="dropdown" href="#" {{action toggleDropdown target="view"}}>
            <span class="caret"></span>
          </a>
          <ul class="dropdown-menu">
            {{#each view.source}}
              <li><a {{action selectValue this target="view"}}href="#">{{unbound name}}</a></li>
            {{/each}}
          </ul>
        </div>
        {{view view.primaryRadio}}
        {{#if view.showDelete}}
          <a href="#" {{action removeSelection target="view" bubbles="false"}} >
            <i class="icon-delete"></i>
          </a>
        {{/if}}
      </div>
    {{/if}}
    {{#if view.showAddNew}}
      <div class="add-new">
        <a href="#" {{action addNew target="view" bubbles="false"}}><i class="icon-plus"></i></a>
      </div>
    {{/if}}

  """

  template: Ember.Handlebars.compile """
    {{view Ember.TextField typeBinding="view.type" classNames="field input-xlarge" valueBinding="view.current.value" placeholderBinding="view.leader" readonlyBinding="view.readonly"}}
  """

  primaryRadio: Radium.Radiobutton.extend
    leader: 'Make Primary'

    didInsertElement: ->
      @set('checked', true) if @get('parentView.current.isPrimary')

    isChecked: Ember.computed.bool 'parentView.current.isPrimary'

    click: (evt) ->
      evt.stopPropagation()
      @get('parentView.source').setEach('isPrimary', false)
      @set('parentView.current.isPrimary', true)

  selectValue: (object) ->
    @set('current', object)

  toggleDropdown: ->
    @toggleProperty 'open'
