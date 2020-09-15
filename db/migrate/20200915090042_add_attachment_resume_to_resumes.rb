class AddAttachmentResumeToResumes < ActiveRecord::Migration[5.1]
  def self.up
    change_table :resumes do |t|
      t.attachment :resume
    end
  end

  def self.down
    remove_attachment :resumes, :resume
  end
end
