class Resume < ApplicationRecord
  belongs_to :user
  validates :file, presence: true
  has_attached_file :file
  validates_attachment_content_type :file, 
  :content_type => ["text/plain","application/pdf", "application/msword", 
    "application/vnd.openxmlformats-officedocument.wordprocessingml.document"]

end
