class CreateClicksTable < ActiveRecord::Migration
  def up
  	create_table :clicks do |t|
  		t.timestamps
  		t.string	 :source
  		t.belongs_to :link
  	end
  end

  def down
  	drop_table :clicks
  end
end
