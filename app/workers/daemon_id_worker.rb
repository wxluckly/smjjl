class DaemonIdWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { daily }

  sidekiq_options :queue => :daemon

  def perform
    ProductRoot.find_each{ |r| r.get_lists } 
    ProductList.find_each{ |l| GetPaginationWorker.perform_async(l.id) }
  end
end