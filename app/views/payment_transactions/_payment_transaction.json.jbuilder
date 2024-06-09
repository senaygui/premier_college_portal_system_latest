json.extract! payment_transaction, :id, :created_at, :updated_at
json.url payment_transaction_url(payment_transaction, format: :json)
