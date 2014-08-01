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
        lat,lon = query.coordinates
        params[:lat] = lat
        params[:lon] = lon
      else
        params[:q] = query.sanitized_text
      end
      params
    end

    ##
    # Geocoder::Result object or nil on timeout or other error.
    #
    def results(query)
      return [] unless doc = fetch_data(query)
      doc['geonames']
    end


  end
end
