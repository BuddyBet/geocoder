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
      "#{protocol}://api.geonames.org/#{lookup_method(query)}JSON?#{url_query_string(query)}"
    end

    private # ---------------------------------------------------------------

    def lookup_method(query)
      query.reverse_geocode? ? "countrySubdivision" : ""
    end

    def query_url_params(query)
      params = {
        username: configuration.username || "demo"
      }.merge(super)
      if query.reverse_geocode?
        lat,lon = query.coordinates
        params[:lat] = lat
        params[:lon] = lon
      else
        params[:q] = query.sanitized_text
      end
      params
    end

  end
end
