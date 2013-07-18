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

  #desc "Loads whisky into the liquors table"
  #task :load_whiskys do
    # load whisky
  #  ["Bulleit Bourbon", "Canadian Club", "Jack Daniels", "Jim Beam", "Knob Creek", "Seagrams 7"].each do |name|
  #    liquor = Liquor.where(:liquor_type => "whisky", :name => name).first_or_initialize
  #    liquor.save!
  #  end
  #end

end