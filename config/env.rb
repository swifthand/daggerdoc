require "bundler"
Bundler.require(:default, (ENV['RACK_ENV'] || 'production'))
require "active_support"
require "active_support/core_ext"

module SwiftDocs
  def self.root
    @root ||= File.expand_path('../../',  __FILE__)
  end

  def self.settings
    @settings ||= JSON.parse(File.read(File.expand_path('../settings.json', __FILE__)))
  end

  def self.doc_path
    @doc_path ||=
      if settings['doc_path'].start_with?('/')
        settings['doc_path']
      else
        File.join(root, settings['doc_path'])
      end
  end
end

require File.join(SwiftDocs.root, 'app')
$LOAD_PATH << File.join(SwiftDocs.root, 'app')
