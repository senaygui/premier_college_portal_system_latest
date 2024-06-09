require 'test_helper'

class PaymentTransactionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @payment_transaction = payment_transactions(:one)
  end

  test "should get index" do
    get payment_transactions_url
    assert_response :success
  end

  test "should get new" do
    get new_payment_transaction_url
    assert_response :success
  end

  test "should create payment_transaction" do
    assert_difference('PaymentTransaction.count') do
      post payment_transactions_url, params: { payment_transaction: {  } }
    end

    assert_redirected_to payment_transaction_url(PaymentTransaction.last)
  end

  test "should show payment_transaction" do
    get payment_transaction_url(@payment_transaction)
    assert_response :success
  end

  test "should get edit" do
    get edit_payment_transaction_url(@payment_transaction)
    assert_response :success
  end

  test "should update payment_transaction" do
    patch payment_transaction_url(@payment_transaction), params: { payment_transaction: {  } }
    assert_redirected_to payment_transaction_url(@payment_transaction)
  end

  test "should destroy payment_transaction" do
    assert_difference('PaymentTransaction.count', -1) do
      delete payment_transaction_url(@payment_transaction)
    end

    assert_redirected_to payment_transactions_url
  end
end
