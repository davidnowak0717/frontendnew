Radium.Email = Radium.Message.extend({
  to: DS.attr('array'),
  from: DS.attr('array'),
  subject: DS.attr('string'),
  html: DS.attr('string'),
  sender: DS.attr('object')
});