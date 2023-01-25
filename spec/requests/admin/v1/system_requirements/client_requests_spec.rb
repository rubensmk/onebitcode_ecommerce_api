require "rails_helper"

RSpec.describe "Admin::V1::SystemRequirements as :client", type: :request do
  let(:login_user) { create(:user, profile: :client) }

  context "when GET /system_requirements" do
    let(:url) { "/admin/v1/system_requirements" }

    before { get url, headers: auth_header(login_user) }
    
    include_examples "forbidden access"
  end
   
  context "when PATCH /system_requirements/:id" do
    let(:system_requirement) { create(:system_requirement) }
    let(:url) { "/admin/v1/system_requirements/#{system_requirement.id}" }

    before { patch url, headers: auth_header(login_user) }

    include_examples "forbidden access"
  end
      
  context "when DELETE /system_requirements/:id" do
    let!(:system_requirement) { create(:system_requirement) }
    let(:url) { "/admin/v1/system_requirements/#{system_requirement.id}" } 

    before { delete url, headers: auth_header(login_user) }

    include_examples "forbidden access"
  end
end
