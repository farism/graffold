require 'rails/generators/base'

require 'graffold/spider'

class Graffold::GraphGenerator < Rails::Generators::Base

  source_root File.expand_path('../templates', __FILE__)

  desc "Scaffold out graphql-ruby types for any ActiveRecord"

  argument :name, type: :string, default: nil, required: true,
    desc: 'Model name'

  argument :namespace, type: :string, default: nil, required: false,
    desc: 'Scaffold namespace'

  class_option :depth, type: :string, default: '-1', required: false,
    desc: 'How deep to crawl. Pass `0` to generate a single type'

  class_option :verbose, type: :boolean, default: false, required: false,
    desc: 'Do verbose output'

  def scaffold
    model = begin
      name.constantize
    rescue => ex
      abort "Invalid root model (#{ex})".red
    end

    puts "Found #{name}, begin scaffolding".green

    @spider = Graffold::Spider.new(model, max_depth: depth)
    @spider.crawl
    @spider.web.each do |type|
      @type = type
      log_type type if verbose?
      template 'type.erb', "app/graph/types/#{type.file_name}.rb"
    end

    template 'query.erb', 'app/graph/query_type.rb'
    # template 'mutation.erb', 'app/graph/mutation_type.rb'

    puts ""
    puts "#{@spider.depth} levels traversed".green
    puts "#{@spider.web.length} types found on the graph".green
    puts "#{@spider.all_valid_associations.length} valid associations found".green
    puts "#{@spider.all_invalid_associations.length} invalid associations found".yellow
    @spider.all_invalid_associations
      .sort_by{|a| a.name}
      .each{|a| puts "  #{a.parent.name}.#{a.name}".yellow} if verbose?
    puts ""
  end

  private

  def model
    begin
      name.constantize
    rescue => ex
      abort "Invalid root model (#{ex})".red
    end
  end

  def module_name
    namespace ? namespace + '::' : ''
  end

  def depth
    options[:depth].to_i
  end

  def verbose?
    options[:verbose]
  end

  def log_type(type)
    puts ''
    puts "found type: #{type.name}".green
    puts "  #{type.scalar_fields.length} scalar fields".green
    puts "  #{type.valid_associations.length} valid association fields".green
    puts "  #{type.invalid_associations.length} invalid association fields".yellow
    type.invalid_associations.each{|a| puts "    #{a.name}".yellow}
  end

end
