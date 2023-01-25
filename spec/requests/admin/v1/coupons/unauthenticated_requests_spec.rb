require "rails_helper"

RSpec.describe "Admin::V1::Coupons without authentication", type: :request do
  context "when GET /coupons" do
    let(:url) { "/admin/v1/coupons" }

    before { get url }
    
    include_examples "unauthenticated access"
  end
      
  context "when PATCH /coupons/:id" do
    let(:coupon) { create(:coupon) }
    let(:url) { "/admin/v1/coupons/#{coupon.id}" }

    before { patch url }

    include_examples "unauthenticated access"
  end
      
  context "when DELETE /coupons/:id" do
    let!(:coupon) { create(:coupon) }
    let(:url) { "/admin/v1/coupons/#{coupon.id}" } 

    before { delete url }

    include_examples "unauthenticated access"
  end
end
