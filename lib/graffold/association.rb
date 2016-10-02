require 'graffold/field'

class Graffold::Association

  def initialize(association)
    @association = association
    @model = association.klass.name.constantize rescue nil
  end

  def association
    @association
  end

  def name
    @association.name.to_s
  end

  def required?
    @association.belongs_to?
  end

  def polymorphic?
    @association.polymorphic?
  end

  def type
    model.name.gsub('::', '') + 'Type' rescue 'InvalidType'
  end

  def model
    @model
  end

  def active_record?
    model < ActiveRecord::Base rescue false
  end

  def belongs_to?
    @association.belongs_to?
  end

  def has_one?
    @association.has_one?
  end

  def has_many?
    @association.macro == :has_many
  end

  def valid?
    !model.nil? && active_record?
  end

  def invalid?
    !valid?
  end

  def to_field
    Graffold::Field.new(name: name, required: required?, type: type, model: model, source: @association)
  end

end
