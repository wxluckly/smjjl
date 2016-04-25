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
    return "刚刚" if pass_seconds < 60
    return "#{pass_seconds / 60}分钟前" if pass_seconds < 60 * 60
    return "#{(pass_seconds) / 1.hours}小时前" if pass_seconds < 24.hours
    time.strftime("%Y-%m-%d")
  end

  def show_info info
    info.encode("utf-8").gsub("center", "").html_safe rescue "暂无内容"
  end

  def zhe_class discount
    case discount.to_i
    when 0 then 'yizhe'
    when 1 then 'yizhe'
    when 2 then 'erzhe'
    when 3 then 'sanzhe'
    when 4 then 'sizhe'
    when 5 then 'wuzhe'
    when 6 then 'liuzhe'
    when 7 then 'qizhe'
    end
  end
end
