 def test
 require "net/https"
   require "uri"

   uri = URI.parse("http://localhost:3000/invoices")

   http = Net::HTTP.new(uri.host, uri.port)
   # http.use_ssl = (uri.scheme == "https")
   # http.verify_mode = OpenSSL::SSL::VERIFY_NONE if http.use_ssl

   request = Net::HTTP::Post.new(uri.request_uri)

   request.set_form_data({
       "invoice[verification_hash]" => 1,
       "invoice[reference]" => 2,
       "invoice[merchant_reference]" => 3,
       "invoice[merchant_memo]" => 4,
       "invoice[amount]" => 5,
       "invoice[public_url]" => 6
     }
   )

   http.request(request) rescue nil
   end