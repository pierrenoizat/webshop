module OrdersHelper

	def cancel
	@order = Order.find(params[:id])
    @order.destroy

    respond_to do |format|
      format.html { redirect_to(store_url) }
      format.xml  { head :ok }
    end
	end
end
