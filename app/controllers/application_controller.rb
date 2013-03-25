class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :category_list

  def category_list
    Category.all
  end
end