module YariiEditor
  class DashboardController < ApplicationController
    before_action :pull_if_needed

    def index
      @custom_lists = []
    end
  end
end