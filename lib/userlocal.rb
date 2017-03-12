require 'net/https'
require 'uri'
require 'json'

module UserLocal

  def aiReply(msg)
    key = ENV['USERLOCAL_API_KEY']
    params = URI.encode_www_form ({
      key: key,
      message: msg
    })
    uri = URI.parse("https://chatbot-api.userlocal.jp/api/chat?#{params}")

    begin
      response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
        http.open_timeout = 5
        http.read_timeout = 10
        http.get(uri.request_uri)
      end

      case response
      when Net::HTTPSuccess
        data = JSON.parse(response.body)
        if data['status'] == 'success'
          data['result']
        else
          'ぶぼ？'
        end
      else
        "#{response.code}: #{response.message}"
      end

    rescue => e
      e.message
    end
  end

end
