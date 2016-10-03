require 'graffold/field'

class Graffold::Column

  attr_reader :parent, :column

  def initialize(parent, column)
    @parent = parent
    @column = column
  end

  def to_field
    Graffold::Field.new(name: name, required: required?, type: type, parent: @parent, source: @column)
  end

  private

  def name
    @column.name
  end

  def required?
    !@column.null
  end

  def valid?
    true
  end

  def type
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
      @column.sql_type.include? k
    end

    return type[1] || 'String'
  end

end
