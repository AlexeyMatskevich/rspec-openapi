# Configuring the hooks first to make the `after(:suite)` run at last
if ENV['OPENAPI']
  require 'rspec'

  RSpec.configure do |config|
    config.before(:suite) do
      FileUtils.rm_f(RSpec::OpenAPI.path)
    end

    config.after(:suite) do
      expect(system('git', 'diff', '--exit-code', '--', RSpec::OpenAPI.path)).to eq(true)
    end
  end
end

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('railsapp/config/environment', __dir__)
require 'rspec/rails'

RSpec::OpenAPI.path = File.expand_path('railsapp/doc/openapi.yaml', __dir__)
RSpec::OpenAPI.comment = <<~EOS
  This file is auto-generated by rspec-openapi https://github.com/k0kubun/rspec-openapi

  When you write a spec in spec/requests, running the spec with `OPENAPI=1 rspec` will
  update this file automatically. You can also manually edit this file.
EOS

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
