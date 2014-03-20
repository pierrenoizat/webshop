require 'test_helper'

class BitpaymentTest < ActionMailer::TestCase
  test "payment_received" do
    mail = Bitpayment.payment_received
    assert_equal "Payment received", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "partial_payment" do
    mail = Bitpayment.partial_payment
    assert_equal "Partial payment", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "excess_payment" do
    mail = Bitpayment.excess_payment
    assert_equal "Excess payment", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
