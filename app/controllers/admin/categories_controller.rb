module Admin
  class CategoriesController < ApplicationController
    before_action :authenticate_admin!
    before_action :get_categories, only: :index
    before_action :get_category, only: [:edit, :update, :destroy]

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

    def update
      if @category.update(category_params)
        redirect_to admin_categories_path, notice: t('flash.update')
      else
        render :edit
      end
    end

    def destroy
      if @category.destroy
        redirect_to admin_categories_path, notice: t('flash.destroy')
      else
        redirect_to admin_categories_path, notice: t('flash.failed_destroy')
      end
    end

    private

    def category_params
      params.require(:category).permit(:name)
    end

    def get_categories
      @categories = Category.all
    end

    def get_category
      @category = Category.find(params[:id])
    end
  end
end
