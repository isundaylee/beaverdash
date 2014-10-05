class Event
  include MongoMapper::Document

  key :title, String
  key :raw, String

  key :location, Hash

  key :parsed, Boolean
  key :valid, Boolean

  def parse!
    bn = parse_building_number(title) || parse_building_number(raw)

    set(
      location: bn,
      parsed: true,
      valid: !bn.nil?
    )
  end

  def friendly_location
    loc = location
    return nil if loc.nil? or loc.empty?

    num = loc[:room] ?
      "#{loc[:building]}-#{loc[:room]}" :
      "#{loc[:building]}"

    "Building #{num.upcase}#{(' ' + loc[:floor].titleize) rescue ''}#{(' ' + loc[:signal_words].map(&:titleize).join('/')) rescue ''}"
  end

  private

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