module SitePath
  cattr_accessor :current_site
  def self.setup(site=nil)
    if site.nil?
      site = Yarii::Site.first
    end
    self.current_site = site
    Yarii::ContentModel.base_path = site.content_base_path
    Yarii::DatafileModel.base_path = site.content_base_path
  end
end