class DaemonContentWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { daily }

  sidekiq_options :queue => :daemon

  def perform
    Product.empty.find_each{|p| UpdateContentWorker.perform_async(p.id) }
  end
end