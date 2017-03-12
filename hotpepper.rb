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

    begin
      response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
        # http.open_timeout = 5
        # http.read_timeout = 10
        http.get(uri.request_uri)
      end

      case response
      when Net::HTTPSuccess
        data = JSON.parse(response.body)
        idx = rand(30)
        <<-"EOS"
        お店を見つけてきたぶぼ
        #{data.dig("results", "shop", idx, "urls", "pc")}
        EOS
      else
        "#{response.code}: #{response.message}"
      end

    rescue => e
      e.message
    end
  end

end
