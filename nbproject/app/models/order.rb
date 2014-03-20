class Order < ActiveRecord::Base
  has_many :line_items, :dependent => :destroy

PAYMENT_TYPES = [ "Check"," Credit card", "Purchase order"]
validates :name, :address, :email, :pay_type, :presence => true
validates :pay_type, :inclusion => PAYMENT_TYPES

def prepare_invoice_from_cart(cart)
	note = ""
    cart.line_items.each do |item|
	@product_id = item.product_id
	@product = Product.find(@product_id)
	@title = @product.title
	@price = @product.price
	@total_price = @price * item.quantity
	note = note + "#{@title} #{@total_price}"
      end
 end

  def add_line_items_from_cart(cart)
	note = ""
    cart.line_items.each do |item|
	@product_id = item.product_id
	@product = Product.find(@product_id)
	@title = @product.title
	@price = @product.price
	@total_price = @price * item.quantity
	note = note + "#{@title} #{@total_price}"
      item.cart_id = nil
      line_items << item
      end
 end
end
