class LocalizeOrdersPaymentType < ActiveRecord::Migration

 def self.up
    say_with_time "Updating payment type..." do
      Order.all.each do |order|
        new_type = case order.pay_type
                     when "Credit Card" then
                       "cc" 
                     when "Check" then
                       "check" 
                     when "Purchase Order" then
                       "po" 
                   end
        order.update_attribute :pay_type, new_type
      end
    end
  end

 def self.down
    say_with_time "Updating payment type..." do
      Order.all.each do |order|
        new_type = case order.pay_type
                     when "cc" then
                       "Credit Card" 
                     when "check" then
                       "Check" 
                     when "po" then
                       "Purchase Order" 
                   end
        order.update_attribute :pay_type, new_type
      end
    end
  end
end
