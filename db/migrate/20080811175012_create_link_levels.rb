class CreateLinkLevels < ActiveRecord::Migration
  def self.up
    create_table :link_levels do |t|
      t.column :department_id, :integer
      t.column :name, :string
      t.column :completed, :boolean
      t.column :url, :string
      t.column :level, :integer
      t.column :example_text, :string
      t.timestamps
    end
  end

  def self.down
    drop_table :link_levels
  end
end
