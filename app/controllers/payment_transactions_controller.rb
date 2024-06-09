class PaymentTransactionsController < ApplicationController
  before_action :set_payment_transaction, only: %i[ show edit update destroy ]

  # GET /payment_transactions or /payment_transactions.json
  def index
    @payment_transactions = PaymentTransaction.all
  end

  # GET /payment_transactions/1 or /payment_transactions/1.json
  def show
  end

  # GET /payment_transactions/new
  def new
    @payment_transaction = PaymentTransaction.new
    @payment_method = PaymentMethod.find(params[:payment_method_id])
    @invoice = Invoice.find(params[:invoice_id])
  end

  # GET /payment_transactions/1/edit
  def edit
    @payment_method = @payment_transaction.payment_method
    @invoice = @payment_transaction.invoice
  end

  # POST /payment_transactions or /payment_transactions.json
  def create
    @payment_transaction = PaymentTransaction.new(payment_transaction_params)

    respond_to do |format|
      if @payment_transaction.save
        format.html { redirect_to invoice_path(@payment_transaction.invoiceable), notice: "Payment transaction was successfully created." }
        format.json { render :show, status: :created, location: @payment_transaction }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @payment_transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /payment_transactions/1 or /payment_transactions/1.json
  def update
    respond_to do |format|
      if @payment_transaction.update(payment_transaction_params)
        format.html { redirect_to @payment_transaction, notice: "Payment transaction was successfully updated." }
        format.json { render :show, status: :ok, location: @payment_transaction }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @payment_transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payment_transactions/1 or /payment_transactions/1.json
  def destroy
    @payment_transaction.destroy
    respond_to do |format|
      format.html { redirect_to payment_transactions_url, notice: "Payment transaction was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payment_transaction
      @payment_transaction = PaymentTransaction.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def payment_transaction_params
      params.fetch(:payment_transaction, {}).permit(:invoiceable_type, :invoiceable_id, :payment_method_id,:account_holder_fullname,:phone_number,:account_number,:transaction_reference,:finance_approval_status,:last_updated_by,:created_by, :receipt_image)
    end
end
