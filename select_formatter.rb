require_relative 'time_formatter'

class SelectFormatter
  def initialize(env)
    @env = env
  end

  def select
    return TimeFormatter.new(@env) if @env['REQUEST_PATH'] == '/time'
  end
end
