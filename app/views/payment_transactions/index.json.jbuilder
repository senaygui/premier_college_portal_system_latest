json.set! :data do
  json.array! @payment_transactions do |payment_transaction|
    json.partial! 'payment_transactions/payment_transaction', payment_transaction: payment_transaction
    json.url  "
              #{link_to 'Show', payment_transaction }
              #{link_to 'Edit', edit_payment_transaction_path(payment_transaction)}
              #{link_to 'Destroy', payment_transaction, method: :delete, data: { confirm: 'Are you sure?' }}
              "
  end
end