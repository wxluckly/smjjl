namespace :back_fill do

  desc "将product的info内容转移到专门的表"
  task :move_info => :environment do
    Product.select(:id).find_each do |p|
      p = Product.find(p.id)
      if p.info.blank?
        p "skip info blank : #{p.id}"
        next
      end
      pi = ProductInfo.find_or_initialize_by(product_id: p.id)
      if pi.info.present?
        p "skip has info : #{p.id}"
        next
      end 
      pi.product = p
      pi.info = p.info
      pi.save
      p.product_info = pi
      p "save #{p.id}"
      p.save
    end
  end

end