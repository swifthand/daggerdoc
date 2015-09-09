module SwiftDocs
  class App < Sinatra::Application

    configure do
      disable :method_override
      disable :static

      # Really basic/simple Sinatra session settings:
      set :sessions,  httponly:     true,
                      expire_after: 31557600, # aka one year
                      secure:       production?,
                      secret:       ENV['SINATRA_SESSION_SECRET']

      set :views, File.join(SwiftDocs.root, 'app/templates')
      set :erb,   layout: :default, layout_options: { views: File.join(SwiftDocs.root, 'app/templates/layouts') }
    end

    use Rack::Deflater


    def render_doc(path, **locals)
      erb :document, locals: { document: render_markdown(path) }.merge(locals)
    end

    def render_markdown(path)
      CommonMarker.render_html(File.read(path), SwiftDocs.cmark_options)
    end

    get '/docs/*' do
      doc_route = if params[:splat].last.end_with?('.md')
                    params[:splat].last
                  else
                    "#{params[:splat].last}.md"
                  end
      doc_path  = File.join(SwiftDocs.doc_path, doc_route)

      if File.exist?(doc_path)
        status 200
        render_doc doc_path, {
          doc_route:  doc_route,
          doc_path:   doc_path,
          title:      doc_route.chomp('.md').split('/').last.titleize
        }
      else
        status 404
        erb :not_found, locals: { doc_route: doc_route, doc_path: doc_path, title: "Doc Not Found" }
      end
    end


    get '/assets/*' do
      asset_path = File.join(SwiftDocs.root, 'app/assets', params[:splat].last)
      if File.exist?(asset_path)
        send_file(asset_path, disposition: 'inline')
      else
        status 404
        ""
      end
    end


    get '/' do
      tree = SwiftDocs::DirectoryTree.new(SwiftDocs.doc_path).to_h
      # TODO: Tree Trimming algo that cuts off empty branches.
      erb :directory_index, layout: false, locals: { tree: tree }
    end

  end
end


