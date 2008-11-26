class CreateSplitLevels < ActiveRecord::Migration
  def self.up
    create_table :split_levels do |t|
      t.column :department_id, :integer
      t.column :name, :string
      t.column :completed, :boolean
      t.column :url, :string
      t.column :level, :integer
      t.column :base_xpath, :string
      t.column :hospitality_div_xpath, :string, :default => "/table[2]"
      t.column :travel_div_xpath, :string, :default => "/table[1]"
      t.timestamps
    end
  end

  def self.down
    drop_table :split_levels
  end
end
