module SwiftDocs
  def self.settings
    @settings ||= JSON.parse(File.read(File.expand_path('../settings.json', __FILE__)))
  end

  def self.doc_path
    @doc_path ||= (
      build_doc_path(ENV['DOC_PATH'] || :none) ||
      build_doc_path(settings['doc_path'] || :none) ||
      (raise ArgumentError.new('Setting value for doc_path does not exist or is not a directory.'))
    )
  end

  def self.build_doc_path(path)
    return nil if path == :none
    abs_path = path.start_with?('/') ? path : File.join(root, path)
    File.directory?(abs_path) ? abs_path : nil
  end

  def self.cmark_options
    @cmark_options ||=
      settings['cmark_options'].split(/\s+/).map { |token| token.to_sym }
  end
end
