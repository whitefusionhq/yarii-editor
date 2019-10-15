require "yarii-editor/engine"
require "yarii-editor/setup_current_site"

class YariiEditor::Error < StandardError; end

module YariiEditor
  ROOT_PATH = Pathname.new(File.join(__dir__, ".."))

  class << self
    def webpacker
      @webpacker ||= ::Webpacker::Instance.new(
        root_path: ROOT_PATH,
        config_path: ROOT_PATH.join("config/webpacker.yml")
      )
    end
  end

  class NotAuthorizedError < Error
  end
end

module Yarii
end
