module ExportHelper
  def finish_progress
    page.replace_html 'progress', :partial => 'download_file'
    page.assign 'generating_export', false
  end

  def update_progress
    page.insert_html :bottom, 'progress', '.'
    page.visual_effect :pulsate, 'progress'
  end

end
