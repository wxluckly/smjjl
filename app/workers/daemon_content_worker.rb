class DaemonContentWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { daily }

  @queue = :daemon

  def perform
  end
end