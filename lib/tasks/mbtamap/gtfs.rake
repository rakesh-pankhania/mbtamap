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
    Rake::Task["gtfs:load_shapes"].invoke
    Rake::Task["gtfs:load_stops"].invoke
    Rake::Task["gtfs:load_stop_times"].invoke
    Rake::Task["gtfs:load_transfers"].invoke
    Rake::Task["gtfs:load_services"].invoke

    puts "=== Finished ==="
  end

  task load_feed: :environment do
    @source ||= load_source
    puts "Loading feed metadata"

    raise unless @source.feed_infos.count == 1
    feed = @source.feed_infos.first
    Feed.create!(
      publisher_name: feed.publisher_name,
      publisher_url: feed.publisher_url,
      lang: feed.lang,
      version: feed.version,
      start_date: Date.parse(feed.start_date),
      end_date: Date.parse(feed.end_date)
    )
  end

  task load_agencies: :environment do
    @source ||= load_source
    puts "Loading agencies"

    Agency.transaction do
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
  end

  task load_routes: :environment do
    @source ||= load_source
    puts "Loading routes"

    Route.transaction do
      @source.each_route do |route|
        Route.create!(
          external_id: route.id,
          agency_external_id: route.agency_id,
          short_name: route.short_name,
          long_name: route.long_name,
          description: route.desc,
          route_type: route.type.to_i,
          url: route.url,
          color: route.color,
          text_color: route.text_color
        )
      end
    end
  end

  task load_trips: :environment do
    @source ||= load_source
    puts "Loading trips"

    trips = []
    attributes = [
      :external_id, :route_external_id, :service_external_id,
      :shape_external_id, :headsign, :short_name, :direction_id, :block_id,
      :wheelchair_accessible
    ]
    @source.each_trip do |trip|
      trips << [
        trip.id, trip.route_id, trip.service_id, trip.shape_id, trip.headsign,
        trip.short_name, trip.direction_id, trip.block_id,
        trip.wheelchair_accessible
      ]
    end

    Trip.import attributes, trips, validate: false
  end

  task load_shapes: :environment do
    @source ||= load_source
    puts "Loading shapes"

    points = []
    shapes = []
    point_attributes = [
      :shape_external_id, :lattitude, :longitude, :sequence, :dist_traveled
    ]
    shape_attributes = [:external_id]
    shape_ids = Set.new

    @source.each_shape do |shape|
      points << [
        shape.id, shape.pt_lat, shape.pt_lon, shape.pt_sequence,
        shape.dist_traveled
      ]

      shape_ids << shape.id
    end

    shape_ids.each do |shape_id|
      shapes << [shape_id]
    end

    Shape.transaction do
      Shape.import shape_attributes, shapes, validate: false
      Point.import point_attributes, points, validate: false
    end
  end

  task load_stops: :environment do
    @source ||= load_source
    puts "Loading stops"

    stops = []
    attributes = [
      :external_id, :parent_station_external_id, :code, :name, :description,
      :lattitude, :longitude, :url, :location_type, :wheelchair_boarding
    ]
    @source.each_stop do |stop|
      stops << [
        stop.id, stop.parent_station, stop.code, stop.name, stop.desc, stop.lat,
        stop.lon, stop.url, stop.location_type, stop.wheelchair_boarding
      ]
    end

    Stop.import attributes, stops, validate: false
  end

  task load_stop_times: :environment do
    @source ||= load_source
    puts "Loading stop times"

    stop_times = []
    attributes = [
      :stop_external_id, :trip_external_id, :arrival_time, :departure_time,
      :stop_sequence, :stop_headsign, :pickup_type, :drop_off_type
    ]
    @source.each_stop_time do |stop_time|
      stop_times << [
        stop_time.stop_id, stop_time.trip_id, stop_time.arrival_time,
        stop_time.departure_time, stop_time.stop_sequence,
        stop_time.stop_headsign, stop_time.pickup_type, stop_time.drop_off_type
      ]
    end

    StopTime.import attributes, stop_times, validate: false
  end

  task load_transfers: :environment do
    @source ||= load_source
    puts "Loading transfers"

    Transfer.transaction do
      @source.each_transfer do |transfer|
        Transfer.create!(
          from_stop_external_id: transfer.from_stop_id,
          to_stop_external_id: transfer.to_stop_id,
          transfer_type: transfer.type,
          min_transfer_time: transfer.min_transfer_time
        )
      end
    end
  end

  task load_services: :environment do
    @source ||= load_source
    puts "Loading services"

    Service.transaction do
      @source.each_calendar do |calendar|
        Service.create!(
          external_id: calendar.service_id,
          monday: calendar.monday,
          tuesday: calendar.tuesday,
          wednesday: calendar.wednesday,
          thursday: calendar.thursday,
          friday: calendar.friday,
          saturday: calendar.saturday,
          sunday: calendar.sunday,
          start_date: Date.parse(calendar.start_date),
          end_date: Date.parse(calendar.end_date)
        )
      end

      @source.each_calendar_date do |calendar_date|
        ServiceAddendum.create!(
          service_external_id: calendar_date.service_id,
          date: Date.parse(calendar_date.date),
          exception_type: calendar_date.exception_type
        )
      end
    end
  end

  private

  def load_source
    puts "Loading file"
    @source = GTFS::Source.build("http://www.mbta.com/uploadedfiles/MBTA_GTFS.zip")
  end
end
