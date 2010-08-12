module Tinymce::Hammer

  mattr_accessor :install_path, :src, :languages, :themes, :plugins, :setup

  @@install_path = '/javascripts/tiny_mce'

  @@src = false

  @@setup = nil

  @@plugins = ['paste']

  @@languages = ['en']

  @@themes = ['advanced']

  @@init = [
    [:paste_convert_headers_to_strong, true],
    [:paste_convert_middot_lists, true],
    [:paste_remove_spans, true],
    [:paste_remove_styles, true],
    [:paste_strip_class_attributes, true],
    [:theme, 'advanced'],
    [:theme_advanced_toolbar_align, 'left'],
    [:theme_advanced_toolbar_location, 'top'],
    [:theme_advanced_buttons1, 'undo,redo,cut,copy,paste,pastetext,|,bold,italic,strikethrough,blockquote,charmap,bullist,numlist,removeformat,|,link,unlink,image,|,cleanup,code'],
    [:theme_advanced_buttons2, ',hr,formatselect,fontselect,fontsizeselect,'],
    [:theme_advanced_buttons3, ''],
    [:theme_advanced_fonts, "Andale Mono=andale mono,times;"+
    		"Arial=arial,helvetica,sans-serif;"+
    		"Arial Black=arial black,avant garde;"+
    		"Book Antiqua=book antiqua,palatino;"+
    		"Comic Sans MS=comic sans ms,sans-serif;"+
    		"Courier New=courier new,courier;"+
    		"Georgia=georgia,palatino;"+
    		"Helvetica=helvetica;"+
    		"Impact=impact,chicago;"+
    		"Symbol=symbol;"+
    		"Tahoma=tahoma,arial,helvetica,sans-serif;"+
    		"Terminal=terminal,monaco;"+
    		"Times New Roman=times new roman,times;"+
    		"Trebuchet MS=trebuchet ms,geneva;"+
    		"Verdana=verdana,geneva;"+
    		"Webdings=webdings;"+
    		"Wingdings=wingdings,zapf dingbats"],
    [:valid_elements, "a[href|title],blockquote[cite],br,caption,cite,code,dl,dt,dd,em,i,img[src|alt|title|width|height|align],li,ol,p,pre,q[cite],small,strike,strong/b,sub,sup,u,ul"],
  ]

  def self.init= js
    @@init = js
  end

  def self.init
    @@init
  end

  def self.url_path
    "#{ActionController::Base.relative_url_root}#{@@install_path}"
  end

end
