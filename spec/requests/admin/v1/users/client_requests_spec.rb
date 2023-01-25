require "rails_helper"

RSpec.describe "Admin::V1::Users as :client", type: :request do
  let(:login_user) { create(:user, profile: :client) }

  context "when GET /users" do
    let(:url) { "/admin/v1/users" }

    before { get url, headers: auth_header(login_user) }
    
    include_examples "forbidden access"
  end
   
  context "when PATCH /users/:id" do
    let(:user) { create(:user) }
    let(:url) { "/admin/v1/users/#{user.id}" }

    before { patch url, headers: auth_header(login_user) }

    include_examples "forbidden access"
  end
      
  context "when DELETE /users/:id" do
    let!(:user) { create(:user) }
    let(:url) { "/admin/v1/users/#{user.id}" } 

    before { delete url, headers: auth_header(login_user) }

    include_examples "forbidden access"
  end
end
