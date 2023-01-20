FactoryBot.define do
  factory :system_requirement do
    sequence(:name) { |n| "Basic #{n}" }
    operational_system { Faker::Computer.os }
    storage { "500GB" }
    processor { "Ryzen 5 5400" }
    memory { "16GB" }
    video_board { "GTX 1060Ti 6GB" }
  end
end
