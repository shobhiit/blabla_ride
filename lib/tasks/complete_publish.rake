require 'httparty'
require 'dotenv/tasks'

namespace :publish do
  desc "Complete publish task"
  task complete_publish: :environment do
    publishes = Publish.where("date <= ? AND status = ?", 1.day.ago, "pending")

    publishes.each do |publish|
      publish.update(status: "completed")
      puts "Publish #{publish.id}, #{publish.status} completed."
    end

    puts "Complete publish task finished."
  end

  desc "Complete ride task"
  task complete_ride: :environment do
    passengers = Passenger.where("status = ?", "pending")

    passengers.each do |passenger|
      passenger.update(status: "ride completed")
      puts "Passenger #{passenger.id}, #{passenger.status} completed."
    end

    puts "Complete ride task finished."
  end
end

