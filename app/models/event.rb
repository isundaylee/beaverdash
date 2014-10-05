class Event
  include MongoMapper::Document

  key :title, String
  key :raw, String

  key :location, Hash
  key :lat, Float
  key :lon, Float

  key :parsed, Boolean
  key :valid, Boolean

  def parse!
    bn = parse_building_number(title) || parse_building_number(raw)
    latlon = retrieve_latlon(bn[:building]) unless bn.nil?

    set(
      location: bn,
      parsed: true,
      valid: !bn.nil?
    )

    set(
      lat: latlon[0],
      lon: latlon[1]
    ) unless bn.nil?

    puts latlon
  end

  def friendly_location
    loc = location
    return nil if loc.nil? or loc.empty?

    num = loc[:room] ?
      "#{loc[:building]}-#{loc[:room]}" :
      "#{loc[:building]}"

    "Building #{num.upcase}#{(' ' + loc[:floor].titleize) rescue ''}#{(' ' + loc[:signal_words].map(&:titleize).join('/')) rescue ''}"
  end

  def friendly_datetime
    Time.at(id.generation_time).localtime.strftime('%l:%M %p').strip
  end

  def estimated_predators
    Rails.cache.fetch(['estimated_predators', id.to_s, RouterNode.first.id.generation_time]) do
      ans = 0.0
      values = []

      RouterNode.each do |n|
        dlat = 85 * (lat - n.lat)
        dlon = 110 * (lon - n.lon)
        d = Math.sqrt(dlat * dlat + dlon * dlon)

        p = (d + 3.334) / 2.055
        v = 0.04384 * Math.exp(-p * p) * n.users
        ans += v

        values << [n.lat, n.lon, v] if Random.rand <= 0.003 * Math.exp(v / 0.005)
      end

      puts values.count

      [ans, values]
    end
  end

  private

    def retrieve_latlon(building)
      url = URI.parse('http://m.mit.edu/apis/maps/places/?q=' + building)
      req = Net::HTTP::Get.new(url.to_s)
      res = Net::HTTP.start(url.host, url.port) {|http|
        http.request(req)
      }
      content_hash = JSON.parse(res.body)
      [content_hash[0]['lat_wgs84'].to_f, content_hash[0]['long_wgs84'].to_f]
    end

    def extract_floor(text)
      delimiter = '[^a-z0-9-]'
      reg = Regexp.new(delimiter + '([0-9a-z-]*)' + delimiter + 'floor')
      match = reg.match(text)

      match ? "#{match[1]} floor" : nil
    end

    def buildings_reg
      "(#{APP_CONFIG[:parse][:building_numbers].join('|')})".downcase
    end

    def building_names_reg
      "(#{APP_CONFIG[:parse][:building_names].keys.join('|')})".downcase
    end

    def parse_building_number(text)
      text.downcase!
      text = " #{text} "
      delimiter = '[^a-z0-9-]'

      dashed_regex = Regexp.new(delimiter + buildings_reg + '-((g|)[0-9]{3,})' + delimiter)
      dashed_match = dashed_regex.match(text)

      return {
        building: dashed_match[1],
        room: dashed_match[2]
      } if dashed_match

      num_only_regex = Regexp.new(delimiter + buildings_reg + delimiter)
      num_only_match = num_only_regex.match(text)

      return {
        building: num_only_match[1],
        floor: extract_floor(text),
        signal_words: APP_CONFIG[:parse][:location_signal_words].select { |w| text =~ Regexp.new(w) }
      } if num_only_match

      name_regex = Regexp.new(delimiter + building_names_reg + delimiter)
      name_match = name_regex.match(text)

      return {
        building: APP_CONFIG[:parse][:building_names][name_match[1]],
        floor: extract_floor(text),
        signal_words: APP_CONFIG[:parse][:location_signal_words].select { |w| text =~ Regexp.new(w) }
      } if name_match

      return nil
    end

    def parse_time(text)
    end
end