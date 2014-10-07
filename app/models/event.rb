class Event
  include MongoMapper::Document

  key :title, String
  key :raw, String

  key :location, Hash
  key :lat, Float
  key :lon, Float
  key :foods, String

  key :parsed, Boolean
  key :valid, Boolean

  timestamps!

  DELIMITER = '[^a-z0-9-]'

  def parse!
    bn = parse_building_number(title) || parse_building_number(raw)
    latlon = retrieve_latlon(bn[:building] || bn[:city]) unless bn.nil?

    self.location = bn
    self.parsed = true
    self.valid = !bn.nil?

    unless bn.nil?
      self.lat = latlon[0]
      self.lon = latlon[1]
      self.foods = parse_food(raw) || parse_food(title)
    end

    save
  end

  def friendly_location
    loc = location
    return nil if loc.nil? or loc.empty?

    return 'East Cambridge' if (loc[:city] && loc[:city] == 'east cambridge')

    num = loc[:room] ?
      "#{loc[:building]}-#{loc[:room]}" :
      "#{loc[:building]}"

    signals = (loc[:signal_words].nil? || loc[:signal_words].empty?) ?
      '' :
      loc[:signal_words].map(&:titleize).join('/')

    "Building #{num.upcase}#{(' ' + loc[:floor].titleize) rescue ''}#{signals}"
  end

  def friendly_datetime
    Time.at(id.generation_time).localtime.strftime('%l:%M %p').strip
  end

  def raw_datetime
    Time.at(id.generation_time).to_i
  end

  def estimated_predators
    Rails.cache.fetch(['estimated_predators', id.to_s, RouterNode.first.id.generation_time]) do
      ans = 0.0
      values = []

      RouterNode.each do |n|
        d = distance_from(n.lat, n.lon)

        p = (d + 3.334) / 2.055
        v = 0.04384 * Math.exp(-p * p) * n.users
        ans += v

        values << [n.lat, n.lon, v] if Random.rand <= 0.003 * Math.exp(v / 0.005)
      end

      puts values.count

      [ans, values]
    end
  end

  def friendly_foods
    foods.capitalize rescue ''
  end

  def distance_from(nlat, nlon)
    dlat = 85 * (lat - nlat)
    dlon = 111.321 * (lon - nlon)
    Math.sqrt(dlat * dlat + dlon * dlon)
  end

  private

    def retrieve_latlon(building_or_city)
      if building_or_city == 'east cambridge'
        return [42.367026, -71.081706]
      end

      url = URI.parse('http://m.mit.edu/apis/maps/places/?q=' + building_or_city)
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

      return {
        building: "10",
        room: "dome"
      } if /catmit/ =~ text

      dashed_regex = Regexp.new(DELIMITER + buildings_reg + '-((g|)[0-9]{3,})' + DELIMITER)
      dashed_match = dashed_regex.match(text)

      return {
        building: dashed_match[1],
        room: dashed_match[2]
      } if dashed_match

      num_only_regex = Regexp.new(DELIMITER + buildings_reg + DELIMITER)
      num_only_match = num_only_regex.match(text)

      return {
        building: num_only_match[1],
        floor: extract_floor(text),
        signal_words: APP_CONFIG[:parse][:location_signal_words].select { |w| text =~ Regexp.new(w) }
      } if num_only_match

      name_regex = Regexp.new(DELIMITER + building_names_reg + DELIMITER)
      name_match = name_regex.match(text)

      return {
        building: APP_CONFIG[:parse][:building_names][name_match[1]],
        floor: extract_floor(text),
        signal_words: APP_CONFIG[:parse][:location_signal_words].select { |w| text =~ Regexp.new(w) }
      } if name_match

      return {
        city: 'east cambridge'
      } if /east cambridge/ =~ text

      return nil
    end

    def foods_reg
      "(#{APP_CONFIG[:parse][:foods].join('|')})".downcase
    end

    def parse_food(text)
      text = " #{text.downcase} "
      reg = Regexp.new("\\A" + DELIMITER + foods_reg + DELIMITER)

      matches = (0...text.length).map do |i|
        [reg.match(text[i...text.length]), i]
      end.select do |i|
        !i[0].nil?
      end

      matches.empty? ?
        nil :
        text[matches.first[1] + 1 ... matches.last[1]+matches.last[0][0].length - 1]
    end
end