class RouterNode

	include MongoMapper::Document

	key :lat, Float
	key :lon, Float
	key :users, Integer

end