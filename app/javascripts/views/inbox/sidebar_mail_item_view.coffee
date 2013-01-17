Radium.SidebarMailItemView = Em.View.extend Radium.ContentIdentificationMixin,
  tagName: 'li'
  templateName: 'radium/inbox/sidebar_mail_item'
  classNameBindings: ['isActive:selected', 'isChecked:checked', 'read']

  readBinding: 'content.read'

  isChecked: (->
    @get('content.isChecked')
  ).property('content.isChecked')

  isActive: ( ->
    @get('content') == @get('controller.active')
  ).property('content', 'controller.active')

  checkMailItem: Em.Checkbox.extend
    checkedBinding: 'parentView.content.isChecked'
    click: (e) ->
      e.stopPropagation()
    change: (e) ->
      @set('parentView.content.isChecked', not @get('parentView.content.isChecked'))

  click: (e) ->
    e.stopPropagation()
    @set('controller.active',  @get('content'))
