class Wap::Api < Grape::API
  require 'grape'

  format :json
  default_format :json
  default_error_status 401

  # 全局错误处理
  rescue_from :all do |e|
    case
    when false
    else error!({error: e.message}, e.is_a?(ActiveRecord::RecordNotFound) ? 404 : 422)
    end
  end

  namespace :wap_api, desc: ' ', swagger: { nested: false } do
    mount Wap::BargainApi
    mount Wap::ProductApi

    add_swagger_documentation(
      mount_path: '/swagger',

      format: :json,
      hide_format: true,
      markdown: GrapeSwagger::Markdown::KramdownAdapter.new,

      api_version: '1.0',
      hide_documentation_path: true,

      info: {
        title: 'wap相关API'
      }
      )

    route :any, '*path' do
      error!({error: '错误的接口地址', field: 404, with: Wap::Entities::Error}, 404)
    end
  end
end