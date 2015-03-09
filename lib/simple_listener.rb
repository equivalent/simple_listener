require "simple_listener/version"

module SimpleListener
  def add_listener(listener)
    (@listeners ||= []) << listener
  end

  def call_listeners(event_name, *args)
    @listeners && @listeners.each do |listener|
      if listener.respond_to?(event_name)
        listener.public_send(event_name, self, *args)
      end
    end
  end
end
