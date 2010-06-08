# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def host
    case Rails.env
    when "production"
      "yamtesto.choibean.com"
    else
      "localhost:3001"
    end
  end
end
