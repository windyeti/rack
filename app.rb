require_relative 'select_formatter'

class App
  def call(env)
    @formatter = SelectFormatter.new(env).select
    return [404, {}, []] if @formatter.nil?
    [@formatter.status, @formatter.headers, @formatter.body]
  end
end
