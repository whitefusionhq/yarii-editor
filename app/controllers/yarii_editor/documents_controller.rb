module YariiEditor
  class DocumentsController < ApplicationController
    def new
      @doc_heading = "New #{model_title}"
      @doc = content_model.new
      render 'modal', layout: nil
    end

    def create
      @doc = content_model.new(secure_params)
      @doc.date = DateTime.current.iso8601
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
      render 'modal', layout: nil
    end
    
    def update
      if params[:key_path]
        @doc = content_model.find(params[:id], params[:key_path])
      else
        @doc = content_model.find(params[:id])
      end
      @doc.assign_attributes(secure_params)
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
      Rails.
        configuration.
        content_models[params[:content_model].to_sym][:class_name].
        constantize
    end

    def model_title
      model_details = Rails.
        configuration.
        content_models[params[:content_model].to_sym]
      model_title = model_details.fetch(:title, model_details[:class_name].titleize)
    end

    def rendered_card
      render_to_string(formats: [:html], partial: 'yarii_editor/dashboard/card', locals: {model_class: content_model, model: @doc, content_model_type: params[:content_model]})
    end

    def secure_params
      variable_names = content_model.variable_names + [:content]

      variable_names = variable_names.map do |variable|
        if params[params[:content_model].to_sym][variable.to_sym].is_a? Array
          # scrub empty values
          params[params[:content_model].to_sym][variable.to_sym] = params[params[:content_model].to_sym][variable.to_sym].select do |value|
            value.present?
          end
          # permit the array variable
          { variable => [] }
        else
          variable
        end
      end

      # Scrub blank string values
      variable_names.each do |variable|
        value = params[params[:content_model].to_sym][variable.to_sym]
        if value.is_a?(String) and value.strip.blank?
          params[params[:content_model].to_sym][variable.to_sym] = nil
        end
      end

      # Markdown editor adds carriage returns for some reason. Take them out!
      if params[params[:content_model].to_sym][:content]
        params[params[:content_model].to_sym][:content] = params[params[:content_model].to_sym][:content].gsub(/\r/, '')
      end
      if params[params[:content_model].to_sym][:link_excerpt]
        params[params[:content_model].to_sym][:link_excerpt] = params[params[:content_model].to_sym][:link_excerpt].gsub(/\r/, '')
      end

      params.require(params[:content_model].to_sym).permit(*variable_names)
    end
  end
end
