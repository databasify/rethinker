class Rethinker::Criterion

  attr_accessor :method, :args, :block

  def initialize(method, *args, &block)
    self.method = method
    self.args = args.flatten
    self.block = block
  end

  def execute(query = nil, context)
    return RethinkDB::RQL.new.send(self.method, self.args.first) if query.nil?
    if !args.flatten.blank? && block
      query.send self.method, *process_args(self.args, context), block
    elsif !args.flatten.blank?
      query.send self.method, *process_args(self.args, context)
    elsif block
      query.send self.method, block
    else
      query.send self.method
    end
  end

  def process_args(args, context)
    if args && args.first.respond_to?(:to_rql)
      args.first.to_rql(context)
    else
      args
    end
  end

end