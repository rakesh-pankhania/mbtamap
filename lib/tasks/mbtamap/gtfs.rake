require 'open-uri'

namespace :gtfs do
  desc "Perform GTFS operations"
  task update: :environment do
    FEED_INFO_PATH = "http://www.mbta.com/uploadedfiles/feed_info.txt"
    puts "Connecting to #{FEED_INFO_PATH}..."
    feed_data = open("http://www.mbta.com/uploadedfiles/feed_info.txt").read

    puts "Parsing data..."
    feed_data = CSV.parse(feed_data, headers: true)
    feed_version = feed_data['feed_version'][0].to_s
    puts "Latest MBTA GTFS version: #{feed_version}"

    current_feed = Feed.select(:version).order('created_at DESC').first
    current_version = current_feed.present? ? current_feed.version : nil
    puts "App running GTFS version: #{current_version}"

    if current_version.nil? || feed_version != current_version
      Rake::Task["gtfs:load"].invoke
    else
      puts "No update needed"
    end
  end

  task load: :environment do
    puts "\n=== Loading GTFS ==="

    puts "Unzipping file..."
    source = GTFS::Source.build("http://www.mbta.com/uploadedfiles/MBTA_GTFS.zip")
    
    puts "Storing feed metadata..."
    raise if source.feed_infos.count > 1
    feed_info = source.feed_infos.first
    feed = Feed.create!(
      version: feed_info.version,
      start_date: Date.parse(feed_info.start_date),
      end_date: Date.parse(feed_info.end_date)
    )
    version = feed.version

    puts "Loading agencies"
    source.each_agency do |agency|
      Agency.create!(
        external_id: agency.id,
        name: agency.name,
        url: agency.url,
        timezone: agency.timezone,
        language: agency.lang,
        phone: agency.phone
      )
    end

    puts "=== Loading GTFS complete ==="
  end
end
