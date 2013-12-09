class Movie < ActiveRecord::Base

  belongs_to :director
  belongs_to :producer
  has_many :locations

  validates :title, presence: true
  validates :year, presence: true

  include PgSearch
  multisearchable :against => [:title, :year]

  def name
    title
  end

end
