module YariiEditor
  class Engine < ::Rails::Engine
    isolate_namespace YariiEditor
    
    config.to_prepare do
      Dir.glob(Rails.root.join('app', 'decorators', '**', '*_decorator*.rb')).each do |c|
        require_dependency(c)
      end
    end

    initializer "webpacker.proxy" do |app|
      insert_middleware = begin
        YariiEditor.webpacker.config.dev_server.present?
      rescue
        nil
      end
      next unless insert_middleware

      app.middleware.insert_before(
        0, Webpacker::DevServerProxy, # "Webpacker::DevServerProxy" if Rails version < 5
        ssl_verify_none: true,
        webpacker: YariiEditor.webpacker
      )
    end

    initializer "yarii_editor.assets.precompile" do |app|
      app.config.assets.precompile += %w( butterfly-small.png )
    end
  end
end
