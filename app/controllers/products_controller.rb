class ProductsController < ApplicationController
skip_before_filter :authorize, :only => [ :cards, :coins, :downloads, :show]
  # GET /products
  # GET /products.xml
  def index
    @products = Product.order("created_at ASC").all 

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @products }
    end
  end
  
  
   def downloads
    
  @products = Product.all
  @cart = current_cart
  end
  
   def cards
  @products = Product.all
  @cart = current_cart
  end
  
  def coins
  @products = Product.all
  @cart = current_cart
  end

  # GET /products/1
  # GET /products/1.xml
  def show
    @product = Product.find(params[:id])
    unless @product.nil?
    @type = @product.title[-3..-1] # product title MUST be the file name with 3-character extension e.g. mp3
    # @type = last three characters of title string
    if @product.first_category == "Downloads" and @product.stock != 0
    send_file "#{::Rails.root.to_s}/public/data/#{@product.title}", :type => "application/#{@type}", :stream => true
    else redirect_to(store_path)
    end
    end
    
    rescue ActiveRecord::RecordNotFound # in case someone tries to enter a product url and product does not exist
      flash[:notice] = "Wrong product !"
      redirect_to(store_path)
  end

  # GET /products/new
  # GET /products/new.xml
  def new
    @product = Product.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @product }
    end
  end

  # GET /products/1/edit
  def edit
    @product = Product.find(params[:id])
  end

  # POST /products
  # POST /products.xml
  def create
    @product = Product.new(params[:product])

    respond_to do |format|
      if @product.save
        format.html { render :action => "edit", :notice => 'Product was successfully created.' }
        format.xml  { render :xml => @product, :status => :created }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @product.errors, :status => :unprocessable_entity, :location => @product }
      end
    end
  end

  # PUT /products/1
  # PUT /products/1.xml
  def update
    @product = Product.find(params[:id])

    respond_to do |format|
      if @product.update_attributes(params[:product])
        format.html { redirect_to(@product, :notice => 'Product was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @product.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.xml
  def destroy
    @product = Product.find(params[:id])
    @product.destroy

    respond_to do |format|
      format.html { redirect_to(products_url) }
      format.xml  { head :ok }
    end
  end

  def who_bought
    @product = Product.find(params[:id])
    respond_to do |format|
      format.atom
      format.xml {render :xml => @product }
      end
  end

end
