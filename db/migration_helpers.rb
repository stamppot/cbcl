# a mixin module for adding foreign keys to MySQL databases during migrations.
module MigrationHelpers
  # adds a foreign key to the table.
  # Parameters:
  # table_name - the name of the table to add to
  # association_name - the name of the constraint to add to the database
  # local_column - the column in table_name that contains the key
  # foreign_table - the name of the foreign table to reference
  # foreign_column - the name of the primary key in the foreign table
  # options - an optional hash with additional parameters for the 
  #   constraint. If the following hash values are present, then the 
  #   additional constraints will be specified:
  #   - on_delete: specify "cascade" or "set null"
  #   - on_update: specify "cascade" or "set null"
  def add_foreign_key(table_name, constraint_name, local_column, 
                      foreign_table, foreign_column, options = {})
    st = "ALTER TABLE #{table_name} ADD CONSTRAINT #{constraint_name} "
    st += "FOREIGN KEY (#{local_column}) REFERENCES #{foreign_table} (#{foreign_column})"
    if options.has_key?(:on_delete)
      st += " ON DELETE #{options[:on_delete]}"
    end
    if options.has_key?(:on_update)
      st += " ON UPDATE #{options[:on_update]}"
    end
    execute st
  end

  # removes a foreign key constraint from a table. This will NOT delete the 
  # column in the table, it only deletes the constraint
  # Parameters:
  #   table_name - the name of the table to remove the foreign key contstraint 
  #                from
  #   constraint_name - the name of the constraint on the table to delete
  def remove_foreign_key(table_name, constraint_name)
    st = "ALTER TABLE #{table_name} DROP FOREIGN KEY #{constraint_name}"
    execute st
  end
end