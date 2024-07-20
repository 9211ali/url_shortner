class CreateViews < ActiveRecord::Migration[7.1]
  def change
    create_table :views do |t|
      t.string :ip
      t.string :user_agent
      t.belongs_to :link, null: false, foreign_key: true

      t.timestamps
    end
  end
end
