class PersonInfo < ActiveRecord::Base
  belongs_to :journal

  validates_presence_of :name, :message => "Navn skal angives"
  validates_presence_of :sex, :message => "Køn skal angives"
  validates_presence_of :nationality, :message => "Nationalitet skal angives"


  def PersonInfo.sexes
    {
      'dreng' => 1,
      'pige' => 2
    }
  end
  
  def self.nationalities
    Nationality.find :all
  end

  def sex_text
    PersonInfo.sexes.invert[self.sex]
  end
  
  def age
    ( (Date.today - self.birthdate).to_i / 365.25).floor
  end


end