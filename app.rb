require_relative 'select_formatter'

class App
  def call(env)
    @formatter = SelectFormatter.new(env).select
    return [404, {}, []] if @formatter.nil?
    [status, headers, body]
  end

  def status
    return 400 unless @formatter.correct_query?
    200
  end

  def headers
    { 'Content-Type' => 'text/plain', 'Content-Length' => "#{body.join('').length}" }
  end

  def body
    if  @formatter.correct_query?
      @formatter.body_template
    else
      ["Unknown time format", " #{ @formatter.diff_arrays}"]
    end
  end
end
