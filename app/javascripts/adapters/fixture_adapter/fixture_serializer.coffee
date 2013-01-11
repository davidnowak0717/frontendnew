Radium.FixtureSerializer = DS.RESTSerializer.extend
  init: ->
    @_super.apply(this, arguments)
    for name, transform of Radium.transforms
      @registerTransform name, transform

  materializeFromData: (record, hash) ->
    eachPolymorphicAttribute = (name, attribute) ->
      polymorphicData = @extractAttribute(record.constructor, hash, name)
      if polymorphicData
        @materializePolymorphicAssociation(record, hash, name, polymorphicData)

    if record.eachPolymorphicAttribute
      record.eachPolymorphicAttribute eachPolymorphicAttribute, this

    @_super record, hash

  typeFromString: (type) ->
    Radium.Core.typeFromString(type)

  addBelongsTo: (hash, record, key, relationship) ->
    if polymorphicFor = relationship.options.polymorphicFor
      polymorphic = record.get(polymorphicFor)
      return unless polymorphic

      hash[polymorphicFor] = {}
      hash[polymorphicFor].id = polymorphic.get('id')
      hash[polymorphicFor].type = polymorphic.get('type')
    else
      @_super.apply this, arguments

  materializePolymorphicAssociation: (record, hash, name, polymorphicData) ->
    type = record.constructor

    return unless polymorphicData.type && polymorphicData.id

    associationType = @typeFromString(polymorphicData.type)
    associations = Ember.get(type, 'associations').get(associationType).map (association) ->
      Ember.get(type, 'associationsByName').get(association.name)

    polymorphic = associations.find (association) -> association.options?.polymorphicFor == name

    Ember.assert("Could not find association with type #{@typeFromString(polymorphicData.type)} for #{name} polymorphic association in #{record.constructor}", polymorphic)
    hash["#{polymorphic.key.underscore()}_id"] = polymorphicData.id
