module CurrentSite
  thread_mattr_accessor :site

  def self.setup(newSite=nil)
    if newSite.nil?
      newSite = Yarii::Site.first
    end
    self.site = newSite
    self.site.setup_content_model_variables
    Yarii::ContentModel.base_path = site.content_base_path
    Yarii::DatafileModel.base_path = site.content_base_path
    self.site
  end

  def self.reset
    self.site = nil
    Yarii::ContentModel.base_path = nil
    Yarii::DatafileModel.base_path = nil
  end
end