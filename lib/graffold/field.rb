class Graffold::Field

  attr_reader :parent, :column, :association, :name, :type, :property

  def initialize(parent: nil, column: nil, association: nil, name:, type:, required: false)
    # camelize twice, calling camelize on properties with leading _ causes them to be ucased
    camelName = name.camelize(:lower).camelize(:lower)

    @parent = parent
    @column = column
    @association = association
    @name = camelName == 'id' ? '_id' : camelName
    @type = type
    @required = required
    @property = name
    @renamed = @name != name
  end

  def column?
    !@column.nil?
  end

  def association?
    !@association.nil?
  end

  def required?
    @required
  end

  def renamed?
    @renamed
  end

end
