module Admin
  class TagsController < ApplicationController
    before_action :authenticate_admin!
    before_action :get_tags, only: :index
    before_action :get_tag, only: [:edit, :update, :destroy]

    def new
      @tag = Tag.new
    end

    def create
      @tag = Tag.new(tag_params)
      if @tag.save
        redirect_to admin_tags_path, notice: t('flash.create')
      else
        render :new
      end
    end

    def update
      if @tag.update(tag_params)
        redirect_to admin_tags_path, notice: t('flash.update')
      else
        render :edit
      end
    end

    def destroy
      if @tag.destroy
        redirect_to admin_tags_path, notice: t('flash.destroy')
      else
        redirect_to admin_tags_path, notice: t('flash.failed_destroy')
      end
    end

    private

    def tag_params
      params.require(:tag).permit(:name)
    end

    def get_tags
      @tags = Tag.all
    end

    def get_tag
      @tag = Tag.find(params[:id])
    end
  end
end
