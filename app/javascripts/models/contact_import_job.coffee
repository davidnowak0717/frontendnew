Radium.ContactImportJob = Radium.Model.extend
  headers: DS.attr('array')
  rows: DS.attr('array')
  firstRowIsHeader: DS.attr('boolean')
  createdAt: DS.attr('datetime')
  tagNames: DS.attr('array', defaultValue: [])
  status: DS.attr('string')
