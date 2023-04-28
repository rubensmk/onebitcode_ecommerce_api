require "rails_helper"

describe Juno::ChargeCreationService do
  let!(:order) { create(:order) }

  context "when #call" do
    let!(:order) { create(:order) }

    context "with charge invalid params" do
      before do
        allow_any_instance_of(JunoApi::Charge)
          .to receive(:create!)
          .and_raise(JunoApi::RequestError.new("Invalid request sent to Juno"))
      end
      
      it "does not create Juno charge" do
        expect do
          described_class.new(order).call
        end.not_to change(Juno::Charge, :count)
      end

      it "does ot create Juno payments" do
        expect do
          described_class.new(order).call
        end.not_to change(Juno::CreditCardPayment, :count)
      end

      it "order receives :processing_error status" do
        described_class.new(order).call
        order.reload
        expect(order.status).to eq "processing_error"
      end

      it "send a generic error email" do
        expect do
          described_class.new(order).call
        end.to have_enqueued_job(ActionMailer::MailDeliveryJob).with(
          "CheckoutMailer", "generic_error", "deliver_now", { params: { order: order.clone.reload }, args: [] }
        )
      end
    end

    context "with valid valid charges" do
      let!(:charges_attributes) do
        attributes_for_list(:juno_charge, order.installments).map do |charge|
          charge[:installment_link] = charge.delete(:billet_url)
          charge[:id] = charge.delete(:key)
          charge
        end
      end

      before do 
        allow_any_instance_of(JunoApi::Charge).to receive(:create!).and_return(charges_attributes)
      end

      context "when credit card does not have balance" do
        let!(:payment_error) { [{ "error_code" => "289999", "message" => "N\u00E3o autorizado. Saldo insuficiente." }] }

        before do
          allow_any_instance_of(JunoApi::CreditCardPayment)
            .to receive(:create!)
            .and_raise(JunoApi::RequestError.new("Invalid request sent to Juno", payment_error))
        end

        it "creates Juno charge" do
          expect do
            described_class.new(order).call
          end.to change(Juno::Charge, :count).by(order.installments)
        end

        it "does not create Juno credit card payments" do
          expect do
            described_class.new(order).call
          end.not_to change(Juno::CreditCardPayment, :count)
        end

        it "order receives :payment_denied status" do
          described_class.new(order).call
          order.reload
          expect(order.status).to eq "payment_denied"
        end

        it "send a payment error email" do
          expect do
            described_class.new(order).call
          end.to have_enqueued_job(ActionMailer::MailDeliveryJob).with(
            "CheckoutMailer", "payment_error", "deliver_now", { params: { order: order.clone.reload }, 
                                                                args:   [payment_error.first["message"]] }
          )
        end 
      end

      context "when credit card is restrict" do
        let!(:payment_error) { [{ "error_code" => "289999", "message" => "N\u00E3o autorizado. Cart\u00E3o restrito." }] }
        
        before do
          allow_any_instance_of(JunoApi::CreditCardPayment)
            .to receive(:create!)
            .and_raise(JunoApi::RequestError.new("Invalid request sent to Juno", payment_error))
        end

        it "creates Juno charge" do
          expect do
            described_class.new(order).call
          end.to change(Juno::Charge, :count).by(order.installments)
        end

        it "does not create Juno credit card payments" do
          expect do
            described_class.new(order).call
          end.not_to change(Juno::CreditCardPayment, :count)
        end

        it "order receives :payment_denied status" do
          described_class.new(order).call
          order.reload
          expect(order.status).to eq "payment_denied"
        end

        it "send a payment error email" do
          expect do
            described_class.new(order).call
          end.to have_enqueued_job(ActionMailer::MailDeliveryJob).with(
            "CheckoutMailer", "payment_error", "deliver_now", { params: { order: order.clone.reload }, 
                                                                args:   [payment_error.first["message"]] }
          )
        end
      end

      context "when credit card is invalid" do
        let!(:payment_error) { [{ "error_code" => "289999", "message" => "N\u00E3o autorizado. Cart\u00E3o inv\u00E1lido." }] }

        before do
          allow_any_instance_of(JunoApi::CreditCardPayment)
            .to receive(:create!)
            .and_raise(JunoApi::RequestError.new("Invalid request sent to Juno", payment_error))
        end

        it "creates Juno charge" do
          expect do
            described_class.new(order).call
          end.to change(Juno::Charge, :count).by(order.installments)
        end

        it "does not create Juno credit card payments" do
          expect do
            described_class.new(order).call
          end.not_to change(Juno::CreditCardPayment, :count)
        end

        it "order receives :payment_denied status" do
          described_class.new(order).call
          order.reload
          expect(order.status).to eq "payment_denied"
        end

        it "send a payment error email" do
          expect do
            described_class.new(order).call
          end.to have_enqueued_job(ActionMailer::MailDeliveryJob).with(
            "CheckoutMailer", "payment_error", "deliver_now", { params: { order: order.clone.reload }, 
                                                                args:   [payment_error.first["message"]] }
          )
        end
      end

      context "when there is an error on credit card operation" do
        let!(:payment_error) do 
          [{ 
            "error_code" => "509999", 
            "message"    => "N\u00E3o foi poss\u00EDvel realizar a opera\u00E7\u00E3o, por favor, tente novamente mais tarde" 
          }]
        end

        before do
          allow_any_instance_of(JunoApi::CreditCardPayment)
            .to receive(:create!)
            .and_raise(JunoApi::RequestError.new("Invalid request sent to Juno", payment_error))
        end

        it "creates Juno charge" do
          expect do
            described_class.new(order).call
          end.to change(Juno::Charge, :count).by(order.installments)
        end

        it "does not create Juno credit card payments" do
          expect do
            described_class.new(order).call
          end.not_to change(Juno::CreditCardPayment, :count)
        end

        it "order receives :payment_denied status" do
          described_class.new(order).call
          order.reload
          expect(order.status).to eq "payment_denied"
        end

        it "send a payment error email" do
          expect do
            described_class.new(order).call
          end.to have_enqueued_job(ActionMailer::MailDeliveryJob).with(
            "CheckoutMailer", "payment_error", "deliver_now", { params: { order: order.clone.reload }, 
                                                                args:   [payment_error.first["message"]] }
          )
        end
      end

      context "when credit card operation does not have any blocking" do
        let(:credit_card_payments_attributes) do
          charges_attributes.map { |charge| attributes_for(:juno_credit_card_payment).merge(charge: charge[:id]) }
        end

        before do 
          allow_any_instance_of(JunoApi::CreditCardPayment)
            .to receive(:create!)
            .and_return(credit_card_payments_attributes)
        end

        it "creates Juno charge" do
          expect do
            described_class.new(order).call
          end.to change(Juno::Charge, :count).by(order.installments)
        end

        it "creates Juno credit card payments" do
          expect do
            described_class.new(order).call
          end.to change(Juno::CreditCardPayment, :count).by(charges_attributes.count)
        end

        it "order receives :payment_accepted status" do
          described_class.new(order).call
          order.reload
          expect(order.status).to eq "payment_accepted"
        end

        it "send a success email" do
          expect do
            described_class.new(order).call
          end.to have_enqueued_job(ActionMailer::MailDeliveryJob).with(
            "CheckoutMailer", "success", "deliver_now", { params: { order: order.clone.reload }, args: [] }
          )
        end
      end

      context "when it is an order payed by billet" do
        before { order.update(payment_type: :billet) }

        it "creates Juno charge" do
          expect do
            described_class.new(order).call
          end.to change(Juno::Charge, :count).by(order.installments)
        end

        it "does not create Juno credit card payments" do
          expect do
            described_class.new(order).call
          end.not_to change(Juno::CreditCardPayment, :count)
        end

        it "order receives :waiting_payment status" do
          described_class.new(order).call
          order.reload
          expect(order.status).to eq "waiting_payment"
        end

        it "send a success email" do
          expect do
            described_class.new(order).call
          end.to have_enqueued_job(ActionMailer::MailDeliveryJob).with(
            "CheckoutMailer", "success", "deliver_now", { params: { order: order.clone.reload }, args: [] }
          )
        end
      end
    end
  end
end
