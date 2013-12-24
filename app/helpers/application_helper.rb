module ApplicationHelper
  def display_flash
    flash_div = []
    flash_div << "<span class='label label-success'>#{flash[:notice]}</span>" if flash[:notice].present?
    flash_div << "<span class='label label-warning'>#{flash[:warn]}</span>" if flash[:warn].present?
    flash_div << "<span class='label alert-error'>#{flash[:error]}</span>" if flash[:error].present?
    erb = ['<div class=flash>',flash_div,'</div>'].flatten.join('')
    return raw erb
  end

  def friendly_time time
    pass_seconds = Time.now.to_i - time.to_i
    return "刚刚" if pass_seconds < 30 * 60
    return "半小时前" if pass_seconds < 1.hours
    return "#{(pass_seconds) / 1.hours}小时前" if pass_seconds < 10.hours
    time.strftime("%Y年%m月%d日 %H:%M:%S")
  end

  def show_info info
    info.gsub("data-lazyload", "src").html_safe rescue "暂无内容"
  end
end
