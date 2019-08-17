module Format

  def arr_query(env)
    return [] if env['QUERY_STRING'].empty?
    index_equal_sign = env['QUERY_STRING'] =~ /=/
    items_query = env['QUERY_STRING'][index_equal_sign + 1..-1]
    items_query.split('%2C')
  end

  def correct_query?(env)
    (arr_query(env) - Time::TIME_ITEMS).empty?
  end

  def body_template(env)
    arr = arr_query(env)
    time = Time.now
    arr_result = Time::TIME_ITEMS.map do |item|
      if arr.include?(item)
        item = 'min' if item == 'minute'
        item = 'sec' if item == 'second'
        time.send("#{item}")
      end
    end
    arr_result = arr_result.reject(&:nil?)
    arr_result = arr_result.join('-')
    [arr_result]
  end
end
