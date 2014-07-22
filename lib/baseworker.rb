
require 'net/http'
require 'uri'
require 'json'

# Response to whatsapp contact

class Response
	def send_response(phone_number, content)

	uri = URI.parse("http://localhost:5000/message")

	header = {'Content-Type'=> 'text/json'}
	user =  {                   
                    'msg'=> content,
                    'number'=> phone_number
             }
				http = Net::HTTP.new(uri.host, uri.port)
				request = Net::HTTP::Post.new(uri.request_uri, header)
				request.body = user.to_json
				response = http.request(request)
	end

end
