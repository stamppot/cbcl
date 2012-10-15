# class RemoteLinkRenderer < WillPaginate::LinkRenderer 
# 	def initialize(collection, options, template)
# 		@url = options.delete(:url) || {} 
# 		super 
# 	end 
	
# 	def page_link_or_span(page, span_class = 'current', text = nil) 
# 		text ||= page.to_s 
# 		if page and page != current_page 
# 			url_opts = url_options(page).except(:authenticity_token).merge(@url) 
# 			@template.link_to_remote(text, {:url => url_opts, :method => :get}) 
# 		else 
# 			@template.content_tag :span, text, :class => span_class 
# 		end
# 	end 
# end