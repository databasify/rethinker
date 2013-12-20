describe 'find_by' do
  before { load_simple_document }

  let!(:doc1) { SimpleDocument.create(:field1 => 'ohai') }
  let!(:doc2) { SimpleDocument.create(:field1 => 'hello') }
  let!(:doc3) { SimpleDocument.create(:field1 => 'hola') }

  context 'when passing a hash of attributes' do
    it 'filters documents' do
      SimpleDocument.find_by(:field1 => 'ohai').should be_kind_of(SimpleDocument)
    end
  end

  context 'when finding a nonexistent document' do
    it 'should raise an exception' do
      expect { SimpleDocument.find_by(:field1 => 'not-here') }.to raise_error(Rethinker::Error::DocumentNotFound)
    end
  end
end