class Objective < ActiveRecord::Base
  belongs_to :user
  has_many :requirements
end
