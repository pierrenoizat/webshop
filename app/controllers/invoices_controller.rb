class InvoicesController < ApplicationController
skip_before_filter :authorize, :only => [:new, :create, :show, :cancel_confirmed, :confirm_payment, :download, :cancel_order, :notification]
  # GET /invoices
  # GET /invoices.xml
  def index
    @invoices = Invoice.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @invoices }
    end
  end
  

  # GET /invoices/1
  # GET /invoices/1.xml
 def show
	
	if notice == t('.thanks') or notice == t('.payment_not_received') # show only if immediately after placing a new order or after failing to confirm payment
    @invoice = Invoice.find(params[:id]) # find_by id instead of simply find to get nil and avoid record not found exception if id's no good
	else
	@invoice = nil
	end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @invoice }
	    end
  end
  
  
  def download 
    @invoice = Invoice.find(params[:id])
    invoice_id = @invoice.id.to_s
    send_file "#{::Rails.root.to_s}/tmp/#{@invoice.btc_address}.pdf", :type=>"application/pdf"
  end

  # GET /invoices/new
  # GET /invoices/new.xml
  def new
    @invoice = Invoice.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @invoice }
    end
  end

  # GET /invoices/1/edit
  def edit
    @invoice = Invoice.find(params[:id])
  end

  # POST /invoices
  # POST /invoices.xml
  def create
    @invoice = Invoice.new(params[:invoice])

    respond_to do |format|
      if @invoice.save
        format.html { redirect_to(@invoice, :notice => 'Invoice was successfully created.') }
        format.xml  { render :xml => @invoice, :status => :created, :location => @invoice }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @invoice.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /invoices/1
  # PUT /invoices/1.xml
  def update
    @invoice = Invoice.find(params[:id])

    respond_to do |format|
      if @invoice.update_attributes(params[:invoice])
        format.html { redirect_to(@invoice, :notice => 'Invoice was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @invoice.errors, :status => :unprocessable_entity }
      end
    end
  end
  
    # POST /invoices
  def notification
    require 'json'
    require "net/http"
        	require "uri"

        	data = response.body

           # we convert the returned JSON data to native Ruby
           # data structure - a hash
           # result = JSON.parse(data)

           # @amount= result['signed_data']['amount']
           # @amount = parsed_body[0][0]["amount"] # amount in satoshis
    
   parsed_body = data && data.length >= 2 ? JSON.parse(data) : nil
    
  @rate = get_rate
  @rate = @rate.to_f
  @rate = $MARGIN_RATE * @rate
  
# @amount = parsed_body[0][0]["amount"] # amount in satoshis
# @bamount_btc = parsed_body["amount_btc"] # amount in bitcoins
# @userdata = parsed_body["userdata"] # reserved for future use by bitcoinmonitor.net
# @confirmations = parsed_body["confirmations"]
@address = parsed_body[0][4]["address"]
# @created = parsed_body["created"]
# @txhash = parsed_body["txhash"]
# @agent = parsed_body["agent"]
# @sig = parsed_body[1]["signature"]

# signature string = address + agent + amount + amount_btc + confirmations + created + userdata + txhash + security token

@mysig = Digest::MD5.hexdigest("#{@address}#{@agent}#{@amount}#{@amount_btc}#{@confirmations}#{@created}#{@userdata}#{@txhash}78f2f33ba8222a4cecf5c61776d0ac123677d323")

#if @mysig = @sig
	# notification's signature is authentic: process notification !
	# @array_of_invoices = Invoice.find_all_by_btc_address(@address).collect(&:order_id)
	if @address
   @invoice = Invoice.find_by_btc_address(@address)

   @invoice.amount_paid = @invoice.amount_paid + @amount_btc.to_f
   
   @shipping = shipping_cost(@invoice.country)
   @shipping = (@shipping.to_f)/@rate
	 @shipping_cost = @shipping.to_f
   
   @total_due = @shipping_cost + @invoice.montant.to_f
   
   @invoice.status = case ( @total_due <=> @invoice.amount_paid.to_f )
		when 0 then "paid"
		when -1 then "excess"
		when 1 then "partial"
		end	
		
	case @invoice.status
	when "paid"
	Bitpayment.payment_received(@invoice).deliver
	@order = get_order_from_invoice(@invoice)
	@invoice.update_attributes(:status => "paid")
	when "excess"
	Bitpayment.excess_payment(@invoice).deliver
	@order = get_order_from_invoice(@invoice)
	@invoice.update_attributes(:status => "excess")
	when "partial"
	Bitpayment.partial_payment(@invoice).deliver
	@invoice.update_attributes(:status => "partial")
	end
end # if @address
#else
#	@invoice = Invoice.first
Bitpayment.fake_notification(@invoice).deliver
#	end # if
	
	render :nothing => true
	
  end


  # DELETE /invoices/1
  # DELETE /invoices/1.xml
  def destroy
    @invoice = Invoice.find(params[:id])
    @invoice.destroy

    respond_to do |format|
      format.html { redirect_to(invoices_url) }
      format.xml  { head :ok }
      end
  end
  
  def cancel_confirmed
    @invoice = Invoice.find(params[:id])
    if @invoice.amount_paid == 0
    @invoice.destroy
    notice = t('.order_canceled')
    else
    notice = t('.invoice_not_deleted')
    end
    respond_to do |format|
      format.html { redirect_to(store_path, :notice => notice) }
      end
  end
  
  # POST /invoices/1
  # POST /invoices/1.xml
  def cancel_order
    @invoice = Invoice.find(params[:id])
    respond_to do |format|
      format.html { render(:action => :cancel_order, :notice => 'Your order is canceled. You get to decide what to do next') }
      format.xml  { head :ok }
    end
  end
  
  
  def confirm_payment
    
    @invoice = Invoice.find(params[:id])
    
      if (@invoice and @invoice.amount_paid == 0)
      
        @val = fetch_payments(@invoice.btc_address) # fetch_payments helper method in application controller
    
        temps = Time.now
        offset = 2 # wait 2 seconds !
        i = temps
        while i < temps + offset
          i = Time.now
        end
    
        if @val == 0 or !@val
      
          respond_to do |format|
            format.html { redirect_to invoice_path(@invoice), :notice => t('.payment_not_received') } # 'show' in depot/app/views/invoices/show.html.erb
          end
      
        else
          @amnt = @invoice.amount_paid
          @amnt =  @amnt + @val
          @invoice.amount_paid = @amnt # line was missing in code
          @total_due = @invoice.qrcode_string.split("=")[1].to_f

          @invoice.status = case ( @total_due <=> @invoice.amount_paid.to_f )
  	      when 0 then "paid"
  		    when -1 then "excess"
  		    when 1 then "partial"
  		    end	

  	      case @invoice.status
  	      when "paid"
  	        Bitpayment.payment_received(@invoice).deliver
  	        @order = get_order_from_invoice(@invoice)
  	        @invoice.update_attributes(:status => "paid",:amount_paid => @amnt)
  	      when "excess"
  	        Bitpayment.excess_payment(@invoice).deliver
  	        @order = get_order_from_invoice(@invoice)
  	        @invoice.update_attributes(:status => "excess",:amount_paid => @amnt)
  	      when "partial"
  	        Bitpayment.partial_payment(@invoice).deliver
  	        @invoice.update_attributes(:status => "partial",:amount_paid => @amnt)
  	      end

          @val= @val.to_s
          redirect_to(store_path, :notice => "#{t('.payment_received')}#{@val} BTC - #{t('.email_sent')}")

        end # else
    
      else # NOT immediately after placing an order and NOT after failing to confirm
        redirect_to(store_path)
      end # else
    
  end # end of confirm_payment method
  
  
end
