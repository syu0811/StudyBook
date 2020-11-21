module Api
  module V1
    class TagsController < ApiBaseController
      def index
        @tags = Tag.where('updated_at >= ?', params[:updated_at])
      end
    end
  end
end
