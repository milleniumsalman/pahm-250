class CreateQuizOptions < ActiveRecord::Migration
  def change
    create_table :quiz_options do |t|
      t.integer :question
      t.integer :answer
      t.boolean :correct
      t.integer :user_id

      t.timestamps
    end
  end
end
