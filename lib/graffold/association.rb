require 'graffold/field'

class Graffold::Association

  attr_reader :parent, :association, :name, :type, :required, :valid, :invalid,
    :model, :polymorphic, :active_record, :belongs_to, :has_one, :has_many

  alias_method :required?, :required
  alias_method :polymorphic?, :polymorphic
  alias_method :active_record?, :active_record
  alias_method :belongs_to?, :belongs_to
  alias_method :has_one?, :has_one
  alias_method :has_many?, :has_many
  alias_method :valid?, :valid
  alias_method :invalid?, :invalid

  def initialize(parent, association)
    @parent = parent
    @association = association
    @name = association.name.to_s
    @type = model.name.gsub('::', '') + 'Type' rescue 'InvalidType'
    @model = association.klass.name.constantize rescue nil
    @required = association.belongs_to?
    @polymorphic = association.polymorphic?
    @active_record = @model < ActiveRecord::Base rescue false
    @belongs_to = association.belongs_to?
    @has_one = association.has_one?
    @has_many = association.macro == :has_many
    @valid = !model.nil? && @active_record
    @invalid = !valid?
  end


  def to_field
    Graffold::Field.new(name: name, required: required?, type: type, model: model, parent: @parent, source: @association)
  end

end
