STDOUT.sync = true

class Graffold::Spider

  def initialize(root, max_depth: -1)
    @root = root
    @max_depth = max_depth
    @web = {}
  end

  def web
    @web.values.sort_by{|t| t.field_name}
  end

  def crawl(model = @root, depth = 0)
    type = Graffold::Type.new model

    if type.valid? && !added?(type)
      print '.'
      add type

      if @max_depth == -1 || depth < @max_depth
        type.valid_associations.each do |a|
          crawl(a.model, depth + 1) rescue nil
        end
      end
    end
  end

  private

  def add(type)
    @web[type.name] = type
  end

  def added?(type)
    !@web[type.name].nil?
  end

end
