class User < ApplicationRecord
    has_and_belongs_to_many :interviews
    has_one :resume
    # validates :email, presence: true
    # validates :name, presence: true
    # validates :role, presence: true
    # validates :has_resume, presence: true
end
