module ApplicationHelper
  def display_flash
    flash_div = []
    flash_div << "<span class='label label-success'>#{flash[:notice]}</span>" if flash[:notice].present?
    flash_div << "<span class='label label-warning'>#{flash[:warn]}</span>" if flash[:warn].present?
    flash_div << "<span class='label alert-error'>#{flash[:error]}</span>" if flash[:error].present?
    erb = ['<div class=flash>',flash_div,'</div>'].flatten.join('')
    return raw erb
  end
end
