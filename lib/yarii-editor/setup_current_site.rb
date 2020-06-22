module CurrentSite
  thread_mattr_accessor :site

  def self.setup(newSite=nil)
    if newSite.nil?
      newSite = Yarii::Site.first
    end
    self.site = newSite
  end

  def self.reset
    self.site = nil
  end
end