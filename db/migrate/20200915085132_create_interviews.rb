class CreateInterviews < ActiveRecord::Migration[5.1]
  def change
    create_table :interviews do |t|
      t.string :topic
      t.time :start
      t.time :finish
      t.date :date

      t.timestamps
    end
  end
end
