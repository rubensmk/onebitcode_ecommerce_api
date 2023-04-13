json.featured do
  json.array! @loader_service.featured do |product|
    json.call(product, :id, :name, :description)
    json.price product.price.to_f
    json.image_url rails_blob_url(product.image)
  end
end
  
json.last_releases do
  json.array! @loader_service.last_releases do |product|
    json.call(product, :id, :name, :description)
    json.price product.price.to_f
    json.image_url rails_blob_url(product.image)
  end
end
  
json.cheapest do
  json.array! @loader_service.cheapest do |product|
    json.call(product, :id, :name, :description)
    json.price product.price.to_f
    json.image_url rails_blob_url(product.image)
  end
end
  