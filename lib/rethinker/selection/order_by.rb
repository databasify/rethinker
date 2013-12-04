module Rethinker::Selection::OrderBy
  def order_by(*rules)
    if rules[0].is_a? Hash
      # Exploiting the fact that Hashes are now ordered
      rules = rules[0].map do |k,v|
        case v
        when :asc  then RethinkDB::RQL.new.asc(k)
        when :desc then RethinkDB::RQL.new.desc(k)
        else raise "please pass :asc or :desc, not #{v}"
        end
      end
    end

    chain(query.order_by(*rules), context.merge(:ordered => true))
  end

  def ordered?
    !!context[:ordered]
  end
end
