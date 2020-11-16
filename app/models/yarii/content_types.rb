require "safe_yaml"

module Yarii
  class ContentTypes
    attr_accessor :schema

    def initialize(yarii_site, yaml_path)
      @yarii_site = yarii_site # TODO: still needed?

      @schema = ::SafeYAML.load(File.open(yaml_path))
      @schema = @schema[Rails.env]&.with_indifferent_access
      if @schema.nil?
        raise "No content model schema was found for the #{Rails.env} environment"
      end

      setup_content_item_klasses
    end

    def setup_content_item_klasses
      schema.values.each do |content_item|
        content_item["klass"] = Kernel.const_get(content_item['class_name'])
      end
    end

    def schema_for_type(model_type)
      schema[model_type]
    end

    def field_names_for_schema(model_type)
      content_item = schema_for_type(model_type)
      [
        content_item['primary_fields'],
        content_item['additional_fields'],
        content_item['content_fields']
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
