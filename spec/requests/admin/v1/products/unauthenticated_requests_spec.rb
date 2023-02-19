require "rails_helper"

RSpec.describe "Admin V1 Product without authentication", type: :request do
  
  context "when GET /products" do
    let(:url) { "/admin/v1/products" }
    let!(:products) { create_list(:product, 5) }

    before { get url }
    
    include_examples "unauthenticated access"
  end

  context "when POST /products" do
    let(:url) { "/admin/v1/products" }
    
    before { post url }
    
    include_examples "unauthenticated access"
  end

  context "when GET /products/:id" do
    let(:product) { create(:product) }
    let(:url) { "/admin/v1/products/#{product.id}" }

    before { get url }

    include_examples "unauthenticated access"
  end

  context "when PATCH /products/:id" do
    let(:product) { create(:product) }
    let(:url) { "/admin/v1/products/#{product.id}" }

    before { patch url }
    
    include_examples "unauthenticated access"
  end

  context "when DELETE /products/:id" do
    let!(:product) { create(:product) }
    let(:url) { "/admin/v1/products/#{product.id}" }

    before { delete url }
    
    include_examples "unauthenticated access"
  end
end
