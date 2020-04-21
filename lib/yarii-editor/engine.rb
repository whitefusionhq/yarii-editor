module YariiEditor
  class Engine < ::Rails::Engine
    isolate_namespace YariiEditor

    ROOT_PATH = Pathname.new(File.join(__dir__, "..", ".."))
    
    config.to_prepare do
      Dir.glob(Rails.root.join('app', 'decorators', '**', '*_decorator*.rb')).each do |c|
        require_dependency(c)
      end
    end

    config.app_middleware.use(
      Rack::Static,
      urls: ["/yarii-editor-packs"], root: ROOT_PATH.join("public")
    )

    initializer "yarii_editor.assets.precompile" do |app|
      app.config.assets.precompile += %w( butterfly-small.png )
    end
  end
end
