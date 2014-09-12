class Cart < ActiveRecord::Base
  has_many :line_items, :dependent => :destroy


def total_items
  line_items.sum(:quantity)
end

def add_product(product_id)
  current_item = line_items.find_by_product_id(product_id)
  if current_item
    current_item.quantity += 1
  else
    current_item = line_items.build(:product_id => product_id)
    current_item.price = current_item.product.price
  end
  current_item
end

def total_price
  # line_items.to_a.sum { |item| item.total_price }
  s = 0
  @rate = Rate.last
  line_items.each do |item|
    if item.product.currency == "BTC"
      s += item.total_price
    else
      s += (item.total_price/@rate.valeur)
    end
    
  end
  s
  
end


end
