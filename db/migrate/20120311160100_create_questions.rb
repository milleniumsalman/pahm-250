class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :question
      t.integer :right
      t.integer :wrong
      t.integer :difficulty
      t.integer :chapter
      t.text :hint

      t.timestamps
    end
  end
end
