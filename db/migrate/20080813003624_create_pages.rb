class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.column :url, :string
      t.timestamps
    end
  end

  def self.down
    drop_table :pages
  end
end
