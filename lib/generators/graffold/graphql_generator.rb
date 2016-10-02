require 'rails/generators'

class GraphqlGenerator < Rails::Generators::NamedBase

  source_root File.expand_path('../templates', __FILE__)

  argument :namespace, type: :string, default: nil, required: false,
    desc: 'Scaffold namespace'

  class_option :single, type: :boolean, default: false, required: false,
    desc: 'Only the specified model'

  class_option :depth, type: :string, default: '-1', required: false,
    desc: 'How deep to crawl into the graph'

  class_option :dry_run, type: :boolean, default: false, required: false,
    desc: 'How deep to crawl into the graph'

  class_option :verbose, type: :boolean, default: false, required: false,
    desc: 'Verbose output'

  def scaffold
    # model = begin
    #   name.constantize
    # rescue => ex
    #   abort "Invalid root model (#{ex})".red
    # end
    #
    # max_depth = options[:single] ? 0 : options[:depth].to_i
    # dry = options[:dry_run]
    # verbose = options[:verbose]
    #
    # puts "Found #{name}, begin scaffolding".green
    #
    # @spider = Graphql::Spider.new(model, max_depth: max_depth)
    # @spider.crawl
    # @spider.web.each do |type|
    #   @type = type
    #   log_type type if verbose
    #   template 'type.erb', "app/graph/types/#{type.file_name}.rb" unless dry
    # end
    #
    # template 'query.erb', 'app/graph/query_type.rb' unless dry
    # # template 'mutation.erb', 'app/graph/mutation_type.rb' unless dry
    #
    # puts ""
    # puts "found #{@spider.web.length} types on the graph".green
    # puts ""
  end

  private

  def module_name
    namespace ? namespace + '::' : ''
  end

  def log_type(type)
    puts ''
    puts "found type: #{type.name}".green
    puts "  - #{type.scalar_fields.length} scalar fields".green
    puts "  - #{type.valid_associations.length} valid association fields".green
    puts "  - #{type.invalid_associations.length} invalid association fields".yellow
  end

end
