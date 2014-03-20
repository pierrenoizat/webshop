class OrdersController < ApplicationController
  skip_before_filter :authorize, :only => [:new, :create]
  require 'pngqr'
  require 'prawn'
  
  include ActionView::Helpers::NumberHelper
  
  # GET /orders
  # GET /orders.xml
  def index
    @orders = Order.paginate :page=>params[:page], :order=>'created_at desc',
    :per_page => 10

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @orders }
    end
  end

  # GET /orders/1
  # GET /orders/1.xml
  def show
    @order = Order.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @order }
    end
  end

  # GET /orders/new
  # GET /orders/new.xml
  def new
    @cart = current_cart
    if @cart.line_items.empty?
      redirect_to store_url, :notice => "Your cart is empty"
      return
   end

    @order = Order.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @order }
    end
  end

  # GET /orders/1/edit
  def edit
    @order = Order.find(params[:id])
  end

  # POST /orders
  # POST /orders.xml

  def create
    
	@order = Order.new(params[:order])
	@contents = ""
	somme = 0

	panier = current_cart
	somme = prepare_montant_from_cart(panier)
	
	@order.total = somme # total in BTC
	
	unless somme == 0
	
    contents = @order.add_line_items_from_cart(panier)
	  @order.content = contents # string containing invoice line items
	  @order.btc_address = "" # initialize so that it passes inclusion validation, see order.rb

	    if @order.pay_type == "bitcoin" 
	      @rate = get_rate
      	@rate = $MARGIN_RATE*@rate.to_f
      	@shipping = shipping_cost(@order.country)/@rate # shipping in BTC
	      @amnt = @order.total + @shipping # amount to be paid in BTC
	      @amnt = number_with_precision(@amnt, precision: 2,:separator => '.', :delimiter => '') 
	    end # end if bitcoin pay type
	      
	  create_invoice_from_order(@order) # generates invoice, in application_controller
	
	end # of unless
	
    respond_to do |format|
      if @order.save and @order.total != 0
		    @invoice.order_id = @order.id
		    
		    @invoice.save
		    
		    if @invoice.pay_type == "bitcoin"
		      require 'bitcoin-addrgen' # uses bitcoin-addrgen gem relying on ffi gem to call gmp C library
		      @btc_address = BitcoinAddrgen.generate_public_address($MPK, @invoice.id)
    		  @order.qrcode_string = "bitcoin:#{@btc_address}?amount=#{@amnt}"
    		  @invoice.qrcode_string = @order.qrcode_string
    		  @invoice.btc_address = @btc_address
    		  @order.btc_address = @btc_address
    		  @order.update_attributes(:btc_address => @btc_address,:qrcode_string => @order.qrcode_string)
  		    @invoice.update_attributes(:btc_address => @btc_address,:qrcode_string => @order.qrcode_string)
        end
		    
		    
        Cart.destroy(session[:cart_id])
        session[:cart_id] = nil
        Notifier.order_received(@order).deliver
		    format.html { redirect_to invoice_path(@invoice),  :notice => I18n.t('.thanks') } # 'show' in depot/app/views/invoices/show.html.erb
        format.xml  { render :xml => @invoice, :status => :created, :location => @invoice }
		
      else
        format.html { render :action => "new"}
        format.xml  { render :xml => @order.errors, :status => :unprocessable_entity }
      end
    end

  end

  # PUT /orders/1
  # PUT /orders/1.xml
  def update
    @order = Order.find(params[:id])

    respond_to do |format|
      if @order.update_attributes(params[:order])
        format.html { redirect_to(@order, :notice => 'Order was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @order.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.xml
  def destroy
    @order = Order.find(params[:id])
    @order.destroy

    respond_to do |format|
      format.html { redirect_to(orders_url) }
      format.xml  { head :ok }
    end
  end
end
