class Rethinker::Selection
  extend Rethinker::Autoload

  autoload_and_include :Core, :Count, :Delete, :Enumerable, :First, :Inc,
                       :Limit, :OrderBy, :Scope, :Update, :Where, :Get, :FindBy
end
