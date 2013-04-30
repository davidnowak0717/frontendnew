require 'lib/radium/combobox'
require 'lib/radium/group_autocomplete'
require 'lib/radium/text_combobox'
require 'lib/radium/multiple_fields'
require 'lib/radium/multiple_field'
require 'lib/radium/phone_multiple_field'
require 'lib/radium/address_multiple_field'

Radium.HighlightInlineEditor = Radium.InlineEditorView.extend
  isValid: true

  click: (evt) ->
    tagName = evt.target.tagName.toLowerCase()

    if ['input', 'button', 'span',  'i', 'a'].indexOf(tagName) == -1
      @_super.apply this, arguments
      return

    evt.preventDefault()
    evt.stopPropagation()

  toggleEditor:  (evt) ->
    @_super.apply this, arguments

    return unless @get 'isEditing'
    Ember.run.scheduleOnce 'afterRender', this, 'highlightSelection'

  highlightSelection: ->
    @$('input[type=text],textarea').filter(':first').select()

Radium.ContactSidebarView = Radium.SidebarView.extend
  classNames: ['sidebar-panel-bordered']

  statuses: ( ->
    @get('controller.leadStatuses').map (status) ->
      Ember.Object.create
        name: status.name
        value: status.value
  ).property('controller.leadStatuses.[]')

  statusSelect: Ember.Select.extend
    contentBinding: 'parentView.statuses'
    optionValuePath: 'content.value'
    optionLabelPath: 'content.name'
    valueBinding: 'controller.status'

  groups: Radium.GroupAutoComplete.extend
    isEditableBinding: 'controller.isEditable'

  showExtraContactDetail: ->
    @$('.additional-detail').slideToggle('medium')
    @$('#detailToggle').toggleClass('icon-arrow-up icon-arrow-down')

  headerInlineEditor: Radium.HighlightInlineEditor.extend
    companyPicker: Radium.TextCombobox.extend
      classNameBindings: [':company-name']
      sourceBinding: 'controller.companyNames'
      valueBinding: 'controller.companyName'
      placeholder: 'Company'

    template: Ember.Handlebars.compile """
      {{#if view.isEditing}}
        <div class="contact-detail">
          <div class="control-group">
            <label class="control-label">Name</label>
            <div class="controls">
              {{input value=name class="field detail" placeholder="Name"}}
            </div>
          </div>
          <div class="control-group">
            <label class="control-label">Title</label>
            <div class="controls">
              {{input value=title class="field detail" placeholder="Title"}}
            </div>
          </div>
          <div class="control-group">
            <label class="control-label">Company</label>
            <div class="controls">
              {{view view.companyPicker class="field"}}
            </div>
          </div>
        </div>
      {{else}}
        {{avatar this size=medium class="img-polaroid"}}
        <div class="header">
          <div>
            <div>
              <span class="type muted">contact</span>
            </div>
            <div>
              <i class="icon-edit"></i>
            </div>
          </div>
        </div>
        <div class="name">{{name}}</div>
        <div>
          <span class="title muted">{{title}}</span>
          <span class="company">
            {{#if company}}
              {{#linkTo unimplemented}}{{companyName}}{{/linkTo}}
            {{/if}}
          </span>
        </div>
      {{/if}}
    """

  contactInlineEditor: Radium.HighlightInlineEditor.extend
    template: Ember.Handlebars.compile """
      {{#if view.isEditing}}
        <div>
          {{input type="text" value=company.website class="field" placeholder="Company Website"}}
        </div>
        <div>&nbsp;</div>
      {{else}}
        <div class="not-editing">
          {{#if company.website}}
            <a href="{{unbound company.website}}" target="_blank">{{company.website}}</a>
          {{else}}
            <span>Company Website</span>
          {{/if}}
        </div>
        <div>
          <i class="icon-edit" {{action toggleEditor target=view bubbles=false}}></i>
        </div>
      {{/if}}
    """

  emailAddressInlineEditor: Radium.HighlightInlineEditor.extend
    emailAddresses: Radium.MultipleFields.extend
      labels: ['Work','Home']
      inputType: 'email'
      leader: 'Email'
      sourceBinding: 'controller.emailAddresses'
      type: Radium.EmailAddress

    template: Ember.Handlebars.compile """
      {{#if view.isEditing}}
        <div>
          {{view view.emailAddresses}}
        </div>
      {{else}}
        <div class="control-group">
          <label class="control-label primary-item">Email <i class="icon-edit pull-right" {{action toggleEditor target=view bubbles=false}}></i></label>
          {{#if primaryEmail.value}}
            <a href="mailto:{{unbound primaryEmail.value}}">{{primaryEmail.value}}</a>
          {{else}}
            <span>Primary Email</span>
          {{/if}}
        </div>
      {{/if}}
    """

  phoneInlineEditor: Radium.HighlightInlineEditor.extend
    phoneNumbers: Radium.MultipleFields.extend
      labels: ['Mobile','Work','Home']
      leader: 'Phone'
      sourceBinding: 'controller.phoneNumbers'
      viewType: Radium.PhoneMultipleField
      type: Radium.PhoneNumber
    template: Ember.Handlebars.compile """
      {{#if view.isEditing}}
        <div>
          {{view view.phoneNumbers}}
        </div>
      {{else}}
        <div class="control-group">
          <label class="control-label primary-item">Phone <i class="icon-edit pull-right" {{action toggleEditor target=view bubbles=false}}></i></label>
          <div class="phone-section">
          <div>
            {{#if primaryPhone.value}}
              <a href="tel:{{unbound primaryPhone.value}}">{{primaryPhone.value}}</a>
            {{else}}
              <span>Primary phone number</span>
            {{/if}}
          </div>
          {{#if primaryPhone.value}}
            <div>
              <button class="btn btn-success">
                <i class="icon-call"></i>
              </button>
            </div>
          {{/if}}
          </div>
        </div>
      {{/if}}
    """

  aboutInlineEditor: Radium.HighlightInlineEditor.extend
    textArea: Radium.TextArea.extend(Ember.TargetActionSupport,
       click: (event) ->
        event.stopPropagation()

      insertNewline: ->
        @get('parentView').toggleEditor()
    )
    template: Ember.Handlebars.compile """
      <div>
        {{#if view.isEditing}}
          <h2>About</h2>
          <div>
            {{view view.textArea class="field" valueBinding=view.value placeholder="About"}}
          </div>
        {{else}}
          <h2>About <i class="icon-edit pull-right" {{action toggleEditor target=view bubbles=false}}></i></h2>
          <div>
            {{#if about}}
            <span>{{about}}</span>
            {{else}}
            <span>&nbsp;</span>
            {{/if}}
          </div>
        {{/if}}
      </div>
    """
