require "rails_helper"

RSpec.describe "Admin::V1::Users without authentication", type: :request do
  context "when GET /users" do
    let(:url) { "/admin/v1/users" }

    before { get url }
    
    include_examples "unauthenticated access"
  end
      
  context "when PATCH /users/:id" do
    let(:user) { create(:user) }
    let(:url) { "/admin/v1/users/#{user.id}" }

    before { patch url }

    include_examples "unauthenticated access"
  end
      
  context "when DELETE /users/:id" do
    let!(:user) { create(:user) }
    let(:url) { "/admin/v1/users/#{user.id}" } 

    before { delete url }

    include_examples "unauthenticated access"
  end
end
