require "rails_helper"

RSpec.describe "Admin::V1::Coupons as :client", type: :request do
  let(:login_user) { create(:user, profile: :client) }

  context "when GET /coupons" do
    let(:url) { "/admin/v1/coupons" }

    before { get url, headers: auth_header(login_user) }
    
    include_examples "forbidden access"
  end
   
  context "when PATCH /coupons/:id" do
    let(:coupon) { create(:coupon) }
    let(:url) { "/admin/v1/coupons/#{coupon.id}" }

    before { patch url, headers: auth_header(login_user) }

    include_examples "forbidden access"
  end
      
  context "when DELETE /coupons/:id" do
    let!(:coupon) { create(:coupon) }
    let(:url) { "/admin/v1/coupons/#{coupon.id}" } 

    before { delete url, headers: auth_header(login_user) }

    include_examples "forbidden access"
  end
end
