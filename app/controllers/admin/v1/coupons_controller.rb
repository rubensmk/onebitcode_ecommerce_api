module Admin::V1
  class CouponsController < ApiController
    before_action :load_coupon, only: %i[show update destroy]
    
    def index
      @coupons = Coupon.all
    end

    def create
      @coupon = Coupon.new
      @coupon.attributes = coupon_params
      save_user!
    end

    def update
      @coupon.attributes = coupon_params
      save_user!
    end

    def show; end

    def destroy
      @coupon.destroy!
    rescue StandardError
      render_error(fields: @coupon.errors.messages)
    end
    
    private

    def load_coupon
      @coupon = Coupon.find(params[:id])
    end

    def coupon_params
      return {} unless params.key?(:coupon)

      params.require(:coupon).permit(:id, :name, :code, :status, :discount_value, :max_use, :due_date)
    end
  
    def save_user!
      @coupon.save!
      render :show
    rescue StandardError
      render_error(fields: @coupon.errors.messages)
    end
  end
end
  