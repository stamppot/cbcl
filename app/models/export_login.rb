class ExportLogin  #< ActiveRecord::Base
	attr_accessor :id, :navn, :fornavn, :email, :mor_navn, :alternativ_id
	attr_accessor :skema_1, :skema_1_login, :skema_1_password, :skema_1_dato, :skema_2, :skema_2_login, :skema_2_password, :skema_3, :skema_login, :skema_3_password, :skema_3_dato

	def initialize(o = {})
		@id = o[:id]
		@navn = o[:navn]
		@fornavn = o[:email]
		@id = o[:mor_navn]
		@id = o[:alternativ_id]
		@skema_1 = o[:skema_1]
		@skema_1_login = o[:skema_1_login]
		@skema_1_password = o[:skema_1_password]
		@skema_1_dato = o[:skema_1_dato]
		@skema_2 = o[:skema_2]
		@skema_2_login = o[:skema_2_login]
		@skema_2_password = o[:skema_2_password]
		@skema_2_dato = o[:skema_2_dato]
		@skema_3 = o[:skema_3]
		@skema_3_login = o[:skema_3_login]
		@skema_3_password = o[:skema_3_password]
		@skema_3_dato = o[:skema_3_dato]
	end
end