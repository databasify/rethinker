module Rethinker::Selection::Where
  def where(*args, &block)
    #options = args.extract_options!.dup
    #default_option = options.select { |k,v| k == :default }

    # TODO: :default option
    criterion = Rethinker::Criterion.new(:filter, args, &block)
    chain criterion
  end

  private

  def extract_regexp!(options)
    regexp_filters = {}
    options.each do |k,v|
      if v.is_a?(Regexp)
        options.delete(k)
        regexp_filters[k] = v.inspect[1..-2]
      end
    end
    regexp_filters
  end
end
