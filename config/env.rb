require "bundler"
Bundler.require(:default, (ENV['RACK_ENV'] || 'production'))
require "active_support"
require "active_support/core_ext"

module SwiftDocs
  def self.root
    @root ||= File.expand_path('../../',  __FILE__)
  end
end

Dir[File.join(SwiftDocs.root, 'lib/patches/*.rb')].reverse_each { |path| require path }
require File.join(SwiftDocs.root, 'config/settings')
require File.join(SwiftDocs.root, 'app')

Dir[File.join(SwiftDocs.root, 'app/**/*.rb')].reverse_each { |path| require path }
