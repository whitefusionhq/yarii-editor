module YariiEditor
  module DocumentHelper
    def status_of_document(document)
      if document.will_be_published?
        if CurrentSite.site.repository.git.diff('HEAD', '--cached').path(document.absolute_path_in_source_dir).stats[:total][:files] == 1
          :queued
        else
          :published
        end
      else
        return :draft
      end
    end
  end
end