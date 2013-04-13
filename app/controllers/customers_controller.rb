class CustomersController < ApplicationController
  before_filter :require_login, except: [:new, :create]
  skip_filter :scope_current_store

  def show
    @customer = Customer.find(current_user.id)
  end

  def new
    @customer = Customer.new
  end

  def edit
    @customer = Customer.find(current_user.id)
  end

  def create
    @customer = Customer.new(params[:customer])

    if @customer.save
      auto_login(@customer)
      Mailer.welcome_email(@customer).deliver
      redirect_to account_path, notice: 'Customer was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    @customer = Customer.find(params[:id])

    if @customer.update_attributes(params[:customer])
      redirect_to @customer, notice: 'Customer was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @customer = Customer.find(params[:id])
    @customer.destroy

    redirect_to customers_url
  end
end
