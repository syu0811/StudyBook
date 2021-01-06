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
    @notes = Note.includes(:user, :category).limit(LIMIT_ITEMS)
    @partial_name = 'notes'
    @title = 'trend'
  end

  def new_my_lists
    @my_lists = MyList.includes(:user, :category).order(created_at: :desc).limit(LIMIT_ITEMS)
    @partial_name = 'my_lists'
    @title = 'new'
  end

  def trend_my_lists
    @my_lists = MyList.trend.limit(LIMIT_ITEMS)
    @partial_name = 'my_lists'
    @title = 'trend'
  end
end
