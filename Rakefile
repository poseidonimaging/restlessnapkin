require "./app"
require "sinatra/activerecord/rake"

namespace :restlessnapkin do
  desc "Loads liquors into the liquors table"
  task :load_liquors => [:load_gins, :load_tequilas, :load_vodkas, :load_rums]

  desc "Loads vodkas into the liquors table"
  task :load_vodkas do
    # Load vodkas
    ["Tito's", "Smirnoff", "Deep Eddy", "Absolut", "Grey Goose",
      "Svedka", "Ketel One", "Skyy"].each do |name|
        liquor = Liquor.where(:liquor_type => "vodka", :name => name).first_or_initialize
        liquor.save!
      end
  end

  desc "Loads gins into the liquors table"
  task :load_gins do
    # Load gins
    ["Bombay", "Tanqueray", "Hendrick's", "Beefeater"].each do |name|
        liquor = Liquor.where(:liquor_type => "gin", :name => name).first_or_initialize
        liquor.save!
      end
  end

  desc "Loads tequila into the liquors table"
  task :load_tequilas do
    # load tequilas
    ["Jose Cuervo", "1800", "Mezcal", "Herradura", "Patron"].each do |name|
      liquor = Liquor.where(:liquor_type => "tequila", :name => name).first_or_initialize
      liquor.save!
    end
  end

  desc "Loads rum into the liquors table"
  task :load_rums do
    # load rum
    ["Appleton", "Bacardi", "Captain Morgan", "Kraken", "Myers Original Dark"].each do |name|
      liquor = Liquor.where(:liquor_type => "rum", :name => name).first_or_initialize
      liquor.save!
    end
  end

  desc "Loads venues into venues table"
  task :load_venues do
    # load venues
      venue = Venue.where(:handle => "slipinn", :name => "Slip Inn").first_or_initialize
      venue.save!
  end

  desc "Liquors for Slip Inn"
  task :load_slipinn_liquors do
    # load liquors for slipinn
    ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22"].each do |liquor_id|
      liquor_venue = LiquorVenue.where(:venue_id => "1", :liquor_id => liquor_id).first_or_initialize
      liquor_venue.save!
    end
  end

  #desc "Loads whisky into the liquors table"
  #task :load_whiskys do
    # load whisky
  #  ["Bulleit Bourbon", "Canadian Club", "Jack Daniels", "Jim Beam", "Knob Creek", "Seagrams 7"].each do |name|
  #    liquor = Liquor.where(:liquor_type => "whisky", :name => name).first_or_initialize
  #    liquor.save!
  #  end
  #end

end