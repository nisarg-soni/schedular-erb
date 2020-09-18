class Resume < ApplicationRecord
  belongs_to :user, optional: true
  validates :file, presence: true
  has_attached_file :file
  validates_attachment_content_type :file, 
  :content_type => ["application/pdf", "application/msword", 
    "application/vnd.openxmlformats-officedocument.wordprocessingml.document"]

end
