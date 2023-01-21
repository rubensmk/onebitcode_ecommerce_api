module Storefront
  module V1
    class ApiController < ApplicationController
      include Authenticatable
    end
  end
end
