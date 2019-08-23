class TimeFormatterMax
  TIME_ITEMS = {year: '%Y', month: '%m', day: '%d', hour: '%H', minute: '%M', second: '%S'}

  def initialize(env)
    @env = env
    @good_query = []
    @bad_query = []
    split_array
  end

  def arr_query
    query = Rack::Utils.parse_nested_query(@env['QUERY_STRING'])
    return [] if query.empty? || query["format"].empty?
    query["format"].split(',')
  end

  def split_array
    good_query_array, @bad_query = arr_query.partition { |i| TIME_ITEMS["#{i}".to_sym] }
    @good_query = TIME_ITEMS.map do |i|
      i[1] if good_query_array.include?(i[0].to_s)
    end
  end

  def bad_array
    @bad_query
  end

  def correct_query?
    @bad_query.empty?
  end

  def body_template
    time_template = @good_query.reject(&:nil?).join('-')
    [Time.now.strftime(time_template)]
  end

  # def bad_array
  #   (arr_query - TIME_ITEMS.map { |key, _value| key.to_s })
  # end
  #
  # def correct_query?
  #   bad_array.empty?
  # end
  #
  # def body_template
  #   arr_request = arr_query
  #   time_values = TIME_ITEMS.map do |key, value|
  #     value if arr_request.include?(key.to_s)
  #   end
  #   time_template = time_values.reject(&:nil?).join('-')
  #   [Time.now.strftime(time_template)]
  # end
end
