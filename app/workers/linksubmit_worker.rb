class LinksubmitWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :linksubmit

  def perform(product_id)
    product = Product.find(product_id)
    urls = ["http://www.smjjl.com/products/#{product.to_param}"]
    uri = URI.parse('http://data.zz.baidu.com/urls?site=www.smjjl.com&token=NdXEXgoFUucOFtHn')
    req = Net::HTTP::Post.new(uri.request_uri)
    req.body = urls.join("\n")
    req.content_type = 'text/plain'
    res = Net::HTTP.start(uri.hostname, uri.port) { |http| http.request(req) }
    puts res.body
  end
end