# 自动加载文件
auto_required_paths = %w(lib)

auto_required_paths.each do |p|
  Dir["#{Rails.root}/lib/*.rb"].each {|f| require_dependency f}
end
