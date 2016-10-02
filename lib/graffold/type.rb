class Graffold::Type

  attr_reader :model, :name, :columns, :valid_associations, :invalid_associations

  def initialize(model)
    @model = model
    @columns = model.columns.map(&Graffold::Column.method(:new))
    @associations = model
      .reflect_on_all_associations
      .map(&Graffold::Association.method(:new))
      .sort_by{|a| a.name}
    @valid_associations = @associations.select{|a| a.valid?}
    @invalid_associations = @associations.select{|a| a.invalid?}
  end

  def name
    @model.name.gsub('::', '')
  end

  def field_name
    name.camelize(:lower)
  end

  def file_name
    name.underscore + '_type'
  end

  def scalar_fields
    @columns.map{|c| c.to_field}.sort_by{|f| f.name}
  end

  def belongs_to_fields
    @valid_associations.select{|a| a.belongs_to?}.map{|a| a.to_field}.sort_by{|f| f.name}
  end

  def has_one_fields
    @valid_associations.select{|a| a.has_one?}.map{|a| a.to_field}.sort_by{|f| f.name}
  end

  def has_many_fields
    @valid_associations.select{|a| a.has_many?}.map{|a| a.to_field}.sort_by{|f| f.name}
  end

  def invalid_associations
    @invalid_associations.sort_by{|a| a.name}
  end

  def valid?
    !model.nil?
  end

  def invalid?
    !valid?
  end

end
