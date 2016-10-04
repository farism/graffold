require 'graffold/field'

class Graffold::Column

  attr_reader :parent, :column, :name, :type

  def initialize(parent, column)
    @parent = parent
    @column = column
    @name = column.name
    @type = sql_to_graphql_type(column.sql_type)
  end

  def required?
    !@column.null
  end

  def to_field
    Graffold::Field.new(parent: @parent, column: @column, name: @name, required: required?, type: @type)
  end

  private

  def sql_to_graphql_type(sql_type)
    mappings = {
      'bigint' => 'Int',
      'boolean' => 'Boolean',
      'character varying' => 'String',
      'date' => 'String',
      'double precision' => 'Float',
      'hstore' => 'String',
      'integer' => 'Int',
      'interval' => 'String',
      'json' => 'String',
      'jsonb' => 'String',
      'numeric' => 'Float',
      'public.tsvector' => 'String',
      'smallint' => 'Int',
      'text' => 'String',
      'timestamp without time zone' => 'String',
      'tsvector' => 'String',
      'uuid' => 'String',
    }

    mappings.find{|k, v| sql_type.include? k}[1] || 'String'
  end

end
