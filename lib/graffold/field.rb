class Graffold::Field

  attr_reader :name, :type, :model, :property, :scalar, :required, :renamed, :source
  alias_method :scalar?, :scalar
  alias_method :required?, :required
  alias_method :renamed?, :renamed

  def initialize(name:, type:, model: nil, scalar: true, required: false, source: nil)
    camelName = name.camelize(:lower)
    newName = camelName == 'id' ? '_id' : camelName

    @name = newName
    @type = type
    @model = model
    @property = name
    @scalar = scalar
    @required = required
    @source = source
    @renamed = name != newName
  end

  def valid?
    @source.valid?
  end

end