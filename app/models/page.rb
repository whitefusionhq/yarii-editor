class Page < ::ApplicationContentModel
  variables :layout, :date, :published, :title, :subtitle, :tags, :permalink

  def generate_new_file_path
    slug = if title
      title.gsub(/['|"]/,'').parameterize
    else
      "untitled_#{self.class.name.parameterize}"
    end

    self.class.absolute_path("#{slug}.md")
  end
end
