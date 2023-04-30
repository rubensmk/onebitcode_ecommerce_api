json.orders do
  json.array! @orders do |order| 
    json.call(order, :id, :status, :total_amount, :payment_type)
  end
end
