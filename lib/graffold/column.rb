require 'graffold/field'

class Graffold::Column

  def initialize(column)
    @column = column
  end

  def to_field
    Graffold::Field.new(name: name, required: required?, type: type, source: @column)
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
