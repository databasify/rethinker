module Rethinker::Selection::FindBy
  def find_by(*args, &block)
    #options = args.extract_options!.dup
    #default_option = options.select { |k,v| k == :default }

    # TODO: :default option
    found_record = chain(Rethinker::Criterion.new(:filter, args, &block)).run.first
    raise Rethinker::Error::DocumentNotFound unless found_record
    klass.new_from_db(found_record)
  end

end
