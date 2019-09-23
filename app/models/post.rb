class Post < ::ApplicationContentModel
  folder '_posts'

  variables :layout,
            :date,
            :category,
            :title,
            :subtitle,
            :link_title,
            :cloudinary_id,
            :link_url,
            :link_excerpt,
            :tags,
            :newsletter,
            :original_source

  before_save :strip_layout

  def strip_layout
    self.layout = nil if layout and layout.strip == ""
  end

  def generate_new_file_path
    if use_date = date && date.to_datetime
      date_prefix = "#{use_date.strftime('%Y-%m-%d')}-"
    else
      date_prefix = "#{Date.current.strftime('%Y-%m-%d')}-"
    end

    slug = if title
      title.gsub(/['|"]/,'').parameterize
    else
      "untitled_#{self.class.name.parameterize}"
    end

    year = date_prefix.split('-').first

    self.class.absolute_path("#{year}/#{date_prefix}#{slug}.md")
  end
end
