namespace :router_nodes do
	task setup: :environment do
		file = APP_CONFIG[:router_nodes][:point_data]
		url = 'https://dl.dropboxusercontent.com/content_link/bJkT7uNzYkW9zmQCY7Vnl8plH9rV73rvpJx6sNexyM4VjbtDUtf9DkLyy9GFYnIg?dl=1'

  	command = "curl \"#{url}\" -o \"#{file}\""
  	`#{command}`
	end

  task download: :environment do
  	file = APP_CONFIG[:router_nodes][:data_file]
  	url = 'http://istc3.csail.mit.edu:8999/log_09-25-to-oct.csv'

  	command = "curl \"#{url}\" -o \"#{file}\""
  	`#{command}`
  end

  desc "TODO"
  task import: :environment do
  	all_rows = File.read(APP_CONFIG[:router_nodes][:data_file]).lines
  	latest_timestamp = all_rows[0].split(',')[0]
  	rows = all_rows.select { |r| r.split(',')[0] == latest_timestamp }

  	apn_rows = File.read(APP_CONFIG[:router_nodes][:point_data]).lines
  	apns = {}

  	apn_rows.each do |r|
  		i, b, r, lat, lon = r.split(',')
  		lon.strip! 

  		next if lat == 'None' or lon == 'None'

  		apns[i] = [lat, lon]
  	end

  	RouterNode.destroy_all

  	rows.each do |r|
  		t, n, i = r.split(',')
  		i.strip! 
  		apn = apns[i]
  		next if apn.nil?
  		RouterNode.create(lat: apn[0], lon: apn[1], users: n)
  	end

  	puts "Successfully imported #{rows.count} data points! "
  end

end
