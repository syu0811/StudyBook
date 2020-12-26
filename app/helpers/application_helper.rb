module ApplicationHelper
  def query_params
    params.permit(:category, :order, :page, :user)
  end
end
