module Juno::V1
  class PaymentConfirmationsController < ApplicationController
    include StaticTokenAuthenticatable
    
    def create
      Juno::Charge.find_by(code: params[:chargeCode])&.order&.update(status: :payment_accepted) if params.has_key?(:chargeCode)
      head :ok
    end


  end
end
