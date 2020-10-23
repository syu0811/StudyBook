module Admin
  class CategoriesController < ApplicationController
    before_action :authenticate_admin!
    before_action :get_categories, only: :index

    def new
      @category = Category.new
    end

    def create
      @category = Category.new(category_params)
      if @category.save
        redirect_to admin_categories_path, notice: t('flash.create')
      else
        render :new
      end
    end

    private

    def category_params
      params.require(:category).permit(:name)
    end

    def get_categories
      @categories = Category.all
    end
  end
end
