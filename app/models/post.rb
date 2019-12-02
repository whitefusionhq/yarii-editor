class Post < ::ApplicationContentModel
  folder '_posts'

  variables :layout,
            :date,
            :published,
            :category,
            :title,
            :subtitle,
            :tags

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
