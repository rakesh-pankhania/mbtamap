# frozen_string_literal: true

FactoryBot.define do
  factory :agency do
    external_id { 'mbta' }
    name { 'MBTA' }
    url { 'http://www.mbta.com' }
    timezone { 'America/New_York' }
    language { 'EN' }
    phone { '617-222-3200' }
  end

  factory :route do
    agency_external_id { 'some-agency' }
    external_id { 'some-line' }
    short_name { 'someline' }
    long_name { 'Some Line' }
    description { 'It goes somewhere' }
    route_type { 1 }
    url { 'asdf' }
    color { 'asdf' }
    text_color { 'asdf' }
    slug { 'asdf' }
  end
end
