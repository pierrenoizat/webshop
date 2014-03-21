class Notifier < ActionMailer::Base
  default :from => 'bitcoin-france.org'

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifier.order_received.subject
  #
  def order_received(order)
    @order = order
    @rate_last = Rate.last
    @rate = @rate_last.valeur * $MARGIN_RATE
    @rate=@rate.to_f
    
    union = ["Albania", "Andorra","Austria", "Belgium", "Bosnia and Herzegowina", 
          "Bulgaria", "Croatia", "Cyprus", "Czech Republic", "Denmark",
          "Estonia", "Finland", "France","Germany", "Gibraltar", "Greece", "Guernsey",
          "Holy See (Vatican City State)", "Hungary", "Iceland", "Ireland", "Isle of Man", "Italy", "Jersey",
          "Latvia","Liechtenstein", "Lithuania", "Luxembourg","Monaco", "Montenegro", "Netherlands",
          "Poland", "Portugal", "Romania", "San Marino", "Serbia", "Slovakia", "Slovenia",
          "Spain", "Sweden", "Switzerland", "United Kingdom"]
  	
  	if union.include?(@order.country)
  		@shipping = 0
  		else
  		@shipping = 0
  		end
  	if @order.country == "France"
  	@shipping = 0
  	end
  	@shipping = (@shipping.to_f)/@rate # shipping in BTC
	
	@SHIPPING = @shipping.to_f
	@order.total = @order.total + @SHIPPING
	@order.conv_total = @order.total * $CONV_RATE * $MARGIN_RATE

    mail :to => order.email, :from => "Association Bitcoin France", :bcc => "noizat@hotmail.com", :subject => 'Bitcoin France Confirmation'
  end

  #
  def order_shipped(order)
    @order = order

    mail :to => order.email, :from => "Association Bitcoin France",:bcc => "noizat@hotmail.com", :subject => 'Bitcoin France Confirmation'
  end
  
  
  def form_received(contact_form)
    @contact_form = contact_form
    mail :to => "noizat@hotmail.com", :from => "bitcoin-france.org", :subject => 'Bitcoin France Contact Form'
  end
  
end
