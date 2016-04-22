smjjl
=====

rake db:migrate

rake db:seed

rails c
  ProductRoot::Jd.first.get_lists  # 获取商品列表
  ProductList::Jd.first.get_product_ids  # 获取商品id

# restart worker
bundle exec rake sidekiq:restart

# master whenever
whenever -i

# worker whenever
whenever -rworker -i