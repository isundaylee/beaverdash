class Event
  include MongoMapper::Document

  key :title, String
  key :raw, String
end