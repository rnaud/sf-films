class Director < ActiveRecord::Base
  validates :name, presence: true
  has_many :movies

  include PgSearch
  multisearchable :against => :name
end
