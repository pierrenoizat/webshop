module InvoicesHelper

require 'prawn/qrcode'

 def display_invoice_lines
	@H = Hash.new("0") # hash to receive details for display of each line

	@invoice = Invoice.find(params[:id])
	@contenu = @invoice.contenu # string with invoice line items serialized
	
	unless @contenu.nil?
	@COMPTE = count_lines_from_string(@contenu)
	
	# contenu = contenu + "Product_id: #{@product_id}," + "Quant: #{item.quantity}," + " | "
	
	# parse @string with iterations using the count local variable enumerating products
	
	@prod = @contenu
	j = 1
	
	while j <= @COMPTE
	
	@contenu = @prod
	
	@prod = show_pre_regexp(@contenu, /,Quant:/)
	@prod_id = show_post_regexp(@prod, /Product_id:\s/)
	@prod_ref = @prod_id.to_i

	@prod = show_pre_regexp(@contenu, /\|/)
	@quant = show_post_regexp(@prod, /Quant:\s/)
	@q = @quant.to_i
	
	@product = Product.find_by_id(@prod_ref)
	@title = @product.title
	
	p = @product.price
	
	oprice = @q * p
	
	prod_ref_s = @prod_ref.to_s
	q_s = @q.to_s
	p_s = p.to_s
	oprice_s = oprice.to_s
	
	@H[j - 1] = [prod_ref_s, q_s, @title, p_s, oprice_s]
	
	@prod = show_post_regexp(@contenu, /\|\s/)
	j += 1
	end
	end
	@H # return hash for invoice 'show'
	
	end

 
 def show_pre_regexp(string,symbol_pattern)
	match = symbol_pattern.match(string)
	if match
	"#{match.pre_match}"
	else
	"no match"
	end
	end
	
 def show_post_regexp(string,symbol_pattern)
	match = symbol_pattern.match(string)
	if match
	"#{match.post_match}"
	else
	"no match"
	end
	end
	
 def count_lines_from_string(string)
	if string.nil?
	return 0
	else
	string.scan(/Product_id:/).length # returns number of occurence of Product_id: in string
	end
 end
	
	
	def generate_pdf_invoice(hache, compteur)
	  
	  @invoice = Invoice.find(params[:id])
    invoice_id = @invoice.id.to_s
    
    temps = case I18n.locale.to_s
  		when 'en' then @current_time.strftime("%B %d, %Y")
  		when 'fr' then @current_time.strftime("%d %m %Y")
  		else @current_time.strftime("%B %d, %Y")
  		end
  	temps = " #{temps} - " + "#{@current_time.strftime("%H:%M")}"
  	
  	rate = number_to_currency($CONV_RATE * $MARGIN_RATE, :unit => "EUR", :separator => ".", :delimiter => " ", :format => "%n %u")
    
    name = @invoice.name
    total= @invoice.montant
    shipping = shipping_cost(@invoice.country) # helper method in application controller, returns EUR
    shipping = shipping/($CONV_RATE * $MARGIN_RATE)
    grand_total = total + shipping
    total_euro = grand_total * $CONV_RATE * $MARGIN_RATE
    
    title = case I18n.locale.to_s
            when 'en' then "Invoice # "
            when 'fr' then "Facture # "
            else "Invoice # "
            end
    
    if @invoice.pay_type == "check"

      pay_text = case I18n.locale.to_s
     		when 'en' then "Write check to the order of"
     		when 'fr' then "Cheque a l'ordre de"
     		else "Write check to the order of"
     		end
     	 pay_text = pay_text + " Bitcoin France"
      btc_address = ""
      btc_order = false
      
     else

    	pay_text = case I18n.locale.to_s
     		when 'en' then "Send bitcoins to"
     		when 'fr' then "Payer l'adresse bitcoin: "
     		else "Send bitcoins to"
     		end
     		
      btc_address = @invoice.btc_address
      btc_order = true
     end
     
     explanation = case I18n.locale.to_s
    		when 'en' then "Below you can find your order details. We hope you shop with bitcoin-france.org again in the future."
    		when 'fr' then "Details de votre commande: "
    		else "Below you can find your order details. We hope you shop with bitcoin-france.org again in the future."
    		end
    		
     thanks = case I18n.locale.to_s
        		when 'en' then "Thanks for your order,"
        		when 'fr' then "Merci pour votre commande, "
        		else "Thanks for your order,"
        		end
        		
      delivery = case I18n.locale.to_s
              when 'en' then "Address: "
              when 'fr' then "Adresse: "
              else "Address: "
              end
    
    delivery_address = "#{@invoice.adresse} | " + "#{@invoice.city} | " + "#{@invoice.zip_code} | " + "#{@invoice.country} "
    email = @invoice.email
    qrcode_string = "#{@invoice.qrcode_string}"
    
    # generates the pdf file
    Prawn::Document.generate("#{::Rails.root.to_s}/tmp/#{btc_address}.pdf") do

      logopath = "#{::Rails.root.to_s}/public/images/logo_bitcoin_france_print.png" # warning: Prawn does NOT handle interlace png image
      image logopath, :width => 107, :height => 25
      
      move_down 50

      # font "Helvetica"
      font_size 18
      text_box "#{title} #{invoice_id}", :align => :right

      font_size 14
      text  "#{thanks} #{name}.", :align => :center
      move_down 20

      font_size 10
      text "#{temps}", :align => :left
      text "1 BTC = #{rate}", :align => :left
      move_down 20
      font_size 12
      text "#{explanation}", :align => :left
      move_down 20
      
      table_header = [ ["Ref.","Item",
                  "Quant.",
                  "Unit Price ", "Total Item"] ]
        
        table(table_header, 
          :column_widths => [40, 200, 60, 80, 100])
          #:position => :right )
      
      j = 0
      while j < compteur
        
        converted_unit_price_string = ActionController::Base.helpers.number_to_currency(hache[j].at(3), :unit => " BTC", :separator => ".", :delimiter => " ", :format => "%n %u" )
        converted_sub_total_string = ActionController::Base.helpers.number_to_currency(hache[j].at(4), :unit => " BTC", :separator => ".", :delimiter => " ", :format => "%n %u")
        invoiceinfo = [["#{hache[j].at(0)}", "#{hache[j].at(2)}", "#{hache[j].at(1)}", "#{converted_unit_price_string}", "#{converted_sub_total_string}" ]]
        
        table(invoiceinfo, 
              :column_widths => [40, 200, 60, 80, 100], 
              :row_colors => ["d2e3ed", "FFFFFF"],
              #:position => :right,
              :cell_style => { :align => :right })

      j += 1
      end
        move_down 20
        
        converted_net_total_string = ActionController::Base.helpers.number_to_currency(total, :unit => " BTC", :separator => ".", :delimiter => " ", :format => "%n %u")
  
      	converted_shipping_string = ActionController::Base.helpers.number_to_currency(shipping, :unit => " BTC", :separator => ".", :delimiter => " ", :format => "%n %u")

        converted_total_string = ActionController::Base.helpers.number_to_currency(grand_total, :unit => " BTC", :separator => ".", :delimiter => " ", :format => "%n %u")

        table([ ["Sub-Total:","#{converted_net_total_string}" ],
                ["Shipping:", "#{converted_shipping_string}"],
                ["Total :", "#{converted_total_string}"] ], 
                #:position => :right,
                :cell_style => { :align => :right, :font_style => :bold })
                    
        converted_total_euro = ActionController::Base.helpers.number_to_currency(total_euro, :unit => " EUR", :separator => ".", :delimiter => " ", :format => "%n %u")
        move_down 10     
        text "Total(Euro) : #{converted_total_euro}", :align => :right
                    
        move_down 20

        font_size 12
        text pay_text, :align => :center
        move_down 4
        text btc_address, {:align => :center, :font_style => :bold}
        move_down 10
        if btc_order
          print_qr_code(qrcode_string, :align => :center, :extent => 150, :stroke => false)
        end
        
        move_down 30
        font_size 10
        text "#{delivery}"+ delivery_address, :align => :left
        move_down 5
        text "Email: "+ email, :align => :left
        
    end
    
    end
	
end
