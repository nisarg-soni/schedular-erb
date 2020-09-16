class Interview < ApplicationRecord
    has_and_belongs_to_many :users

    validates :name, presence: true
    validates :date, presence: true
    validates :start_time, presence: true
    validates :end_time, presence: true
end
