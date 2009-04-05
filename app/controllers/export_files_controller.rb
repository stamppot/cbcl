class ExportFilesController < ApplicationController

  #### list and download files ####

  def index
    EXPORT_FILES_STORAGE_PATH =~ /(\/files)/
    @file_path = $1 + "/"

    @files = ExportFile.find(:all)
  end

  def show
    @export_file = ExportFile.find(params[:id])
  end

  def download
    @file = ExportFile.find(params[:id])

    send_file(EXPORT_FILES_STORAGE_PATH + @file.filename, 
    :disposition => 'attachment',
    :encoding => 'utf8', 
    :type => @file.content_type,
    :filename => URI.encode(@file.filename))

    send_file(EXPORT_FILES_STORAGE_PATH + @file.filename, 
      :disposition => 'attachment',
      :encoding => 'utf8', 
      :type => @file.content_type,
      :filename => URI.encode(@file.filename))

    
    # respond_to do |wants|
    #   wants.html { render :text => @file.filename
    #   }
    #   wants.csv {
    #     send_file(EXPORT_FILES_STORAGE_PATH + @file.filename, 
    #     :disposition => 'attachment',
    #     :encoding => 'utf8', 
    #     :type => @file.content_type,
    #     :filename => URI.encode(@file.filename))
    #   }
    # end    
    
  rescue
    flash[:notice] = "Filen findes ikke"
    redirect_to export_files_path
  end
end

# #### upload files ####
# 
# def new
#   @upload_file = ExportFile.new
# end
# 
# def create
#   file_params = params[:upload_file]
#   if file_params[:file_data].blank?
#     flash[:error] = "A file must be selected"
#     render :action => :new and return
#   elsif file_params[:file_data].original_filename.length > 78
#     flash[:error] = "ExportFilename is too long. Shorten filename and try again"
#     render :action => :new and return
#   end
#   
#   @upload_file = ExportFile.new(:data => file_params[:file_data],
#                                 :filename => sanitize_filename(file_params[:file_data].original_filename),
#                                 :content_type => file_params[:file_data].content_type)
#   if @upload_file.save
#     flash[:notice] = 'ExportFile was successfully uploaded.'
#     redirect_to :action => 'list'
#   else
#     render :action => 'new'
#   end
# end
# 
# def edit
#   @upload_file = ExportFile.find(params[:id])
# end
# 
# def update
#   @upload_file = ExportFile.find(params[:id])
#   if @upload_file.update_attributes(params[:upload_file])
#     @upload_file.filename = sanitize_filename(params[:upload_file][:filename])
#     flash[:notice] = 'ExportFile was successfully updated.'
#     redirect_to :action => :show, :id => @upload_file
#   else
#     render :action => :edit
#   end
# end
# 
# def delete
#   file = ExportFile.find(params[:id])
#   if file.destroy
#     file.delete_file
#     flash[:notice] = "ExportFile was deleted"
#   end
#   redirect_to :action => 'list'
# 
# rescue ActiveRecord::RecordNotFound
#   flash[:notice] = "Error: file does not exist"
#   redirect_to :action => 'list'
# end    
#   
# def destroy
#   ExportFile.find(params[:id]).destroy
#   redirect_to :action => 'list'
# end
# 
# 
# private
# def sanitize_filename(file_name)
#   # get only the filename, not the whole path (from IE)
#   just_filename = ExportFile.basename(file_name).strip
#   # replace spaces with underscore
#   just_filename.gsub!(/s/,'_')
#   # replace all none alphanumeric, underscore or perioids with underscore
#   just_filename.gsub(/[^\w\.\_]/,'_') 
# end
# 
# end
