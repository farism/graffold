require 'graffold/association'
require 'graffold/column'

class Graffold::Type

  attr_reader :model, :base_name, :type_name, :field_name, :file_name, :columns,
    :valid, :invalid, :scalar_fields, :associations, :invalid_associations, :valid_associations,
    :belongs_to_fields, :has_one_fields, :has_many_fields

  alias_method :valid?, :valid
  alias_method :invalid?, :invalid

  def initialize(model)
    @model = model
    @base_name = model.name.gsub('::', '')
    @type_name = base_name + 'Type'
    @field_name = base_name.camelize(:lower)
    @file_name = base_name.underscore + '_type'
    @valid = !model.nil?
    @invalid = !@valid
    @columns = model.columns.map{|c| Graffold::Column.new(self, c)}
    @scalar_fields = @columns.map{|c| c.to_field}.sort_by{|f| f.name}
    @associations = model
      .reflect_on_all_associations
      .map{|a| Graffold::Association.new(self, a)}
      .sort_by{|a| a.name}
    @invalid_associations = @associations.select{|a| a.invalid?}
    @valid_associations = @associations.select{|a| a.valid?}
    @belongs_to_fields = @valid_associations
      .select{|a| a.belongs_to?}
      .map{|a| a.to_field}
      .sort_by{|f| f.name}
    @has_one_fields = @valid_associations
      .select{|a| a.has_one?}
      .map{|a| a.to_field}
      .sort_by{|f| f.name}
    @has_many_fields = @valid_associations
      .select{|a| a.has_many?}
      .map{|a| a.to_field}
      .sort_by{|f| f.name}
  end

end
