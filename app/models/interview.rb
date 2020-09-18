class Interview < ApplicationRecord
    has_and_belongs_to_many :users

    validates :topic, presence: true
    validates :date, presence: true
    validates :start, presence: true
    validates :finish, presence: true
end
