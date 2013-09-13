class Liquor < ActiveRecord::Base
  has_many :liquors_venues, :inverse_of => :liquor
  has_many :venues, :through => :liquors_venues

  validates :liquor_type, :presence => true, :inclusion => { :in => %w{vodka gin tequila mixer rum whiskey garnish} }
  validates :name, :presence => true

  def self.by_type(type)
    where(:liquor_type => type)
  end

  def well_for?(venue)
    LiquorsVenue.where(:liquor_id => self.id, :venue_id => venue.id).first.well?
  end
end

class LiquorsVenue < ActiveRecord::Base
  belongs_to :liquor, :inverse_of => :liquors_venues
  belongs_to :venue, :inverse_of => :liquors_venues

  validates :liquor_id, :presence => true, :uniqueness => { :scope => :venue_id }
  validates :venue_id, :presence => true
  validates :well, :inclusion => { :in => [true, false], :allow_nil => true }
end

class Order < ActiveRecord::Base
  validates :venue, presence: true, length: { minimum: 3}
  validates :location, presence: true, length: { minimum: 1}
  validates :lastname, presence: true, length: { minimum: 2}
  validates :phone, presence: true, length: { minimum: 10}
  validates :drinks_1, presence: true, length: { minimum: 5}
end

class Venue < ActiveRecord::Base
  has_many :liquors_venues, :inverse_of => :venue
  has_many :liquors, :through => :liquors_venues
  has_many :menu_items, :inverse_of => :venue

  validates :name, :presence => true
  validates :handle, :presence => true, :uniqueness => true
end

class MenuItems < ActiveRecord::Base
  validates :name, :presence => true
  validates :description, :presence => true
  validates :price, :presence => true
  validates :venue_id, :presence => true
end