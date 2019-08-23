class TimeFormatter
  TIME_ITEMS = {year: '%Y', month: '%m', day: '%d', hour: '%H', minute: '%M', second: '%S'}

  def initialize(env)
    @env = env
  end

  def arr_query
    query = Rack::Utils.parse_nested_query(@env['QUERY_STRING'])
    return [] if query.empty? || query["format"].empty?
    query["format"].split(',')
  end

  def bad_array
    (arr_query - TIME_ITEMS.map { |key, _value| key.to_s })
  end

  def correct_query?
    bad_array.empty?
  end

  def body_template
    arr_request = arr_query
    time_values = TIME_ITEMS.map do |key, value|
      value if arr_request.include?(key.to_s)
    end
    time_template = time_values.reject(&:nil?).join('-')
    [Time.now.strftime(time_template)]
  end
end
