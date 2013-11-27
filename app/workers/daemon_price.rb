class DaemonPrice
  @queue = :daemon

  def self.perform
    Product::Jd.find_each do |p|
      Resque.enqueue(UpdateJdPrice, p.id)
    end
  end
end