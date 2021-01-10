class TopController < ApplicationController
  LIMIT_ITEMS = 30

  def index
    case params[:select]
    when 'trend_notes'
      trend_notes
    when 'new_notes'
      new_notes
    when 'trend_my_lists'
      trend_my_lists
    else
      new_my_lists
    end
  end

  private

  def new_notes
    @notes = Note.includes(:user, :category).order(created_at: :desc).limit(LIMIT_ITEMS)
    @partial_name = 'notes'
    @title = 'new'
  end

  def trend_notes
    @notes = Note.trend_notes(current_user.id, LIMIT_ITEMS)
    @partial_name = 'notes'
    @title = 'trend'
  end

  def new_my_lists
    @my_lists = MyList.includes(:user, :category).order(created_at: :desc).limit(LIMIT_ITEMS)
    @partial_name = 'my_lists'
    @title = 'new'
    get_user_subscribe_my_list_ids
  end

  def trend_my_lists
    @my_lists = MyList.trend.limit(LIMIT_ITEMS)
    @partial_name = 'my_lists'
    @title = 'trend'
    get_user_subscribe_my_list_ids
  end

  def get_user_subscribe_my_list_ids
    @user_subscribe_my_list_ids = current_user.subscribe_my_lists.pluck(:my_list_id)
  end
end
