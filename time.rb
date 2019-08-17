require_relative 'format'

class Time
  include Format

  TIME_ITEMS = %w{year month day hour minute second}.freeze

  def call(env)
    [status(env), headers(env), body(env)]
  end

  private

  def status(env)
    return 404 if env['REQUEST_PATH'] != '/time' || env['REQUEST_METHOD'] != 'GET'
    return 400 unless correct_query?(env)
    200
  end

  def headers(env)
    { 'Content-Type' => 'text/plain', 'Content-Length' => "#{body(env).join('').length}" }
  end

  def body(env)
    if correct_query?(env)
      body_template(env)
    else
      ["Unknown time format", " #{(arr_query(env) - TIME_ITEMS)}"]
    end
  end
end
