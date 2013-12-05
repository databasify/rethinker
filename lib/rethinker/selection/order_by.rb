module Rethinker::Selection::OrderBy

  def order_by(*rules)
    rules = Hash[*rules.map{|i| i.is_a?(Hash) ? i.to_a.flatten : [i, :asc]}.flatten]
    criterion = Rethinker::Criterion.new(:order_by, OrderByRules.new(rules))
    chain criterion
  end

  def ordered?
    !criteria.select{|c| c.method == :order_by }.blank?
  end

  class OrderByRules
    attr_accessor :rules

    def initialize(rules)
      @rules = rules
    end

    def to_rql(context)
      @rules.map{|k,v| rql_lookup(k,v, context[:order])}
    end

    def rql_lookup(key, value = :asc, order)
      case value
        when asc(order)  then RethinkDB::RQL.new.asc(key)
        when desc(order) then RethinkDB::RQL.new.desc(key)
        else raise "please pass :asc or :desc, not #{value}"
      end
    end

    def asc(order)
      order == :reverse ? :desc : :asc
    end

    def desc(order)
      order == :reverse ? :asc : :desc
    end
  end

end
