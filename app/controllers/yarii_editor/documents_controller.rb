module YariiEditor
  class DocumentsController < ApplicationController
    before_action :pull_if_needed, only: [:create, :update, :destroy]

    def new
      @doc_heading = "New #{model_title}"
      if params[:copy_from_template]
        # TODO: refactor this!
        template_file_path = content_item.sanitize_filepath(File.join(current_site.git_repo_path, ".yarii", "templates", params[:copy_from_template]))
        template_doc = content_item.new(file_path: template_file_path)
        template_doc.load_file_from_path
        @doc = template_doc.dup
        @doc.file_path = nil
      else
        @doc = content_item.new
      end
      @doc.published = true # default to adding to public publishing
      if @doc.respond_to? :setup_default_values
        @doc.setup_default_values(self, params)
      end
      render 'modal', layout: nil
    end

    def create
      @doc = content_item.new
      @doc.assign_attributes(secure_params)
      @doc.date = DateTime.current.iso8601 unless valid_date?
      if @doc.respond_to? :process_controller_params
        # Allow the content model to massage incoming data, if necessary
        @doc.process_controller_params(self, params)
      end
      @doc.save

      # Reload
      current_site.bridgetown.reset
      current_site.bridgetown.read
      @doc = content_item.find(
        @doc.id,
        label: params[:content_type],
        site: current_site.bridgetown
      )

      render json: {status: 'ok', document_html: rendered_card}
    end

    def edit
      @doc_heading = "Edit #{model_title}"
      if params[:key_path]
        @doc = content_item.find(params[:id], params[:key_path])
      else
        @doc = content_item.find(
          params[:id],
          label: params[:content_type],
          site: current_site.bridgetown
        )
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
        @doc = content_item.find(params[:id], params[:key_path])
      else
        @doc = content_item.find(
          params[:id],
          label: params[:content_type],
          site: current_site.bridgetown
        )
      end
      @doc.assign_attributes(secure_params)
      if @doc.respond_to? :process_controller_params
        # Allow the content model to massage incoming data, if necessary
        @doc.process_controller_params(self, params)
      end
      @doc.save

      # Reload
      current_site.bridgetown.reset
      current_site.bridgetown.read
      @doc = content_item.find(
        @doc.id,
        label: params[:content_type],
        site: current_site.bridgetown
      )

      render json: {status: 'ok', document_html: rendered_card} 
    end

    def destroy
      if params[:key_path]
        @doc = content_item.find(params[:id], params[:key_path])
      else
        @doc = content_item.find(
          params[:id],
          label: params[:content_type],
          site: current_site.bridgetown
        )
      end
      @doc.destroy

      render json: {status: 'ok'}
    end

    protected
    
    def content_item
      current_site.content_types.schema_for_type(params[:content_type])[:klass]
    end

    def model_title
      model_details = current_site.content_types.schema_for_type(params[:content_type])
      model_title = model_details.fetch(:title, model_details[:class_name].titleize)
    end

    def rendered_card
      render_to_string(formats: [:html], partial: 'yarii_editor/dashboard/card', locals: {model_class: content_item, model: @doc, content_item_type: params[:content_type]})
    end

    def secure_params
      variable_names = current_site.content_types.field_names_for_schema(params[:content_type])
      content_type_param = params[:content_type].to_sym

      variable_names = variable_names.map do |variable|
        if params[content_type_param][variable].is_a? Array
          # scrub empty values
          params[content_type_param][variable] = params[content_type_param][variable].select do |value|
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
        p "=> CHECKING VAR", variable
        value = variable.is_a?(Hash) ?
          params[content_type_param][variable.keys.first.to_sym] :
          params[content_type_param][variable]

        p "=> VALUE", value

        if value.is_a?(String)
          if value.strip.blank?
            # Scrub blank string values
            p "=> SCRUBBING!", content_type_param, variable
            params[content_type_param][variable] = nil
          elsif value.strip.match(/^false|true$/)
            # Convert to real boolean values
            params[content_type_param][variable] = params[content_type_param][variable].strip == 'true'
          elsif detect_integer.call(value)
            # Incoming strings that are simply numbers should be treated as such
            params[content_type_param][variable] = value.to_i 
          end
        end
      end

      # Markdown editor adds carriage returns for some reason. Take them out!
      if params[content_type_param][:content]
        params[content_type_param][:content] = params[content_type_param][:content].gsub(/\r/, '')
      end
      if params[content_type_param][:link_excerpt]
        params[content_type_param][:link_excerpt] = params[content_type_param][:link_excerpt].gsub(/\r/, '')
      end
      
      p "=> FINAL PARAMS!", params[content_type_param]

      params.require(content_type_param).permit(*variable_names)
    end

    def valid_date?
      begin
        @doc.date&.to_datetime.is_a?(DateTime)
      rescue ArgumentError
      end
    end
  end
end
