class TestWorker
  include Sidekiq::Worker
  
  def perform
    puts "Sidekiq está funcionando corretamente!"
  end
end
  