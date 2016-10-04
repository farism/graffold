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

  def from_column?
    !@column.nil?
  end

  def from_association?
    !@association.nil?
  end

  def create_input_field?
    (!primary_id? || foreign_key?) && !internal?
  end

  def update_input_field?
    !foreign_key? && !internal?
  end

  def foreign_key?
    @property.match /_id$/
  end

  def required?
    @required
  end

  def renamed?
    @renamed
  end

  private

  def primary_id?
    @property.match /^id$/
  end

  def internal?
    timestamp? || userstamp?
  end

  def timestamp?
    @property.match /^created_at|^updated_at|^deleted_at/
  end

  def userstamp?
    @property.match /^created_by|^updated_by|^deleted_by/
  end

end
