# frozen_string_literal: true

class Mbta::Client
  BASE_URL = 'api-v3.mbta.com'

  def get_vehicles(route:, direction:)
    get(
      '/vehicles',
      params: {
        'filter[route]': route,
        'filter[direction_id]': direction
      }
    )
  end

  private

  def get(path, params:)
    JSON.parse(
      Net::HTTP.get(
        URI::HTTPS.build(
          host: BASE_URL,
          path: path,
          query: params.to_query
        )
      )
    )['data']
  end
end
