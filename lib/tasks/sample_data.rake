require 'faker'

namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    make_activities
  end
end

def make_activities
  99.times do |n|
    name  = Faker::Lorem.sentence(1)
    description = Faker::Lorem.paragraph( rand(15).to_i.abs )
    estimated_pomodoros = rand(8).to_i.abs
    deadline = rand(8).days.from_now
    completed = false
    
    Activity.create!( :name => name,
                      :description => description,
                      :estimated_pomodoros => estimated_pomodoros,
                      :deadline => deadline,
                      :completed => completed)
  end
end

