# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Site::Jd.create(name: "京东商城")
ProductRoot::Jd.create(url: "http://list.jd.com/737-794-798-0-0-0-0-0-0-0-1-1-1-1-1-72-4137-33.html")
ProductRoot::Jd.create(url: "http://list.jd.com/9987-653-655-0-0-0-0-0-0-0-1-1-1-1-1-72-4137-33.html")
ProductRoot::Jd.create(url: "http://list.jd.com/670-671-672-0-0-0-0-0-0-0-1-1-1-1-1-72-4137-0.html")

Site::Amazon.create(name: "亚马逊")
ProductRoot::Amazon.create(url: "http://www.amazon.cn/gp/site-directory")

Site::Newegg.create(name: "新蛋")
ProductRoot::Newegg.create(url: "http://www.newegg.cn/CategoryList.htm")

Site::Dangdang.create(name: "当当")
ProductRoot::Dangdang.create(url: "http://category.dangdang.com")

Site::Gome.create(name: "国美在线")
ProductRoot::Gome.create(url: "http://list.gome.com.cn/")