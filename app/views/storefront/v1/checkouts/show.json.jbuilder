json.order do
  json.call(@service.order, :id, :payment_type, :installments)
  json.subtotal @service.order.subtotal.to_f
  json.total_amount @service.order.total_amount.to_f
end
