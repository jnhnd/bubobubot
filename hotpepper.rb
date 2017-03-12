require 'net/http'
require 'uri'
require 'json'
require 'logger'

module Hotpepper

  def getShop (keyword)
    params = URI.encoding_www_form({
      key: "#{ENV["HOTPEPPER_API_KEY"]}",
      keyword: "#{keyword}",
      order: 4,
      count: 30,
      format: 'json'
    })
    uri = URI.parse("https://webservice.recruit.co.jp/hotpepper/gourmet/v1/?#{params}")

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
        return <<~"EOS"
        お店を見つけてきたぶぼ
        #{data.results.shop[idx].urls.pc}
        EOS
      else
        logger.error("#{response.code}: #{response.message}")
      end

    rescue => e
      logger.error(e.message)
    end
  end

end
