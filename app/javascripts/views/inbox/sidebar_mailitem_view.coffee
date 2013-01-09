Radium.SidebarMailItemView = Em.View.extend
  tagName: 'li'
  templateName: 'radium/inbox/sidebar_mailitem'
  classNameBindings: ['isActive:active', 'isSelected:selected', 'read']
  isSelectedBinding: 'content.isSelected'

  readBinding: 'content.read'

  isActive: ( ->
    @get('content') == @get('controller.active')
  ).property('content', 'controller.active')

  checkMailItem: Em.Checkbox.extend
    checkedBinding: 'parentView.content.isSelected'
    click: (e) ->
      e.stopPropagation()
    change: (e) ->
      @set('parentView.content.isSelected', not @get('parentView.content.isSelected'))

  click: (e) ->
    e.stopPropagation()
    @set('controller.active',  @get('content'))
