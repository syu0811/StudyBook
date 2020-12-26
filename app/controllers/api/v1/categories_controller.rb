module Api
  module V1
    class CategoriesController < ApiBaseController
      def index
        @categories = Category.all
        @default_category = Category.default_category
      end
    end
  end
end
