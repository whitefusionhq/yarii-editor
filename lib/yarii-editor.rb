require "yarii-editor/engine"
require "yarii-editor/setup_current_site"
require "yarii-editor/setup_current_user"

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

# Fix crash if deprecated gem isn't loaded
if !Kernel.const_defined?("Yarii::DatafileModel")
  class Yarii::DatafileModel; end
end
