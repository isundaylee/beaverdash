class ActiveSupport::Logger::SimpleFormatter
  def call(severity, time, progname, msg)
    "[#{time}] [#{severity}] #{msg}\n"
  end
end