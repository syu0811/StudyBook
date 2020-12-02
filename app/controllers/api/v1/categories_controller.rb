module Api
  module V1
    class CategoriesController < ApiBaseController
      def index
        @categories = Category.where('updated_at >= ?', params[:updated_at])
        @default_category = Category.default_category
      end
    end
  end
end
