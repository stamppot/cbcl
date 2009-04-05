class ExportFile < ActiveRecord::Base 

  has_one :task
  
  EXPORT_FILES_STORAGE_PATH = "#{RAILS_ROOT}/files"

  # run write_file after save to db
  after_save :write_file
  
  # run delete_file method after removal from db
  after_destroy :delete_file
  
  # setter for form file field "cover" 
  # grabs the data and sets it to an instance variable.
  # we need this so the model is in db before file save,
  # so we can use the model id as filename.
  def data=(file_data)
    @file_data = file_data
  end
  
  # write the @file_data data content to disk,
  # saves the file with the filename of the model id
  # together with the file original extension
  def write_file
    if @file_data
      File.open("#{EXPORT_FILES_STORAGE_PATH}/#{filename}", "w") { |file| file.write(@file_data) }
    end
  end
  
  # deletes the file(s) by removing the whole dir
  def delete_file
    FileUtils.rm_rf("#{EXPORT_FILES_STORAGE_PATH}/#{filename}")
  end
  
  # just gets the extension of uploaded file
  def extension
    @file_data.original_filename.split(".").last
  end
  
  def self.sanitize_filename(file_name)
    # get only the filename, not the whole path (from IE)
    just_filename = File.basename(file_name).strip
    # replace spaces with underscore
    just_filename.gsub!(/s/,'_')
    # replace all none alphanumeric, underscore or perioids with underscore
    just_filename.gsub(/[^\w\.\_]/,'_') 
  end
  
end