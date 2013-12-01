class DaemonIdWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { daily }

  @queue = :daemon

  def perform
    ProductRoot::Jd.find_each do |r|
      r.get_lists
    end
    ProductList::Jd.find_each do |l|
      UpdateIdWorker.perform_async(l.id)
    end
  end
end