require "rails_helper"

RSpec.describe "Admin::V1::Categories as :client", type: :request do
  let(:user) { create(:user, profile: :client) }

  context "when GET /categories" do
    let(:url) { "/admin/v1/categories" }
    let!(:categories) { create_list(:category, 5) }

    before { get url, headers: auth_header(user) }
    
    include_examples "forbidden access"
  end
      
  context "when GET /categories/:id" do
    let(:category) { create(:category) }
    let(:url) { "/admin/v1/categories/#{category.id}" }
  
    before { get url, headers: auth_header(user) }
  
    include_examples "forbidden access"
  end
  
  context "when POST /categories" do
    let(:url) { "/admin/v1/categories" }

    before { post url, headers: auth_header(user) }

    include_examples "forbidden access"
  end
      
  context "when PATCH /categories/:id" do
    let(:category) { create(:category) }
    let(:url) { "/admin/v1/categories/#{category.id}" }

    before { patch url, headers: auth_header(user) }

    include_examples "forbidden access"
  end
      
  context "when DELETE /categories/:id" do
    let!(:category) { create(:category) }
    let(:url) { "/admin/v1/categories/#{category.id}" } 

    before { delete url, headers: auth_header(user) }

    include_examples "forbidden access"
  end
end
