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
  belongs_to :venue
  belongs_to :customer

  has_many :line_items

  validates :venue_id, presence: true
end

class LineItem < ActiveRecord::Base
  belongs_to :order

  validates :order_id, :presence => true
  validates :quantity, :presence => true
  validates :item, :presence => true
end

class Customer < ActiveRecord::Base
  has_many :orders

  validates :email, :presence => true
  validates :stripe_id, :presence => true
end

class Venue < ActiveRecord::Base
  has_many :liquors_venues, :inverse_of => :venue
  has_many :liquors, :through => :liquors_venues
  
  has_many :menu_items, :inverse_of => :venue
  has_many :operating_times, :inverse_of => :venue
  has_many :customers, :through => :orders
  has_many :orders

  validates :name, :presence => true
  validates :handle, :presence => true, :uniqueness => true
end

class MenuItem < ActiveRecord::Base
  belongs_to :venue

  validates :name, :presence => true
  validates :price, :presence => true
  validates :venue_id, :presence => true
end

class OperatingTime < ActiveRecord::Base
  belongs_to :venue

  validates :venue_id, :presence => true
  validates :day_of_week, :presence => true
  validates :start_hour, :presence => true
  validates :end_hour, :presence => true
end