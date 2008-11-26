class CreateDepartments < ActiveRecord::Migration
  def self.up
    create_table :departments do |t|
      t.column :name, :string
      t.column :url, :string
      t.column :completed, :boolean
      t.column :is_scrapeable, :string
      t.column :levels, :integer
      t.column :split_level, :integer
       t.timestamps
    end
  end

  def self.down
    drop_table :departments
  end
end
