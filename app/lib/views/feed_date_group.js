Radium.FeedDateGroupView = Ember.View.extend({
  dateFilterBinding: 'Radium.dashboardController.dateFilter',
  categoryFilterBinding: 'Radium.dashboardController.categoryFilter',
  isVisible: function() {
    var $children = this.$().find('.feed-item');

    if (this.get('categoryFilter') === 'everything') {
      return true;
    } else {
      if ($children.length > 0 && $children.css('display') === 'block') {
        return true;
      } else {
        return false;
      }
    }
  }.property('categoryFilter').cacheable(),
  templateName: 'feed_date_group'
});