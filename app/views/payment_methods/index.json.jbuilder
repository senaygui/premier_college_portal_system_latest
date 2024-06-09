json.set! :data do
  json.array! @payment_methods do |payment_method|
    json.partial! 'payment_methods/payment_method', payment_method: payment_method
    json.url  "
              #{link_to 'Show', payment_method }
              #{link_to 'Edit', edit_payment_method_path(payment_method)}
              #{link_to 'Destroy', payment_method, method: :delete, data: { confirm: 'Are you sure?' }}
              "
  end
end