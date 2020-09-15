class Resume < ApplicationRecord
  belongs_to :users
  has_attached_file :resume
end
