class CreateSlackSettings < ActiveRecord::Migration[4.2]
  def change
    create_table :slack_settings do |t|
      t.string :webhook_url, :icon, :channel, :name
      t.timestamps null: false
    end
  end
end
