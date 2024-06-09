class PaymentMethodsController < ApplicationController
  before_action :set_payment_method, only: %i[ show edit update destroy ]

  # GET /payment_methods or /payment_methods.json
  def index
    @payment_methods = PaymentMethod.all
  end

  # GET /payment_methods/1 or /payment_methods/1.json
  def show
  end

  # GET /payment_methods/new
  def new
    @payment_method = PaymentMethod.new
  end

  # GET /payment_methods/1/edit
  def edit
  end

  # POST /payment_methods or /payment_methods.json
  def create
    @payment_method = PaymentMethod.new(payment_method_params)

    respond_to do |format|
      if @payment_method.save
        format.html { redirect_to @payment_method, notice: "Payment method was successfully created." }
        format.json { render :show, status: :created, location: @payment_method }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @payment_method.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /payment_methods/1 or /payment_methods/1.json
  def update
    respond_to do |format|
      if @payment_method.update(payment_method_params)
        format.html { redirect_to @payment_method, notice: "Payment method was successfully updated." }
        format.json { render :show, status: :ok, location: @payment_method }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @payment_method.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payment_methods/1 or /payment_methods/1.json
  def destroy
    @payment_method.destroy
    respond_to do |format|
      format.html { redirect_to payment_methods_url, notice: "Payment method was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payment_method
      @payment_method = PaymentMethod.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def payment_method_params
      params.fetch(:payment_method, {})
    end
end
