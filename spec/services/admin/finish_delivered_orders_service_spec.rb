require "rails_helper"

RSpec.describe Admin::FinishDeliveredOrdersService do
  describe "#call" do
    let!(:order) { create(:order) }
    let!(:delivered_line_items) { create_list(:line_item, 2, order: order) }

    before do
      order.update!(status: :payment_accepted)
      delivered_line_items.each { |line_item| line_item.update!(status: :delivered) }
    end

    it "set order as :finished when all line items are :delived" do
      described_class.call
      order.reload
      expect(order.status).to eq "finished"
    end

    it "does not set order as :finished when at least one line item is not delived yet" do
      create(:line_item, order: order, status: :preparing)
      described_class.call
      order.reload
      expect(order.status).not_to eq "finished"
    end

    it "does not set order as :finished until it is on :payment_accepted status" do
      order.update!(status: :processing_order)
      described_class.call
      order.reload
      expect(order.status).to eq "processing_order"
    end
  end
end
