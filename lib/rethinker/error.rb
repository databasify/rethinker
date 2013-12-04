module Rethinker::Error
  class Connection       < StandardError; end
  class DocumentNotFound < StandardError; end
  class DocumentInvalid  < StandardError; end
  class DocumentNotSaved < StandardError; end
end
