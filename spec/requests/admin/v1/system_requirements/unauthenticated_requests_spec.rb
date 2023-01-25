require "rails_helper"

RSpec.describe "Admin::V1::SystemRequirements without authentication", type: :request do
  context "when GET /system_requirements" do
    let(:url) { "/admin/v1/system_requirements" }

    before { get url }
    
    include_examples "unauthenticated access"
  end
      
  context "when PATCH /system_requirements/:id" do
    let(:system_requirement) { create(:system_requirement) }
    let(:url) { "/admin/v1/system_requirements/#{system_requirement.id}" }

    before { patch url }

    include_examples "unauthenticated access"
  end
      
  context "when DELETE /system_requirements/:id" do
    let!(:system_requirement) { create(:system_requirement) }
    let(:url) { "/admin/v1/system_requirements/#{system_requirement.id}" } 

    before { delete url }

    include_examples "unauthenticated access"
  end
end
