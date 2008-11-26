class CreateReports < ActiveRecord::Migration
  def self.up
    create_table :reports do |t|
      t.column :department_id, :integer
      t.column :url, :string
      t.column :name_format, :string
      t.column :report_format, :string
      t.column :report_name, :string
      t.column :person_name, :string
      t.column :person_position, :string
      t.column :first_t_expense_start, :string
      t.column :first_t_expense_end, :string
      t.column :first_t_expense_desc, :string
      t.column :first_t_expense_cost, :string
      t.column :first_h_expense_start, :string
      t.column :first_h_expense_end, :string
      t.column :first_h_expense_desc, :string
      t.column :first_h_expense_cost, :string
      t.column :completed, :bool
      t.timestamps
    end
  end

  def self.down
    drop_table :reports
  end
end
