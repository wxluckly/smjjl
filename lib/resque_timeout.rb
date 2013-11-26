require 'resque/worker'

module Resque
  module Timeout
    def self.timeout
      @timeout ||= 7200
    end

    def self.timeout=(val)
      @timeout = val
    end

    def around_perform_with_timeout(*args)
      ::Timeout.timeout(Resque::Timeout.timeout) do
        yield
      end
    end
  end
  
  # inject the Timeout mixin into the job class right before it
  # executes (if it's not already there). This will give it the
  # `around_perform_...` method above which wraps the execution
  # in the ::Timeout.timeout block
  Resque.before_fork do |job|
    if !(job.payload_class.kind_of?(Resque::Timeout))
      job.payload_class.send(:extend, Resque::Timeout)
    end
  end
end
