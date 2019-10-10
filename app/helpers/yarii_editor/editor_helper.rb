module YariiEditor
  module EditorHelper
    def add_field(type, props)
      render "yarii_editor/editor/#{type}", props
    end

    def name_from_variable(props)
      model_name = params[:content_model]
      "#{model_name}[#{props[:variable]}]" || "unknown#{(1..10000).to_a.sample}"
    end

    def value_from_variable(props)
      variable = props[:variable]
      if variable && @doc
        @doc.send(variable)
      end
    end
  end
end
