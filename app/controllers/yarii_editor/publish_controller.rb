module YariiEditor
  class PublishController < ApplicationController
    def remote_is_up_to_date
      # NOTE: the Jekyll site config needs to include .well-known in the list of
      # folders to build! Otherwise this won't work!
      render json: {updated: current_site.remote_is_up_to_date?}
    end

    def menu
      render partial: "yarii_editor/shared/publishing_menu", formats: [:html]
    end

    def commit
      render layout: nil
    end

    def push_commit
      current_site.commit!(message: params[:commit_message])
      current_site.push

      render json: {status: 'ok'}
    end
  end
end