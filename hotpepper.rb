require 'net/https'
require 'uri'
require 'json'

module Hotpepper

  def getShop (keyword)
    key = ENV['HOTPEPPER_API_KEY']
    params = URI.encode_www_form ({
      key: key,
      keyword: keyword,
      order: 4,
      count: 30,
      format: 'json'
    })
    uri = URI.parse("https://webservice.recruit.co.jp/hotpepper/gourmet/v1/?#{params}")
    p uri

    begin
      response = Net::HTTP.start(uri.host, uri.port) do |http|
        # http.open_timeout = 5
        # http.read_timeout = 10
        http.get(uri.request_uri)
      end

      case response
      when Net::HTTPSuccess
        data = JSON.parse(response.body)
        idx = rand(30)
        <<~"EOS"
        お店を見つけてきたぶぼ
        #{data.results.shop[idx].urls.pc}
        EOS
      else
        p "#{response.code}: #{response.message}"
      end

    rescue => e
      p e.message
    end
  end

end
