class Admin::OrdersController < ApplicationController  # GET /orders
  # GET /orders.json
  layout 'admin/application.html.haml'

  before_filter :require_admin

  def index
    @orders = Order.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @orders }
    end
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
    @order = Order.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @order }
    end
  end

  # GET /orders/new
  # GET /orders/new.json
  def new
    @order = Order.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @order }
    end
  end

  # GET /orders/1/edit
  def edit
    @order = Order.find(params[:id])
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = Order.new(params[:order])

    respond_to do |format|
      if @order.save
        format.html { redirect_to @order, notice: 'Order was successfully created.' }
        format.json { render json: @order, status: :created, location: @order }
      else
        format.html { render action: "new" }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end


#  I think we need to change the edit/create to reflect the admin_orders_path
    # respond_to do |format|
    #   if @category.save
    #     format.html { redirect_to admin_categories_path, notice: 'Category was successfully created.' }
    #     format.json { render json: admin_categories_path, status: :created, location: @category }
    #   else
    #     format.html { render action: "new" }
    #     format.json { render json: admin_categories_path.errors, status: :unprocessable_entity }
    #   end
    # end


  # PUT /orders/1
  # PUT /orders/1.json
  def update
    @order = Order.find(params[:id])

    respond_to do |format|
      if @order.update_attributes(params[:order])
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order = Order.find(params[:id])
    @order.destroy

    respond_to do |format|
      format.html { redirect_to admin_orders_path }
      format.json { head :no_content }
    end
  end


  private
 
  def require_admin
    if logged_in?
      redirect_to login_url unless current_user.admin
    else 
      redirect_to login_url
    end
  end
end