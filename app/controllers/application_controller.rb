class ApplicationController < ActionController::Base
  # before_filter :set_i18n_locale_from_params
  before_filter :set_locale
  before_filter :authorize
  before_filter :prepare_time_for_display

  protect_from_forgery
  
  helper_method :get_rate, :shipping_cost, :fetch_payments
  
  def get_rate
  	require "net/http"
  	require "uri"
    begin
  	uri = URI.parse($EXCHANGE_RATE_URL) # find global variable settings in application.rb

  	http = Net::HTTP.new(uri.host, uri.port)
  	request = Net::HTTP::Get.new(uri.request_uri)
  	response = http.request(request)

  	data = response.body

     # we convert the returned JSON data to native Ruby
     # data structure - a hash
     result = JSON.parse(data)

  	euro_rate_hash = result['bpi'] # Coindesk API
  	euro_rate_sub_hash = euro_rate_hash['EUR'] # Coindesk API
  	# euro_rate_hash = result['EUR'] # bitcoincharts API
  	# euro_rate = euro_rate_hash['24h'] # Bitcoincharts API
  	euro_rate = euro_rate_sub_hash['rate_float'] # Coindesk BPI
  	$CONV_RATE=euro_rate
  rescue
      return $DEFAULT_RATE
      
    end

  	end # end get_rate method
  	
  	
  	def shipping_cost(country)
  	  
  	  union = $EUROPE
    	if union.include?(country)
    		shipping_cost = 0  # shipping cost in EUR for the EU outside of France
    		else shipping_cost = 0 # shipping cost in EUR outside the EU
    		end
    	if country == "France"
    	shipping_cost = 0		
    	end
    	shipping_cost = shipping_cost.to_f # returns shipping_cost in EUR as float
  	  
	  end # end shipping_cost method
	  
	  
	  def fetch_payments(address)
	    
	    require "net/http"
    	require "uri"
      begin # first iterate over unconfirmed txs then check address balance
        
      @value = 0 # initialize 
    	uri = URI.parse($UNCONFIRMED_TX_URL) # find global variable settings in application.rb

    	http = Net::HTTP.new(uri.host, uri.port)
    	request = Net::HTTP::Get.new(uri.request_uri)
    	response = http.request(request)

    	data = response.body

       # we convert the returned JSON data to native Ruby
       # data structure - a hash
       result = JSON.parse(data)
       
	    
	    unconfirmed_transaction_array = result['txs']
      @tx_count = unconfirmed_transaction_array.size - 1
      0.upto(@tx_count) { |i| 
        begin
          if unconfirmed_transaction_array[i]
            if unconfirmed_transaction_array[i]["out"]
              @addr_count = unconfirmed_transaction_array[i]["out"].size
              j = 0
              while j <= @addr_count do
                if unconfirmed_transaction_array[i]["out"][j]
                  if (unconfirmed_transaction_array[i]["out"][j]["addr"] == address)
                    @value = unconfirmed_transaction_array[i]["out"][j]["value"] # could be nil if json source is corrupted, needs testing
                  end
                end
              j += 1
              end # end while
            end
          end
        end }
          
	    @value = (@value.to_f/100000000).to_f # value of payment converted in BTC
	    
	    if @value == 0 # if no unconfirmed tx matches the address
	      url = $RAWADDRESS_URL + address # find global variable settings in application.rb
	      uri = URI.parse(url)
	      http = Net::HTTP.new(uri.host, uri.port)
      	request = Net::HTTP::Get.new(uri.request_uri)
      	response = http.request(request)

      	data = response.body

         # we convert the returned JSON data to native Ruby
         # data structure - a hash
         result = JSON.parse(data)
         if !(result.empty?) and result
           @value = result['final_balance'] # could generate type error if json source corrupt, needs testing
	         if @value 
	           @value = (@value.to_f/100000000).to_f # value of payment converted in BTC
           else
             @value = 0
           end
        end
      end # if
  
	  @value
    end # begin
	    
    end # end of fetch_payments method
    

  def prepare_time_for_display
  @current_time = Time.now
  end
  
  private

  def current_cart
    Cart.find(session[:cart_id])
  rescue ActiveRecord::RecordNotFound
    cart = Cart.create
    session[:cart_id] = cart.id
    cart
  end
  
  def prepare_montant_from_cart(cart)
	  @cart = cart
	  somme = 0
    @cart.line_items.each do |item|
	    @product_id = item.product_id
	    @product = Product.find(@product_id)
	    @price = @product.price
	    @total_price = @price * item.quantity
	    if @product.currency == "BTC"
	      somme = somme + @total_price  # en BTC
      else
        @rate= Rate.last
        somme = somme + @total_price/@rate.valeur
      end
      
    end
	  somme
 end
  
  
   def create_invoice_from_order(order)
   
	@order = order
	@invoice = Invoice.create
		
		@invoice.contenu = @order.content
		
		@invoice.montant = @order.total
		@invoice.amount_paid = 0
		@invoice.name = @order.name
		@invoice.email = @order.email
		@invoice.adresse = @order.address
		@invoice.country = @order.country
		@invoice.city = @order.city
		@invoice.zip_code = @order.zip_code
		@invoice.pay_type = @order.pay_type
		@invoice.status = "pending"
		
  end
	
	
	
	   def get_order_from_invoice(invoice)
   
	@invoice = invoice
	
	unless @invoice.nil?
	@order = Order.find_by_id(@invoice.order_id)
	end
		
    end
    
  
  protected
  
  def set_locale
    if params[:l] && I18n.available_locales.include?(params[:l].to_sym)
      I18n.locale = params[:l]
      session[:locale] = params[:l]
    elsif session[:locale]
      I18n.locale = session[:locale].to_sym
    else
      session[:locale] = I18n.default_locale
    end
  end

  def set_i18n_locale_from_params
    if params[:locale]
      if I18n.available_locales.include?(params[:locale].to_sym)
        I18n.locale = params[:locale]
        else
        flash.now[:notice] =
          "#{params[:locale]} translation not available"
        logger.error flash.now[:notice]
        end
      end
    end

  def default_url_options
    { :locale => I18n.locale }
    end

  def authorize
    unless User.find_by_id(session[:user_id])
      redirect_to login_url, :notice => "Please log in "
    end
  end

end
