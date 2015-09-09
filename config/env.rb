require "bundler"
Bundler.require(:default, (ENV['RACK_ENV'] || 'production'))
require "active_support"
require "active_support/core_ext"


module DaggerDoc
  def self.root
    @root ||= File.expand_path('../../',  __FILE__)
  end
end


Dir[File.join(DaggerDoc.root, 'lib/patches/*.rb')].reverse_each { |path| require path }
require File.join(DaggerDoc.root, 'config/settings')
require File.join(DaggerDoc.root, 'app')

$0 = "daggerdoc rack daemon for #{DaggerDoc.doc_path}"

Dir[File.join(DaggerDoc.root, 'app/**/*.rb')].reverse_each { |path| require path }
