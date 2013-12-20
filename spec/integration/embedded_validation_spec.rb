require 'spec_helper'

describe 'Rethinker validations on embedded documents' do
  before { load_embedded_models }

  context 'when validating a unique field' do

    let(:account) { Account.create!(:name => 'account1') }

    context 'without a scope' do
      before { ApiKey.validates :key, :uniqueness => true }

      it 'cannot save a non-unique value' do
        api_key = account.api_keys.new(key: '123')
        api_key.valid?.should == true
        api_key2 = account.api_keys.new(key: '123')
        api_key2.valid?.should == false
        expect { account.save! }.to raise_error(Rethinker::Error::DocumentInvalid)
      end

      it 'can save a unique value' do
        api_key = account.api_keys.new(key: '123')
        api_key.valid?.should == true
        api_key2 = account.api_keys.new(key: '456')
        api_key2.valid?.should == true
        account.save.should == true
      end
    end

    context 'with a single scope' do
      before { ApiKey.validates :key, :uniqueness => {scope: :label} }

      it 'cannot save a non-unique value in the same scope' do
        api_key = account.api_keys.new(key: '123', label: 'admin')
        api_key.valid?.should == true
        api_key2 = account.api_keys.new(key: '123', label: 'admin')
        api_key2.valid?.should == false
        expect { account.save! }.to raise_error(Rethinker::Error::DocumentInvalid)
      end

      it 'can save a unique value in the same scope' do
        api_key = account.api_keys.new(key: '123', label: 'admin')
        api_key.valid?.should == true
        api_key2 = account.api_keys.new(key: '456', label: 'admin')
        api_key2.valid?.should == true
        account.save.should == true
      end

      it 'can save a non-unique value in a different scope' do
        api_key = account.api_keys.new(key: '123', label: 'admin')
        api_key.valid?.should == true
        api_key2 = account.api_keys.new(key: '123', label: 'user')
        api_key2.valid?.should == true
        account.save.should == true
      end
    end

    context 'with multiple scopes' do
      before { ApiKey.validates :key, :uniqueness => {scope: [:label, :client]} }

      it 'cannot save a non-unique value in all of the same scopes' do
        api_key = account.api_keys.new(key: '123', label: 'admin', client: 'browser')
        api_key.valid?.should == true
        api_key2 = account.api_keys.new(key: '123', label: 'admin', client: 'browser')
        api_key2.valid?.should == false
        expect { account.save! }.to raise_error(Rethinker::Error::DocumentInvalid)
      end

      it 'can save a unique value in all of the same scopes' do
        api_key = account.api_keys.new(key: '123', label: 'admin', client: 'browser')
        api_key.valid?.should == true
        api_key2 = account.api_keys.new(key: '456', label: 'admin', client: 'browser')
        api_key2.valid?.should == true
        account.save.should == true
      end

      it 'can save a non-unique value when not all of the scopes match' do
        api_key = account.api_keys.new(key: '123', label: 'admin', client: 'browser')
        api_key.valid?.should == true
        api_key2 = account.api_keys.new(key: '123', label: 'user', client: 'browser')
        api_key2.valid?.should == true
        api_key3 = account.api_keys.new(key: '123', label: 'admin', client: 'server')
        api_key3.valid?.should == true
        account.save.should == true
      end
    end

  end

end
