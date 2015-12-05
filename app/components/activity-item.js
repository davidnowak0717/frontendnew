import Ember from 'ember';

const {
  Component,
  computed
} = Ember;

const placeHolders = {
  'contact-create': {
    icon: 'star'
  },
  'company-create': {
    icon: 'star'
  }
};


export default Component.extend({
  classNames: ['activity', 'row'],

  key: computed('activity', function() {
    const activity = this.get('activity'),
          tag = activity.get('tag'),
          event = activity.get('event');

    return `${tag}-${event}`;
  }),

  icon: computed('activity', 'key', function() {
    return placeHolders[this.get('key')].icon;
  })
});
