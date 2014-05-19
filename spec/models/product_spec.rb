require 'spec_helper'

describe Product do

  it "is valid without is_discontinued" do
    expect(Product.new(category: "测试类别", image_url: "测试地址")).to be_valid
  end

  it "is invalid if product has duplicated url_key" do
    Product.create(category: "测试类别", image_url: "测试地址", url_key: 'abc', type: "Product::Jd")
    expect(Product.new(category: "测试类别", image_url: "测试地址", url_key: 'abc', type: "Product::Jd")).to_not be_valid
  end


end
