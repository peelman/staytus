class AddEtrAndUptimeTimeToIssues < ActiveRecord::Migration[5.1]
  def change
    add_column :issues, :estimated_time_to_recovery, :string
    add_column :issues, :next_update_at, :datetime
  end
end
