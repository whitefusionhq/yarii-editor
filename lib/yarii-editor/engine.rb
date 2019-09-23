module YariiEditor
  class Engine < ::Rails::Engine
    isolate_namespace YariiEditor

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
  end
end
