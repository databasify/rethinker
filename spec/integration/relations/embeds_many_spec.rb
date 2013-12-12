require 'spec_helper'

describe 'embeds_many' do
  before { load_embedded_models }

  let(:account) { Account.create(name: "MyAccount") }

  context 'when there are no embedded records' do
    it 'is empty' do
      account.api_keys.should be_empty
    end
  end

  context 'when there are many embedded_records' do
    let!(:api_keys) { 2.times.map {|i| account.api_keys.new(key: i)} }

    it 'returns these embedded_records' do
      account.api_keys.to_a.should =~ api_keys
    end

  end

  context 'when appending' do
    it 'persists elements' do
      2.times { account.api_keys << ApiKey.new }
      account.api_keys.count.should == 2
      account.save
      account.reload
      account.api_keys.new
      account.api_keys.count.should == 3
    end
  end

  context 'when saving parent' do
    it 'runs before_validation callbacks on children' do
      ApiKey.before_validation :raise_error
      expect { account.api_keys.new; account.save }.
          to raise_error
    end
  end


  context 'when using =' do
    it 'destroys, and persists elements' do
      account.api_keys.new
      account.api_keys.count.should == 1

      account.api_keys = [ApiKey.new, ApiKey.new]
      account.api_keys.count.should == 2
      account.save
      account.reload
      account.api_keys.count.should == 2
    end
  end

  context 'when calling new' do
    it 'builds a child' do
      api_key = account.api_keys.new(:key => 'abc')
      account.api_keys.first.should == api_key
      account.api_keys.first.key.should == 'abc'
      account.api_keys.count.should == 1
    end
  end

  context 'when saving the parent' do
    context 'when the child is valid' do
      it 'creates a child' do
        api_key = account.api_keys.new(:key => 'def')
        account.save
        Account.find(account.id).api_keys.first.should == api_key
        Account.find(account.id).api_keys.first.key.should == 'def'
      end
    end

    context 'when the child is not valid' do
      it 'raises an exception' do
        ApiKey.validates :key, :presence => true
        account.api_keys.new
        expect { account.save! }.
          to raise_error(Rethinker::Error::DocumentInvalid)
      end
    end
  end

end
