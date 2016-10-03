class Graffold::Field

  attr_reader :parent, :source, :name, :type, :required, :property, :model, :scalar, :renamed

  alias_method :scalar?, :scalar
  alias_method :required?, :required
  alias_method :renamed?, :renamed

  def initialize(name:, type:, model: nil, scalar: true, required: false, parent: nil, source: nil)
    camelName = name.camelize(:lower)

    @parent = parent
    @source = source
    @name = camelName == 'id' ? '_id' : camelName
    @type = type
    @required = required
    @property = name
    @model = model
    @scalar = scalar
    @renamed = @name != name
  end

end
