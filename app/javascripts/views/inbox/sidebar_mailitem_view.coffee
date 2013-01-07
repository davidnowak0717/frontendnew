Radium.SidebarMailItemView = Em.View.extend
  tagName: 'li'
  templateName: 'radium/inbox/sidebar_mailitem'
  classNameBindings: ['isActive:active', 'isSelected:selected']
  isSelectedBinding: 'content.isSelected'

  isActive: ( ->
    @get('content') == @get('controller.active')
  ).property('content', 'controller.active')

  checkMailItem: Em.Checkbox.extend
    click: (e) ->
      e.stopPropagation()
    change: (e) ->
      @set('parentView.content.isSelected', not @get('parentView.content.isSelected'))

  click: (e) ->
    e.stopPropagation()
    @set('controller.active',  @get('content'))
