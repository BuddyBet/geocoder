require 'geocoder/lookups/base'
require "geocoder/results/geonames"

module Geocoder::Lookup

  class Geonames < Base
    ##
    # Human-readable name of the geocoding API.
    #
    def name
      "Geonames"
    end

    ##
    # URL to use for querying the geocoding engine.
    #
    def query_url(query)
      "#{protocol}://api.geonames.org/#{lookup_method(query)}?#{url_query_string(query)}"
    end

    private # ---------------------------------------------------------------

    def lookup_method(query)
      query.reverse_geocode? ? "countrySubdivisionJSON" : "searchJSON"
    end

    def query_url_params(query)
      params = {
        username: Geocoder.config[:username] || 'demo'
      }.merge(super)
      if query.reverse_geocode?
        lat,lng = query.coordinates
        params[:lat] = lat
        params[:lng] = lng
      else
        params[:q] = query.sanitized_text
      end
      params
    end

    ##
    # Geocoder::Result object or nil on timeout or other error.
    #
    def results(query)
      if !query.blank? && doc = fetch_data(query)
        parse_errors(doc)
        query.reverse_geocode? ? [doc] : doc['geonames']
      else
        []
      end
    end

    def parse_errors(response)
      value = response['status']['value'] rescue 0
      case value
      when 18, 19, 20
        raise_error(Geocoder::OverQueryLimitError, "over query limit.") ||
          warn("Geonames Geocoding API error: over query limit.")
      when 10
        raise_error(Geocoder::RequestDenied, "request denied.") ||
          warn("Geonames Geocoding API error: request denied.")
      when 11..17, 21..23
        raise_error(Geocoder::Error, "generic error.") ||
          warn("Geonames Geocoding API error: generic error.")
      end
    end

  end
end
