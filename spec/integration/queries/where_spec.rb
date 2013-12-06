require 'spec_helper'

describe 'where' do
  before { load_simple_document }

  let!(:doc1) { SimpleDocument.create(:field1 => 'ohai') }
  let!(:doc2) { SimpleDocument.create(:field1 => 'hello') }
  let!(:doc3) { SimpleDocument.create(:field1 => 'hola') }

  context 'when passing an empty hash' do
    it 'filters documents' do
      SimpleDocument.where({}).count.should == 3
    end
  end

  context 'when passing a hash of attributes' do
    it 'filters documents' do
      SimpleDocument.where(:field1 => 'ohai').count.should == 1
    end
  end

  context 'when passing a block' do
    it 'filters documents' do
      SimpleDocument.where {|doc| doc[:field1].eq('ohai')}.count.should == 1
    end

    it 'filters documents with a regex (in string format)' do
      SimpleDocument.where {|doc| doc[:field1].match('h')}.count.should == 3
      SimpleDocument.where {|doc| doc[:field1].match('hola')}.count.should == 1
    end
  end

  context 'when passing a field that does not exist' do
    it 'filters documents without yelling' do
      SimpleDocument.where(:field_new => 'hi').count.should == 0
      SimpleDocument.field :field_new
      SimpleDocument.first.update_attributes(:field_new => 'hi')
      SimpleDocument.where(:field_new => 'hi').count.should == 1
    end

    it 'does not return documents that have the field set to nil' do
      SimpleDocument.where(:field_new => nil).count.should == 0
      SimpleDocument.field :field_new
      SimpleDocument.first.update_attributes(:field_new => nil)
      SimpleDocument.where(:field_new => nil).count.should == 1
    end
  end
  
end
