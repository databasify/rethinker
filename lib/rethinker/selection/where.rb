module Rethinker::Selection::Where
  def where(*args, &block)
    #options = args.extract_options!.dup
    #default_option = options.select { |k,v| k == :default }

    # TODO: :default option
    criterion = Rethinker::Criterion.new(:filter, args, &block)
    chain criterion
  end

end
