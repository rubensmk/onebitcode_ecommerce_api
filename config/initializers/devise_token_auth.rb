# frozen_string_literal: true

DeviseTokenAuth.setup do |config|

  config.change_headers_on_each_request = true

  config.token_lifespan = 1.week

  config.token_cost = Rails.env.test? ? 4 : 10

  config.batch_request_buffer_throttle = 5.seconds

  config.require_client_password_reset_token = true

  config.default_password_reset_url = "http://localhost:3001/change_it"

end
