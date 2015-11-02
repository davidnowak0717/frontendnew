import Ember from 'ember';

const {
  Component,
  computed,
  run
} = Ember;

export default Component.extend({
  tagName: "tr",

  classNameBindings: ['item.isChecked:is-checked', 'item.read:read:unread'],
  attributeBindings: ['dataModel:data-model'],

  dataModel: computed.oneWay('item.id'),

  transposedColumns: computed('columns.[]', 'item', function() {
    const item = this.get('item');

    return this.get('columns').map((c) => {
      let result = {
        component: null,
        attrs: []
      },
      component;

      if((component = c.component)) {
        result.component = component;
      }

      result.attrs = {contact: 'item'};

      return result;
    });
  }),

  model: computed.oneWay('item'),

  modelIdentifier: null,

  modelUpdated() {
    if(this.isDestroyed || this.isDestroying) {
      return;
    }

    run.scheduleOnce('render', this, 'rerender');
  },

  _initialize: Ember.on('init', function() {
    this._super(...arguments);

    if(!this.get('model.id')) {
      return;
    }

    const model = this.get('model');

    if(!model.updatedEventKey) {
      return;
    }

    this.modelIdentifier = model.updatedEventKey();

    this.EventBus.subscribe(this.modelIdentifier, this, 'modelUpdated');
  }),

  _teardown: Ember.on('willDestroyElement', function() {
    this._super(...arguments);

    if(!this.modelIdentifier) {
      return;
    }

    this.EventBus.unsubscribe(this.modelIdentifier);
  })
});
