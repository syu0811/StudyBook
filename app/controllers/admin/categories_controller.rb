module Admin
  class CategoriesController < ApplicationController
    before_action :authenticate_admin!
    before_action :get_categories, only: :index

    private

    def get_categories
      @categories = Category.all
    end
  end
end
