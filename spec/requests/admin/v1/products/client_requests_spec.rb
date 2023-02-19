require "rails_helper"

RSpec.describe "Admin V1 Products as :client", type: :request do
  let(:user) { create(:user, profile: :client) }

  context "when GET /products" do
    let(:url) { "/admin/v1/products" }
    let!(:products) { create_list(:product, 5) }
    
    before { get url, headers: auth_header(user) }

    include_examples "forbidden access"
  end

  context "when POST /products" do
    let(:url) { "/admin/v1/products" }
    
    before { post url, headers: auth_header(user) }

    include_examples "forbidden access"
  end

  context "when GET /products/:id" do
    let(:product) { create(:product) }
    let(:url) { "/admin/v1/products/#{product.id}" }

    before { get url, headers: auth_header(user) }

    include_examples "forbidden access"
  end

  context "when PATCH /products/:id" do
    let(:product) { create(:product) }
    let(:url) { "/admin/v1/products/#{product.id}" }

    before { patch url, headers: auth_header(user) }

    include_examples "forbidden access"
  end

  context "when DELETE /products/:id" do
    let!(:product) { create(:product) }
    let(:url) { "/admin/v1/products/#{product.id}" }

    before { delete url, headers: auth_header(user) }

    include_examples "forbidden access"
  end
end
