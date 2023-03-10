require "rails_helper"

RSpec.describe "Admin::V1::Categories without authentication", type: :request do
  context "when GET /categories" do
    let(:url) { "/admin/v1/categories" }
    let!(:categories) { create_list(:category, 5) }

    before { get url }
    
    include_examples "unauthenticated access"
  end
      
  context "when POST /categories" do
    let(:url) { "/admin/v1/categories" }

    before { post url }

    include_examples "unauthenticated access"
  end

  context "when GET /categories/:id" do
    let(:category) { create(:category) }
    let(:url) { "/admin/v1/categories/#{category.id}" }
  
    before { get url }
  
    include_examples "unauthenticated access"
  end
      
  context "when PATCH /categories/:id" do
    let(:category) { create(:category) }
    let(:url) { "/admin/v1/categories/#{category.id}" }

    before { patch url }

    include_examples "unauthenticated access"
  end
      
  context "when DELETE /categories/:id" do
    let!(:category) { create(:category) }
    let(:url) { "/admin/v1/categories/#{category.id}" } 

    before { delete url }

    include_examples "unauthenticated access"
  end
end
