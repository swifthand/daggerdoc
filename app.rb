module DaggerDoc
  class App < Sinatra::Application

    configure do
      disable :method_override
      disable :static

      # Really basic/simple Sinatra session settings:
      set :sessions,  httponly:     true,
                      expire_after: 31557600, # aka one year
                      secure:       production?,
                      secret:       ENV['SINATRA_SESSION_SECRET']

      set :views, File.join(DaggerDoc.root, 'app/templates')
      set :erb,   layout: :default, layout_options: { views: File.join(DaggerDoc.root, 'app/templates/layouts') }
    end

    use Rack::Deflater


    def render_doc(path, **locals)
      erb :document, locals: { document: render_markdown(path) }.merge(locals)
    end

    def render_markdown(path)
      CommonMarker.render_html(File.read(path), DaggerDoc.cmark_options)
    end

    get '/docs/*' do
      doc_route = if params[:splat].last.end_with?('.md')
                    params[:splat].last
                  else
                    "#{params[:splat].last}.md"
                  end
      doc_path  = File.join(DaggerDoc.doc_path, doc_route)

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
      app_asset_path = File.join(DaggerDoc.root, 'app/assets', params[:splat].last)
      doc_asset_path = File.join(DaggerDoc.doc_path, params[:splat].last)
      if File.exist?(app_asset_path)
        send_file(app_asset_path, disposition: 'inline')
      elsif File.exist?(doc_asset_path)
        send_file(doc_asset_path, disposition: 'inline')
      else
        status 404
        ""
      end
    end


    get '/' do
      tree = DaggerDoc::DirectoryTree.new(DaggerDoc.doc_path).to_h
      # TODO: Tree Trimming algo that cuts off empty branches.
      erb :directory_index, layout: false, locals: { tree: tree }
    end

  end
end


