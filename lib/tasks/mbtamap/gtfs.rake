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
    Rake::Task["gtfs:load_services"].invoke
    Rake::Task["gtfs:load_trips"].invoke
    Rake::Task["gtfs:load_stops"].invoke
    Rake::Task["gtfs:load_stop_times"].invoke
    Rake::Task["gtfs:load_shapes"].invoke

    puts "=== Finished ==="
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

      service = nil
      @source.each_calendar_date do |calendar_date|
        service = Service.find_by!(external_id: calendar_date.service_id) if service.nil? || service.external_id != calendar_date.service_id.to_s
        service.service_addendums.create!(
          date: Date.parse(calendar_date.date),
          exception_type: calendar_date.exception_type
        )
      end
    end
  end

  task load_trips: :environment do
    @source ||= load_source
    puts "Loading trips"

    services = Hash[ Service.all.map { |s| [s.external_id, s] } ]

    Trip.transaction do
      route = nil
      @source.each_trip do |trip|
        route = Route.find_by!(external_id: trip.route_id) if route.nil? || route.external_id != trip.route_id.to_s
        route.trips.create!(
          external_id: trip.id,
          service: services[trip.service_id],
          headsign: trip.headsign,
          short_name: trip.short_name,
          direction: trip.direction_id,
          block_id: trip.block_id,
          wheelchair_accessible: trip.wheelchair_accessible
        )
      end
    end
  end

  task load_stops: :environment do
    @source ||= load_source
    puts "Loading stops"

    Stop.transaction do
      @source.each_stop do |stop|        
        Stop.create!(
          external_id: stop.id,
          code: stop.code,
          name: stop.name,
          description: stop.desc,
          lattitude: stop.lat,
          longitute: stop.lon,
          url: stop.url,
          location_type: stop.location_type,
          wheelchair_boarding: stop.wheelchair_boarding
        )
      end
      @source.each_stop do |stop|
        next if stop.parent_station.to_s == ""
        parent_station = Stop.find_by!(external_id: stop.parent_station)
        Stop.find_by!(external_id: stop.id).update!(parent_station: parent_station)
      end
    end
  end

  task load_stop_times: :environment do
    @source ||= load_source
    puts "Loading stop times"

    StopTime.transaction do
      trip = nil
      @source.each_stop_time do |stop_time|
        trip = Trip.find_by!(external_id: stop_time.trip_id) if trip.nil? || trip.external_id != stop_time.trip_id.to_ssdf
        arrival_time = stop_time.arrival_time.to_s.split(":")
        departure_time = stop_time.departure_time.to_s.split(":")
        trip.stop_times.create!(
          arrival_minutes_past_midnight: (arrival_time[0].to_i * 60 + arrival_time[1].to_i),
          departure_minutes_past_midnight: (departure_time[0].to_i * 60 + departure_time[1].to_i),
          stop_sequence: stop_time.stop_sequence,
          stop_headsign: stop_time.stop_headsign,
          pickup_type: stop_time.pickup_type,
          drop_off_type: stop_time.drop_off_type
        )
      end
    end
  end

  task load_shapes: :environment do
    @source ||= load_source
    puts "Loading shapes"

    Shape.transaction do
      curr_shape = nil
      @source.each_shape do |shape|
        if curr_shape.nil? || curr_shape.external_id != shape.id
          curr_shape = Shape.create!(external_id: shape.id)
        end
        curr_shape.points.create!(
          lattitude: shape.pt_lat,
          longitude: shape.pt_lon,
          sequence: shape.pt_sequence,
          dist_traveled: shape.dist_traveled
        )
      end
    end
  end

  def load_source
    puts "Loading file"
    @source = GTFS::Source.build("http://www.mbta.com/uploadedfiles/MBTA_GTFS.zip")
  end
end
