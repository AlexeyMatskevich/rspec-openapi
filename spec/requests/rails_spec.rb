ENV['TZ'] ||= 'UTC'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../rails/config/environment', __dir__)
require 'rspec/rails'

RSpec::OpenAPI.path = File.expand_path('../rails/doc/openapi.yaml', __dir__)
RSpec::OpenAPI.comment = <<~EOS
  This file is auto-generated by rspec-openapi https://github.com/k0kubun/rspec-openapi

  When you write a spec in spec/requests, running the spec with `OPENAPI=1 rspec` will
  update this file automatically. You can also manually edit this file.
EOS

RSpec.describe 'Tables', type: :request do
  describe '#index' do
    it 'returns a list of tables' do
      get '/tables', params: { page: '1', per: '10' }, headers: { authorization: 'k0kubun' }
      expect(response.status).to eq(200)
    end

    it 'does not return tables if unauthorized' do
      get '/tables'
      expect(response.status).to eq(401)
    end
  end

  describe '#show' do
    it 'returns a table' do
      get '/tables/1', headers: { authorization: 'k0kubun' }
      expect(response.status).to eq(200)
    end

    it 'does not return a table if unauthorized' do
      get '/tables/1'
      expect(response.status).to eq(401)
    end

    it 'does not return a table if not found' do
      get '/tables/2', headers: { authorization: 'k0kubun' }
      expect(response.status).to eq(404)
    end
  end

  describe '#create' do
    it 'returns a table' do
      post '/tables', headers: { authorization: 'k0kubun', 'Content-Type': 'application/json' }, params: {
        name: 'k0kubun',
        description: nil,
        database_id: 2,
      }.to_json
      expect(response.status).to eq(201)
    end
  end

  describe '#update' do
    it 'returns a table' do
      patch '/tables/1', headers: { authorization: 'k0kubun' }
      expect(response.status).to eq(200)
    end
  end

  describe '#destroy' do
    it 'returns a table' do
      delete '/tables/1', headers: { authorization: 'k0kubun' }
      expect(response.status).to eq(200)
    end

    it 'returns no content if specified' do
      delete '/tables/1', headers: { authorization: 'k0kubun' }, params: { no_content: true }
      expect(response.status).to eq(202)
    end
  end
end
