class AddVisits < ActiveRecord::Migration
  def up
    change_table :links do |t|
      add_column :links, :visits, :integer, default: 0
    end
  end
  def down
    change_table :links do |t|
      remove_column :links, :visits
    end
  end
end