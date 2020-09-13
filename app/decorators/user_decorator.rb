class UserDecorator < Draper::Decorator
  delegate_all

  def fullname
    "#{lastname} #{firstname}"
  end
end
