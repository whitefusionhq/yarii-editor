module YariiEditor
  class DocumentsController < ApplicationController
    before_action :pull_if_needed, only: [:create, :update, :destroy]

    def new
      @doc_heading = "New #{model_title}"
      if params[:copy_from_template]
        template_file_path = content_model.sanitize_filepath(File.join(current_site.git_repo_path, ".yarii", "templates", params[:copy_from_template]))
        template_doc = content_model.new(file_path: template_file_path)
        template_doc.load_file_from_path
        @doc = template_doc.dup
        @doc.file_path = nil
      else
        @doc = content_model.new
      end
      @doc.published = true # default to adding to public publishing
      if @doc.respond_to? :setup_default_values
        @doc.setup_default_values(self, params)
      end
      render 'modal', layout: nil
    end

    def create
      @doc = content_model.new(secure_params)
      @doc.date = DateTime.current.iso8601
      if @doc.respond_to? :process_controller_params
        # Allow the content model to massage incoming data, if necessary
        @doc.process_controller_params(self, params)
      end
      @doc.save

      render json: {status: 'ok', document_html: rendered_card}
    end

    def edit
      @doc_heading = "Edit #{model_title}"
      if params[:key_path]
        @doc = content_model.find(params[:id], params[:key_path])
      else
        @doc = content_model.find(params[:id])
      end
      if @doc.respond_to?(:published) and @doc.published.nil?
        @doc.published = true
      end
      if @doc.respond_to? :setup_default_values
        @doc.setup_default_values(self, params)
      end
      render 'modal', layout: nil
    end
    
    def update
      if params[:key_path]
        @doc = content_model.find(params[:id], params[:key_path])
      else
        @doc = content_model.find(params[:id])
      end
      @doc.assign_attributes(secure_params)
      if @doc.respond_to? :process_controller_params
        # Allow the content model to massage incoming data, if necessary
        @doc.process_controller_params(self, params)
      end
      @doc.save

      render json: {status: 'ok', document_html: rendered_card} 
    end

    def destroy
      if params[:key_path]
        @doc = content_model.find(params[:id], params[:key_path])
      else
        @doc = content_model.find(params[:id])
      end
      @doc.destroy

      render json: {status: 'ok'}
    end

    protected
    
    def content_model
      current_site.content_models[params[:content_model]][:class_name].constantize
    end

    def model_title
      model_details = current_site.content_models[params[:content_model]]
      model_title = model_details.fetch(:title, model_details[:class_name].titleize)
    end

    def rendered_card
      render_to_string(formats: [:html], partial: 'yarii_editor/dashboard/card', locals: {model_class: content_model, model: @doc, content_model_type: params[:content_model]})
    end

    def secure_params
      content_model_param = params[:content_model].to_sym
      variable_names = content_model.variable_names + [:content]

      variable_names = variable_names.map do |variable|
        if params[content_model_param][variable.to_sym].is_a? Array
          # scrub empty values
          params[content_model_param][variable.to_sym] = params[content_model_param][variable.to_sym].select do |value|
            value.present?
          end
          # permit the array variable
          { variable => [] }
        else
          variable
        end
      end

      detect_integer = ->(str) {
        begin
          !!Integer(str)
        rescue ArgumentError, TypeError
          false
        end
      }
      variable_names.each do |variable|
        value = variable.is_a?(Hash) ?
          params[content_model_param][variable.keys.first.to_sym] :
          params[content_model_param][variable.to_sym]

        if value.is_a?(String)
          if value.strip.blank?
            # Scrub blank string values
            params[content_model_param][variable.to_sym] = nil
          elsif value.strip.match(/^false|true$/)
            # Convert to real boolean values
            params[content_model_param][variable.to_sym] = params[content_model_param][variable.to_sym].strip == 'true'
          elsif detect_integer.call(value)
            # Incoming strings that are simply numbers should be treated as such
            params[content_model_param][variable.to_sym] = value.to_i 
          end
        end
      end

      # Markdown editor adds carriage returns for some reason. Take them out!
      if params[content_model_param][:content]
        params[content_model_param][:content] = params[content_model_param][:content].gsub(/\r/, '')
      end
      if params[content_model_param][:link_excerpt]
        params[content_model_param][:link_excerpt] = params[content_model_param][:link_excerpt].gsub(/\r/, '')
      end

      params.require(content_model_param).permit(*variable_names)
    end
  end
end
