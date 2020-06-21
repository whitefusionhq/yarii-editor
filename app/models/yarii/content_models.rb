require "safe_yaml"

module Yarii
  class ContentModels
    attr_accessor :schema, :site

    def initialize(yarii_site, yaml_path)
      @yarii_site = yarii_site
      @site = yarii_site.bridgetown

      @schema = ::SafeYAML.load(File.open(yaml_path))
      @schema = @schema[Rails.env]&.with_indifferent_access
      if @schema.nil?
        raise "No content model schema was found for the #{Rails.env} environment"
      end

      setup_content_model_klasses
    end

    def setup_content_model_klasses
      schema.values.each do |content_model|
        content_model["klass"] = Kernel.const_get(content_model['class_name'])
      end
    end

    def schema_for_type(model_type)
      schema[model_type]
    end

    def field_names_for_schema(model_type)
      content_model = schema_for_type(model_type)
      [
        content_model['primary_fields'],
        content_model['additional_fields'],
        content_model['content_fields']
      ]
        .compact
        .flatten
        .map { |item| item[:field_name] }
        .compact
        .map(&:to_sym)
        .push(:published)
    end
  end
end
