class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :remove_line_break

  def remove_line_break str
    str.to_s.gsub(/[\r\n\t]/, " ").gsub(/\s+/, " ")
  end
end
