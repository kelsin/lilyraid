namespace :api do
  desc "Update all characters from the API and then update each guild"
  task :update => :environment do
    errored = []

    Character.all.each do |c|
      begin
        puts "Updating #{c.name} from #{c.realm || CONFIG[:realm]} (#{c.realm ? "char" : "config"})"
        c.update_from_armory!(c.realm || CONFIG[:realm])
      rescue Exception => e
        puts "Error updating #{c.name}: #{e.response}"
        errored << c
      end
      sleep(2)
    end

    unless errored.empty?
      puts "Errored characters"
      puts errored
    end
  end
end
