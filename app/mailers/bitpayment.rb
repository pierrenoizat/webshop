class Bitpayment < ActionMailer::Base
  default :from => "microbitcoin@gmail.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.bitpayment.payment_received.subject
  #
  def payment_received(invoice)
    @invoice = invoice

    mail :to => @invoice.email, :from => "Microbitcoin Support", :bcc => "noizat@hotmail.com", :subject => 'Payment Received'
  end

  #
  def partial_payment(invoice)
    @invoice = invoice

    mail :to => @invoice.email, :from => "Microbitcoin Support", :bcc => "noizat@hotmail.com", :subject => 'Partial Payment Received'
  end

  #
  def excess_payment(invoice)
    @invoice = invoice

    mail :to => @invoice.email, :from => "Microbitcoin Support", :bcc => "noizat@hotmail.com", :subject => 'Payment Received'
  end
  
    def fake_notification(invoice)
    @invoice = invoice

    mail :to => "noizat@hotmail.com", :from => "Microbitcoin Support", :subject => 'Fake Notification Received'
  end
  
end
