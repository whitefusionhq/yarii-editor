module Yarii
  module ApplicationHelper
    include ::Webpacker::Helper

    def current_webpacker_instance
      YariiEditor.webpacker
    end
  end
end