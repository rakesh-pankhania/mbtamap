require 'open-uri'

namespace :gtfs do
  desc "Perform GTFS operations"
  task update: :environment do
    FEED_INFO_PATH = "http://www.mbta.com/uploadedfiles/feed_info.txt"
    puts "Connecting to #{FEED_INFO_PATH}"
    feed_data = open("http://www.mbta.com/uploadedfiles/feed_info.txt").read

    puts "Parsing data"
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

    @source = load_source
    Rake::Task["gtfs:load_feed"].invoke
    Rake::Task["gtfs:load_agencies"].invoke
    Rake::Task["gtfs:load_routes"].invoke
    Rake::Task["gtfs:load_trips"].invoke

    puts "=== Loading GTFS complete ==="
  end

  task load_feed: :environment do
    @source ||= load_source
    puts "Loading feed metadata"
    
    raise if @source.feed_infos.count > 1
    feed_info = @source.feed_infos.first
    feed = Feed.create!(
      version: feed_info.version,
      start_date: Date.parse(feed_info.start_date),
      end_date: Date.parse(feed_info.end_date)
    )
  end

  task load_agencies: :environment do
    @source ||= load_source
    puts "Loading agencies"

    @source.each_agency do |agency|
      Agency.create!(
        external_id: agency.id,
        name: agency.name,
        url: agency.url,
        timezone: agency.timezone,
        language: agency.lang,
        phone: agency.phone
      )
    end
  end

  task load_routes: :environment do
    @source ||= load_source
    puts "Loading routes"

    agency = nil
    @source.each_route do |route|
      agency = Agency.find_by!(external_id: route.agency_id) if agency.nil? || agency.external_id != route.agency_id.to_s
      agency.routes.create!(
        external_id: route.id,
        short_name: route.short_name,
        long_name: route.long_name,
        description: route.desc,
        route_type: route.type,
        url: route.url,
        color: route.color,
        text_color: route.text_color
      )
    end
  end

  task load_trips: :environment do
    @source ||= load_source
    puts "Loading trips"

    route = nil
    @source.each_trip do |trip|
      route = Route.find_by!(external_id: trip.route_id) if route.nil? || route.external_id != trip.route_id.to_s
      route.trips.create!(
        external_id: trip.id,
        headsign: trip.headsign,
        short_name: trip.short_name,
        direction: trip.direction_id,
        block_id: trip.block_id,
        wheelchair_accessible: trip.wheelchair_accessible
      )
    end
  end

  def load_source
    puts "Loading file"
    @source = GTFS::Source.build("http://www.mbta.com/uploadedfiles/MBTA_GTFS.zip")
  end
end
