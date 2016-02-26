module Wap::Entities
  class BaseEntity < Grape::Entity
    format_with(:null) { |v| (v != false && v.blank?) ? "" : v }
    format_with(:null_int) { |v| v.blank? ? 0 : v }
    format_with(:null_bool) { |v| v.blank? ? false : v }
    format_with(:short_dt) { |v| v.blank? ? "" : v.strftime("%Y-%m-%d %H:%M:%S") }
    format_with(:short_t) { |v| v.blank? ? "" : v.strftime("%Y-%m-%d %H:%M") }
  end

  # 错误返回
  class BaseError < Grape::Entity
    expose :error, documentation: {required: true, type: "String", desc: "错误信息"}
  end
  class Error < BaseError
    expose :field, documentation: {required: true, type: "String", desc: "错误字段"}
  end

  class Bargain < BaseEntity
    expose :id, documentation: {required: true, type: "Integer", desc: "ID"}, format_with: :null_int
    expose :product_id, documentation: {required: true, type: "Integer", desc: "产品ID"}, format_with: :null_int
    expose :product_name, documentation: {required: true, type: "String", desc: "产品名"}, format_with: :null
    expose :product_img, documentation: {required: true, type: "String", desc: "产品图片"}, format_with: :null
    expose :created_at, documentation: {required: true, type: "Datetime", desc: "时间"}, as: :created_at, format_with: :null
  end
  class Bargains < BaseEntity
    present_collection true, :bargains
    expose :bargains, using: Bargain, documentation: {required: true, type: "Bargain", is_array: true, desc: "集合"}, format_with: :null
  end

  class Product < BaseEntity
    expose :id, documentation: {required: true, type: "Integer", desc: "ID"}, format_with: :null_int
    expose :name, documentation: {required: true, type: "String", desc: "产品名"}, format_with: :null
    expose :image_url, documentation: {required: true, type: "String", desc: "产品图片"}, format_with: :null, as: :image_url
    expose :created_at, documentation: {required: true, type: "Datetime", desc: "时间"}, as: :created_at, format_with: :null
  end
end
