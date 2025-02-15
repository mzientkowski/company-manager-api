class CreateImports < ActiveRecord::Migration[8.0]
  def up
    create_enum :import_status, %w[pending running completed failed]

    create_table :imports, id: :uuid do |t|
      t.enum :status, enum_type: :import_status, null: false, default: 'pending'
      t.integer :total_count, null: false, default: 0
      t.integer :imported_count, null: false, default: 0
      t.integer :failed_count, null: false, default: 0

      t.text :error_log, array: true, default: []

      if connection.supports_datetime_with_precision?
        t.datetime :started_at, precision: 6
        t.datetime :completed_at, precision: 6
      else
        t.datetime :started_at
        t.datetime :completed_at
      end

      t.timestamps
    end

    add_index :imports, :status
  end

  def down
    drop_table :imports
    execute <<-SQL
      DROP TYPE import_status;
    SQL
  end
end
