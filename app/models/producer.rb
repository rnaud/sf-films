class Producer < ActiveRecord::Base
  has_many :movies
  include PgSearch
  multisearchable :against => :name
end
