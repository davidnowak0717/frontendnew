define('models/todo', function(require) {
  require('ember');
  require('data');
  
  Radium.Todo = DS.Model.extend({
    created_at: DS.attr('date'),
    updated_at: DS.attr('date'),
    kind: DS.attr('string'),
    description: DS.attr('string'),
    finish_by: DS.attr('date'),
    // FIXME: DS.hasOne
    campaign: DS.hasMany(Radium.Campaign),
    // FIXME: DS.hasOne
    call_list: DS.hasMany(Radium.CallList),
    // TODO: Find out what reference refers to
    reference: null,
    contacts: DS.hasMany(Radium.Contact),
    comments: DS.hasMany(Radium.Comment),
    // FIXME: DS.hasOne
    user: DS.hasMany(Radium.User)
  });
  
});