require 'spec_helper'

describe "Rethinker selection" do
  before { load_simple_document }

  context 'when the document does not exist' do
    describe 'find' do
      it 'returns nil' do
        SimpleDocument.find('x').should == nil
      end
    end

    describe 'find!' do
      it 'throws not found error' do
        expect { SimpleDocument.find!('x') }.to raise_error(Rethinker::Error::DocumentNotFound)
      end
    end
  end
end
