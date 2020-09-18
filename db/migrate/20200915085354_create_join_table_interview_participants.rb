class CreateJoinTableInterviewParticipants < ActiveRecord::Migration[5.1]
  def change
    create_join_table :interviews, :users do |t|
      # t.index [:interview_id, :user_id]
      # t.index [:user_id, :interview_id]
    end
  end
end
