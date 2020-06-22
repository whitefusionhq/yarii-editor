module YariiEditor
  class DashboardController < ApplicationController
    before_action :pull_if_needed, except: [:list]

    def index
      @custom_lists = []
    end

    def list
      model_details = current_site.content_models.schema_for_type(params[:model_type])

      list = render_to_string(formats: [:html], partial: 'yarii_editor/dashboard/inner_list', locals: {model_type: params[:model_type], model_details: model_details})

      render html: list
    end
  end
end