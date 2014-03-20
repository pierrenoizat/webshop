module ApplicationHelper
  def hidden_div_if(condition, attributes = {}, &block)
    if condition
      attributes["style"] = "display.none"
    end
    content_tag("div", attributes, &block)
  end
  
  
  def conv_rate
	
	rate = Rate.last
	if time_condition
	rate = Rate.create
	rate.valeur = get_rate
	rate.save
	end
	rate.valeur
	end
	
	def get_rate
	require "net/http"
	require "uri"

	uri = URI.parse("http://bitcoincharts.com/t/weighted_prices.json")

	http = Net::HTTP.new(uri.host, uri.port)
	request = Net::HTTP::Get.new(uri.request_uri)

	response = http.request(request)

	response.code             # => 301
	response.body             # => The body (HTML, XML, blob, whatever)

	data = response.body

   # we convert the returned JSON data to native Ruby
   # data structure - a hash
   result = JSON.parse(data)

   # if the hash has 'Error' as a key, we raise an error
   if result.has_key? 'Error'
      raise "web service error"
	
   else
	euro_rate_hash = result['EUR']
	euro_rate_hash['24h']
	
	end 
	end # end get_rate method
	
	def time_condition
	temps = Time.now
	offset = 960
	condition = :false
	rate = Rate.last
	condition = (rate.created_at? and rate.created_at < temps - offset) and (rate.updated_at? and rate.updated_at < temps -offset)
	end

end
