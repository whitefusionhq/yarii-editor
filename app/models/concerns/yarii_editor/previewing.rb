module YariiEditor
  module Previewing
    extend ActiveSupport::Concern
        
    def preview_url
      "#{CurrentSite.site.preview_base_url}/#{preview_path}"
    end

    def preview_path
      # override in subclasses
      if respond_to?(:permalink) and permalink.present?
        permalink.sub(/^\//, '')
      else
        relative_path.sub(/^\//, '').sub(/\.md|\.html|\.markdown/, '')
      end
    end
  end
end