json.set! :data do
  json.array! @invoices do |invoice|
    json.partial! 'invoices/invoice', invoice: invoice
    json.url  "
              #{link_to 'Show', invoice }
              #{link_to 'Edit', edit_invoice_path(invoice)}
              #{link_to 'Destroy', invoice, method: :delete, data: { confirm: 'Are you sure?' }}
              "
  end
end