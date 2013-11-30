# # encoding: utf-8
# class PersonInfo < ActiveRecord::Base
#   belongs_to :journal, :touch => true

#   validates_presence_of :name, :message => "Navn skal angives"
#   validates_presence_of :sex, :message => "Køn skal angives"
#   validates_presence_of :nationality, :message => "Nationalitet skal angives"
#   validates_presence_of :journal_id

#   validates_format_of :parent_email, :with => /^(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})$/i  
  
#   before_save :set_cpr_nr
#   after_update :set_parent_delta

#   def set_parent_delta
#     self.journal.update_attributes(:delta => true)
#   end

#   # define_index do
#   #    indexes cpr, :sortable => true
#   #    set_property :delta => true
#   # end

#   def set_cpr_nr
#     dato = self.birthdate.to_s.split("-")
#     dato[0] = dato[0][2..3]
#     self.cpr = dato.reverse.join
#   end

#   def PersonInfo.sexes
#     {
#       'dreng' => 1,
#       'pige' => 2
#     }
#   end
  
#   def self.nationalities
#     Nationality.all
#   end

#   def sex_text
#     PersonInfo.sexes.invert[self.sex]
#   end
  
#   def age
#     ( (Date.today - self.birthdate).to_i / 365.25).floor
#   end


# end