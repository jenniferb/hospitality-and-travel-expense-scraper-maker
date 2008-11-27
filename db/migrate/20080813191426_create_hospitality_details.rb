class CreateHospitalityDetails < ActiveRecord::Migration
  def self.up
    create_table :hospitality_details do |t|
      t.column :department_id, :integer
      t.column :name, :string
      t.column :completed, :boolean
      t.column :url, :string
      t.column :person_name_format, :string
      t.column :date_format, :string
      t.column :report_xpath, :string      
      t.column :person_name_and_position_xpath, :string, :default => "/tr[1]"
      t.column :start_date, :string, :default => "3"
      t.column :end_date, :string
      t.column :purpose, :string, :default => "2"
      t.column :location, :string, :default => "4"
      t.column :attendees, :string, :default => "5"
      t.column :total, :string, :default => "6"
      t.column :name_inside_table, :boolean, :default => true
      t.column :data_column, :string, :default => "2"

      t.timestamps
    end
  end

  def self.down
    drop_table :hospitality_details
  end
end
