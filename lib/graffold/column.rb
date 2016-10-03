require 'graffold/field'

class Graffold::Column

  attr_reader :parent, :column, :name, :type, :required, :valid, :invalid

  alias_method :required?, :required
  alias_method :valid?, :valid
  alias_method :invalid?, :invalid

  def initialize(parent, column)
    @parent = parent
    @column = column
    @name = column.name
    @type = sql_to_graphql_type(column.sql_type)
    @required = !column.nil?
    @valid = true
    @valid = !@invalid
  end

  def to_field
    Graffold::Field.new(name: name, required: required?, type: type, parent: @parent, source: @column)
  end

  private

  def sql_to_graphql_type(sql_type)
    mapping = {
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

    type = mapping.find do |k, v|
      sql_type.include? k
    end

    return type[1] || 'String'
  end

end
