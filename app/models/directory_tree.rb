module DaggerDoc
  class DirectoryTree

    attr_reader :entries, :root, :max_depth

    def initialize(root, max_depth = 5)
      @root       = root
      @max_depth  = max_depth
      @entries    = {}
    end


    def to_h
      @to_h ||= build_tree_hash(root, max_depth)
    end


    def build_tree_hash(path, depth)
      return { path => :depth_limit } if depth <= 0
      if File.directory?(path)
        { path  => Dir.foreach(path)
                      .reject(&method(:ignore_path?))
                      .map(&method(:to_path).with(path))
                      .map(&method(:build_tree_hash).with(depth - 1))
                      .compact
        }
      else
        entry = Entry.new(path)
        if entry.extension == 'md'
          { path => entry }
        else
          nil
        end
      end
    end


    def ignore_path?(entry)
      entry.start_with?('.')
    end


    def to_path(entry, path)
      File.join(path, entry)
    end


    class Entry < Struct.new(:path)
      def name
        File.split(path).last
      end

      def extension
        return '' if name['.'].nil?
        name.split('.').last
      rescue ArgumentError
        ''
      end

      def as_url(prefix = '/')
        pretty_path = path[DaggerDoc.doc_path.length..-1].chomp('.md')
        "#{prefix}#{pretty_path}".gsub(/\/+/, '/')
      end
    end

  end
end
