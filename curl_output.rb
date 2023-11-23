require 'net/http'
require 'ostruct'

def curl_output(url)
  uri = URI(url)
  response = Net::HTTP.get_response(uri)
  if response.is_a?(Net::HTTPSuccess)
    OpenStruct.new(stdout: response.body)
  else
    raise "Failed to fetch URL: #{url}"
  end
end
