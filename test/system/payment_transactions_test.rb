require "application_system_test_case"

class PaymentTransactionsTest < ApplicationSystemTestCase
  setup do
    @payment_transaction = payment_transactions(:one)
  end

  test "visiting the index" do
    visit payment_transactions_url
    assert_selector "h1", text: "Payment Transactions"
  end

  test "creating a Payment transaction" do
    visit payment_transactions_url
    click_on "New Payment Transaction"

    click_on "Create Payment transaction"

    assert_text "Payment transaction was successfully created"
    click_on "Back"
  end

  test "updating a Payment transaction" do
    visit payment_transactions_url
    click_on "Edit", match: :first

    click_on "Update Payment transaction"

    assert_text "Payment transaction was successfully updated"
    click_on "Back"
  end

  test "destroying a Payment transaction" do
    visit payment_transactions_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Payment transaction was successfully destroyed"
  end
end
