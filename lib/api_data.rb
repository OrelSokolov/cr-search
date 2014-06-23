require 'json'
require 'uri'
require 'net/http'

module APIData
  API_VERSION = 1
  API_URL = "http://api.crossref.org/v#{API_VERSION}"

  def funder_hash(id)
    url = "#{API_URL}/funders/#{id}"
    get_message(url)
  end

  def funder_works_hash(id, params)
    offset = (query_page - 1) * query_rows
    url = "#{API_URL}/funders/#{id}/works?facet=t&rows=#{query_rows}"
    url << "&offset=#{offset}" if offset != 0
    url << "&sort=#{params[:sort]}" if params[:sort]
    get_message(url)
  end

  def funder_doi_from_funder funder
    [funder['uri']] + funder['descendants'].map do |id|
      "http://dx.doi.org/10.13039/#{id}"
    end
  end

  private
    def get_message(url)
      uri = URI.parse(url)
      response = Net::HTTP.get_response(uri)
      JSON(response.body)['message']
    end
end
