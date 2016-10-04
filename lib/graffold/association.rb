require 'graffold/field'

class Graffold::Association

  attr_reader :parent, :association, :model, :name, :type

  def initialize(parent, association)
    @parent = parent
    @association = association
    @model = association.klass.name.constantize rescue nil
    @name = association.name.to_s
    @type = model.name.gsub('::', '') + 'Type' rescue 'InvalidType'
  end

  def required?
    @association.options[:required] || false
  end

  def active_record?
    @model < ActiveRecord::Base rescue false
  end

  def polymorphic?
    @association.polymorphic?
  end

  def valid?
    !@model.nil? && active_record?
  end

  def invalid?
    !valid?
  end

  def belongs_to?
    @association.macro == :belongs_to
  end

  def has_one?
    @association.macro == :has_one
  end

  def has_many?
    @association.macro == :has_many
  end

  def to_field
    Graffold::Field.new(parent: @parent, association: @association, name: name, type: type, required: required?)
  end

end
