class TimeFormat
  TIME_ITEMS = %w{year month day hour minute second}.freeze

  def call(env)
    def arr_query(env)
      return [] if env['QUERY_STRING'].empty?
      index_equal_sign = env['QUERY_STRING'] =~ /=/
      items_query = env['QUERY_STRING'][index_equal_sign + 1..-1]
      items_query.split('%2C')
    end


    def correct_query?(env)
      (arr_query(env) - TIME_ITEMS).empty?
    end

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

    def body_template(env)
      arr = arr_query(env)
      time = Time.now
      arr_result = TIME_ITEMS.map do |item|
        if arr.include?(item)
          item = 'min' if item == 'minute'
          item = 'sec' if item == 'second'
          time.send("#{item}")
        end
      end
      arr_result = arr_result.reject {|e| e.nil?}
      arr_result = arr_result.join('-')
      [arr_result]
    end

    [status(env), headers(env), body(env)]
  end
end
