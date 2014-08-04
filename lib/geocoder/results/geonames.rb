require 'geocoder/results/base'

module Geocoder::Result
  class Geonames < Base

    def coordinates
      [@data['lat'].to_f, @data['lng'].to_f]
    end

    def city
      @data['name'] || "" # geonames does not return the city for reverse geocoding
    end

    def state
      @data['adminName1']
    end

    def state_code
      @data['adminCode1']
    end

    def postal_code
      "" # geonames.org has a separate method to get postal codes
    end

    def country
      @data['countryName']
    end

    def country_code
      @data['countryCode']
    end

    def address
      "" # check geonames.org documentation
    end

  end
end
