module Admin
  class TagsController < ApplicationController
    before_action :get_tags, only: :index

    private

    def get_tags
      @tags = Tag.all
    end
  end
end
