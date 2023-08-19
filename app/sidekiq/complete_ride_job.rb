class CompleteRideJob
  include Sidekiq::Job

  def perform(*args)
    # Do something
    publishes = Publish.where("date <= ? AND status = ?", 1.day.ago, "pending")

    publishes.each do |publish|
      publish.update(status: "completed")
      puts "Publish #{publish.id}, #{publish.status} completed."
    end

    puts "Complete publish task finished."

    passengers = Passenger.where("status = ?", "pending")

    passengers.each do |passenger|
      passenger.update(status: "ride completed")
      puts "Passenger #{passenger.id}, #{passenger.status} completed."
    end

    puts "Complete ride task finished."
  end
end
