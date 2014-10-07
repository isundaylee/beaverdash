namespace :router_nodes do
  require 'open-uri'
	task setup: :environment do
		file = APP_CONFIG[:router_nodes][:point_data]
		url = 'https://www.dropbox.com/sh/mym5ux7yb3vjqs3/AAA7rXMvumWpkCHjuEGLZUPka/wifi_access_point_data.csv?dl=1'

  	command = "curl \"#{url}\" -L -o \"#{file}\""
  	`#{command}`
	end

  task download: :environment do
  	file = APP_CONFIG[:router_nodes][:data_file]
  	url = 'http://istc3.csail.mit.edu:8999/log_09-25-to-oct.csv'

  	command = "curl \"#{url}\" -o \"#{file}\""
  	`#{command}`

    Rails.logger.info "Data points downloaded. "
  end

  desc "TODO"
  task import: :environment do
  	all_rows = File.foreach(APP_CONFIG[:router_nodes][:data_file]).first(6000)
  	latest_timestamp = all_rows[0].split(',')[0]
  	rows = all_rows.select { |r| r.split(',')[0] == latest_timestamp }

  	apn_rows = File.read(APP_CONFIG[:router_nodes][:point_data]).lines
  	apns = {}

  	apn_rows.each do |r|
      next if r.strip.empty?
  		i, b, r, lon, lat = r.split(',')
  		lat.strip!

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

  	Rails.logger.info "#{rows.count} data point(s) imported. "

    Rake::Task["events:cache_predator_data"].execute
  end

  task download_and_import: :environment do
    Rake::Task["router_nodes:download"].execute
    Rake::Task["router_nodes:import"].execute
  end

end
