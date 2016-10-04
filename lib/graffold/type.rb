require 'graffold/association'
require 'graffold/column'

class Graffold::Type

  attr_reader :model, :columns, :associations, :valid_associations, :invalid_associations,
    :scalar_fields, :belongs_to_fields, :has_one_fields, :has_many_fields,
    :base_name, :type_name, :field_name, :file_name

  def initialize(model)
    sort = ->(x){ x.name }
    to_field = ->(x){ x.to_field }
    @model = model
    @columns = model.columns.map{|c| Graffold::Column.new(self, c)}
    @associations = model
      .reflect_on_all_associations
      .map{|a| Graffold::Association.new(self, a)}
      .sort_by(&sort)
    @valid_associations = @associations.select{|a| a.valid?}
    @invalid_associations = @associations.select{|a| a.invalid?}
    @scalar_fields = @columns.map(&to_field).sort_by(&sort)
    @belongs_to_fields = @valid_associations.select{|a| a.belongs_to?}.map(&to_field).sort_by(&sort)
    @has_one_fields = @valid_associations.select{|a| a.has_one?}.map(&to_field).sort_by(&sort)
    @has_many_fields = @valid_associations.select{|a| a.has_many?}.map(&to_field).sort_by(&sort)
    @base_name = model.name.gsub('::', '')
    @type_name = @base_name + 'Type'
    @field_name = @base_name.camelize(:lower)
    @file_name = @base_name.underscore + '_type'
  end

  def inputs

  end

  def valid?
    !@model.nil?
  end

  def invalid?
    !valid?
  end

end
