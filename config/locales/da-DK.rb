I18n.backend.store_translations 'da-DK', 
  {
		:id => 'Id',
    :show => 'Vis',
    :edit => 'Rediger',
    :update => 'Opdater',
    :delete => 'Slet',
    :create => 'Opret',
    :add => 'Tilføj',
    :cancel => 'Afbryd',
    :save => 'Gem',
    :save_changes => 'Gem ændringer',
    :info => "Info",
    :change_password => 'Du skal skifte dit password',
    :logout_question => 'Er du sikker på at du vil logge ud?',
    :password => {
      :suggest => "Foreslå password"
    },
    :status => {
	    :created => 'Oprettet',
	    :updated => 'Opdateret',
	    :answered => 'Besvaret',
		},
    :login_label => 'Login',
    :yes => 'Ja',
    :no => 'Nej',
    :user_id => 'ID',
		:name => 'Navn',
		:code => 'Kode',
		:gender => 'Køn',
    :birthdate => 'Fødselsdato',
    :age => 'Alder',
		:nationality => 'Nationalitet',
    :Roles => 'Roller',
    :role => 'Rolle',
    :no_roles => 'Ingen Roller',
    :groups => 'Grupper',
    :group => 'Gruppe',
    :no_groups => 'Ingen Grupper',
    :menu => {
      :info => 'Info',
      :groups => 'Grupper',
      :search_groups => 'Søg:',
      :center => 'Center',
      :centers => 'Centre',
      :teams => 'Teams',
      :users => 'Brugere',
      :show_users => 'Vis Brugere',
      :create_user => 'Tilføj Bruger',
      :search_users => 'Søg:',
      :surveys => 'Spørgeskemaer',
      :show_surveys => 'Vis Spørgeskemaer',
			:survey_stats => 'Tællere',
      :subscriptions => 'Abonnementer',
      :show_subscriptions => 'Vis Abonnementer',
      :scores => 'Scores',
      :scores_alt => 'Scoreberegninger',
      :data_export => 'Dataudtræk',
      :journals => 'Journaler',
      :search_journals => 'Søg:',
      :show_journals => 'Vis Journaler',
      :create_journal => 'Opret Journal',
      :settings => 'Indstillinger', # nationaliteter og skemavariabler
      :nationalities => 'Nationaliteter',
      :variables => 'Skemavariabler',
      :letters => 'Breve',
      :other => 'Andet',
      :faq_alt => 'Spørgsmål & Svar',
      :show_faq => 'Hjælp',
      :change_password => 'Skift password',
      :change_password_alt => 'Skift password, det tager kun et øjeblik'
    },
    :center => {
      :center => 'Center',
      :centers => 'Centre',
      :show => 'Vis Center',
      :list => 'Vis Centre',
      :edit => 'Rediger Center',
      :new  => 'Opret Center', 
      :delete => 'Slet Center',
    	:email => 'Email',
			:name => 'Navn',
			:code => 'Centerkode',
    	:address => 'Adresse',
    	:phone => 'Telefon',
    	:city => 'By',
    	:contactperson => 'Kontaktperson',
    	:companynumber => 'EAN-nr'
    },
    :team => {
      :team => 'Team',
      :teams => 'Teams',
      :show => 'Vis Team',
      :list => 'Vis Teams',
      :edit => 'Rediger Team',
      :new =>  'Opret Team',
      :admins => 'Teamadministrator',
      :move => 'Flyt journaler'
    },
    :user => {
      :user => 'Bruger',
      :users => 'Brugere',
      :show => 'Vis Bruger',
      :list => 'Vis Brugere',
      :edit => 'Rediger Bruger',
      :new  => 'Opret Bruger',
      :new_in => "Opret bruger til ",
      :delete => 'Slet Bruger',
      :Login => 'Loginnavn',
    	:email => 'Email',
      :last_login => 'Seneste Login',
      :State => 'Status',
      :id => 'ID',
      :states => {
        '1' => 'ubekræftet',
        '2' => 'bekræftet',
        '3' => 'låst',
        '4' => 'slettet',
        '5' => 'retrieved_password',
          # The user has just retrieved his password and he must now
          # it. The user cannot anything in this state but change his
          # password after having logged in and retrieve another one.
        '6' => 'retrieved_password',
      },
      :center => {
        :admin => "Opret Centeradministrator"
      }
    },
    :journal => {
      :journals => "Journaler",
      :show => 'Vis Journal',
      :list => 'Vis Journaler',
      :edit => 'Rediger Journal',
      :new  => 'Opret Journal', 
      :delete => 'Slet Journal',
      :move => 'Flyt til team'
    },
    :survey => {
      :new => 'Nyt spørgeskema',
      :edit => 'Rediger spørgeskema',
      :show => 'Vis spørgeskema',
      :add_question => 'Tilføj spørgsmål',
      :start => "Start",
      :change_answer => "Ændre svar",
      :survey => 'Spørgeskema',
      :answered => "Besvarede skemaer",
      :add => 'Tilføj spørgeskemaer',
      :remove => 'Fjern spørgeskemaer',
      :input => 'Normal indtastning',
      :fast_input => 'Hurtig indtastning'
    },
    :letter => {
      :letters => 'Breve',
      :new => 'Opret brev',
      :edit => 'Ret brev',
      :show => 'Vis brev',
      :delete => 'Slet brev',
      :login => 'Loginbrev',
			:print => 'Udskriv breve',
      :all_centers => 'Alle centre',
      :confirm => 'Er du sikker på, at du vil slette brevet?'
    },
    :subscription => {
      :subscribe => 'Abonner',
      :change_subscription => 'Ændre abonnementer',
      :new => 'Nyt abonnement',
      :pay => 'Betal',
      :pay_surveys => 'Sæt skemaer til betalt',
      :new_period => 'Begynd ny periode',
      :merge_periods => 'Slå sammen',
      :merge_periods_title => 'Slå periode sammen med forrige',
      :undo_payment => 'Fortryd sidste betaling',
      :list => "Liste af abonnementer",
      :none => "Ingen abonnementer",
      :none_for_this_survey => "Centret abbonnerer ikke på dette spørgeskema.",
      :expired => "Dit abonnement er udløbet. Kontakt CBCL-SDU.",
      :overview => "Oversigt",
      :details => "Detaljer"
    },
    
    :score => {
      :calculate => 'Beregn score',
      :add_ref => 'Tilføj referenceværdi',
      :add_item => 'Tilføj beregning'
    },

    :score_scale => {
      :new => 'Opret ny skala',
      :done => 'Færdig!',
      :reorder => 'Organiser liste'
    },
    
    :export => {
      :logins => 'Eksporter login-data',
      :data => 'Dataudtræk'
    },
    
    :variable => {
      :new => 'Ny variabel',
      :create  => 'Opret',
      :show => 'Vis'
    },
    
    :sort => {
      :name => 'Sorter efter navn',
      :role => 'Sorter efter rolle',
      :group => 'Sorter efter gruppe',
      :state => 'Sorter efter status',
      :age => 'Sorter efter alder'
    },
    
    :login => {
      :login => 'Log ind',
      :wrong => 'Forkert brugernavn eller password'
    },
    
    :follow_link => 'følge dette link',  # ??
    :goto_login => "Gå til login-side",

    :shadow_login_alt => 'Login som denne bruger',
    :last_login => 'Seneste Login',
    :logout => 'Log ud',
    :logout_alt => 'Log ud af systemet',
    :logout_shadow => 'Gå tilbage til egen bruger',
    :logout_please => 'Log venligst ud af systemet og log ind igen ved at trykke',
    :finish => 'Afslut',
    
    :previous => 'Forrige',
    :next => 'Næste',
    :in_total => 'i alt',
    :of => 'af',
    :here => 'her',
    :none => 'Ingen',
    :are_you_sure => 'Er du sikker?',
    :go_back => 'Tilbage',
    :go_back_to_list => 'Tilbage til liste',
    :go_back_to_journal => 'Tilbage til journal',
    :action => 'Handling',
    :state => 'Status',
    :total => 'Total',
    :show_hide => "Vis/gem detaljer",
    :filelist => 'Filliste',
    :filename => 'Filnavn',
    :thedate => 'Dato',
    :type => 'Type',
    
    # :domain => ENV["VIAVIA_DOMAIN"] + '.nl',
    :country => 'Danmark',
    :access => {
      :error => "Du har ikke adgang til denne side."
    },

    :roles => {
      :roles =>     "roller",
      :Roles =>     "Roller",
      :superadmin => "superadmin",
			:data => "dataudtræk",
      :admin => "dataudtræk",
      :centeradministrator => "centeradministrator",
      :centeradmin => "centeradministrator",
      :teamadministrator => "teamadministrator",
      :teamadmin => "teamadministrator",
      :behandler => "behandler",
      :login_bruger => "login_bruger",
      :parent =>    "forælder",
      :youth =>     "barn",
      :teacher =>   "lærer",
      :pedagogue => "pædagog",
      :other =>     "andet"
    },

    :site => {
      ######################################
      ###### new layout localizations ######
      ######################################
      
      # homepage
      :faq => {
        :create_section => "Create new section",
        :post_question => "Post your question",
        :question => "Question",
        :answer => "Svar",
        :new_section => "Ny sektion",
        :index => "Index",
        :reorder_list => "Reorder list",
        :done_reordering => "Done!",
        :updated_section => "Updated FAQ section"
      },
    },
  
   #start default rails translations  
   :support => {
     :array => {
       :sentence_connector => 'og'
     }
   },
   :time => {
     :formats => {
       :default => "%e %B %Y %H:%M",
       :short => "%d %b %H:%M",
       :long => "%a %e %B %Y %H:%M",
     },
     :am => "am",
     :pm => "pm",
   },
   :date => {
     :formats => {
       :default => "%d-%m-%Y",
       :long => "%e %B %Y",
       :short => "%d %b",
       :normal => "%d %m %y",
     },
     :abbr_day_names => %w{søn man tir ons tor fre lør},
     :day_names => %w{søndag mandag tirsdag onsdag torsdag fredag lørdag},
     :abbr_month_names => %w{~ jan feb mar apr maj jun jul aug sep okt nov dec},
     :month_names => %w{~ januar februar marts april maj juni juli august september oktober november december},
     :order => [:year, :month, :day]
   },
   :datetime => {
     :distance_in_words => {
       :half_a_minute => 'halvt minut',
       :less_than_x_seconds => {
         :one => 'mindre end 1 sekund',
         :other => 'mindre end {{count}} sekunder',
       },
       :x_seconds => {
         :one => '1 sekund',
         :other => '{{count}} sekunder',
       },
       :less_than_x_minutes => {
         :one => 'minder dan 1 minuut',
         :other => 'minder dan {{count}} minuten',
       },
       :x_minutes => {
         :one => '1 minuut',
         :other => '{{count}} minuten',
       },
       :about_x_hours => {
         :one => 'ongeveer 1 uur', 
         :other => 'ongeveer {{count}} uur',
       },
       :x_days => {
         :one => '1 dag',
         :other => '{{count}} dagen',
       }, 
       :about_x_months => {
         :one => 'ongeveer 1 maand',
         :other => 'ongeveer {{count}} maanden',
       },
       :x_months => {
         :one => '1 maand',
         :other => '{{count}} maanden',
       },
       :about_x_years => {
         :one => 'ongeveer 1 jaar',
         :other => 'ongeveer {{count}} jaar',
       },
       :over_x_years => {
         :one => 'lander dan 1 jaar',
         :other => 'langer dan {{count}} jaar',
       }
     }
   },
   :number => {
     :format => {
       :separator => ',',
       :delimiter => '.'
     },
     :currency => {
       :format      => {
         :unit      => '&euro;',
         :precision => 2,
         :separator => ',',
         :delimiter => '.',
         :format    => '%u%n',
       }
     },
   },
   :lang => {
     "French"  => "Fransk", 
     "German"  => "Tysk",
     "Dutch"   => "Hollandsk", 
     "English" => "Engelsk"
   },
   :active_record => {
     :error_messages => {
       :inclusion => "findes ikke i listen",
       :exclusion => "er reserveret",
       :invalid => "er ugyldig",
       :confirmation => "komt niet overeen met de bevestiging",
       :accepted  => "meot worden geaccepteerd",
       :empty => "kan niet leeg zijn",
       :blank => "kan niet leeg zijn",
       :too_long => "is te lang (maximum aantal karakters is {{count}})",
       :too_short => "er for kort (minimum antal tegn er {{count}})",
       :wrong_length => "heeft de verkeerde lengte (moet {{count}} karakter(s) zijn)",
       :taken => "er allerede i brug",
       :not_a_number => "er ikke et nummer",
       :greater_than => "moet groter zijn dan {{count}}",
       :greater_than_or_equal_to => "moet groter zijn dan of gelijk aan {{count}}",
       :equal_to => "lig med {{count}}",
       :less_than => "mindre end {{count}}",
       :less_than_or_equal_to => "moet kleiner zijn dan of gelijk aan {{count}}",
       :odd => "moet oneven zijn",
       :even => "moet even zijn"
     },
     :error            => {
       :header_message => ["1 error prohibited this {{object_name}} from being saved", "{{count}} fout(en) heeft er voor gezorgd dat {{object_name}} niet is opgeslagen"],
       :message        => "Er zijn problemen met de volgende velden:"
     }            
   },
   
   # ActiveRecord error messages
   :activerecord => {
     :attributes => {
       :journal => {
         :name => "Navn",
         :title => "Navn",
         :code => "ID"
       },
       :team => {
         :code => "Teamkode",
         :title => "Navn"
       },
       :center => {
         :code => "Centerkode",
         :title => "Navn"
       },
       :user => {
         :name => "Navn",
         :login => "Login",
         :groups => "Center eller team",
         :roles => "Roller"
         
       }
     },
     :errors => {
       :template => {
         :header => "Fejl",
         :body => "Et eller flere felter er ikke udfyldt korrekt."
         },
         :models => {
           :user => {
             :attributes => {
                :email => {
                  :blank => "Email skal angives",
                  :invalid => "Ugyldig email-adresse",
                  :taken => "Denne email-adresse bruges af en anden bruger"
                  },
                :name => {
                  :blank => "Navn skal angives",
                  :too_short => "Navn skal være på minimum fire bogstaver",
                  :too_long => "Navn må maksimalt være 50 bogstaver"
                  },
                :login => {
                  :blank => "Login skal angives",
                  :too_short => "Login skal være på minimum fire bogstaver",
                  :too_long => "Login må maksimalt være 50 bogstaver"
                  },
                :password => {
                  :empty => "Password skal angives",
                  :invalid_length => "Password skal være mellem 6 og 20 tegn",
                  :confirmation_does_not_match => "Bekræftelsen af password er forskellig fra password",
                  :confirmation => "Bekræftelse er forkert"
                },
                :groups => {
                  :blank => "Center eller team skal vælges"
                },
                :roles => {
                  :blank => "skal angives"
                }
              },
            },
            :center => {
              :attributes => {
                :code => {
                  :invalid => "skal være på 4 cifre"
                },
              }
            },
            :journal => {
              :attributes => {
                :code => {
                  :taken => "er allerede i brug. Vælg andet ID."
                },
                :person_info => {
                  :blank => {
                    :Sex => "skal angives"
                  },
                },
                :nationality => {
                  :blank => "skal angives" 
                }
              }
            }
         },
          # login errors
        :login => {
          :email_or_password_not_correct => "Brugernavn eller password er forkert. Prøv igen",
          :blocked_account => "{{countx}} forkerte loginforsøg. Din konto er blokkeret i {{hours}} timer",
        },
         :journal => {
           :attributes => {
             :name => {
               :blank => "skal angives"
             },
             :code => {
               :blank => "ID skal angives",
               :taken => "bruges allerede. Vælg andet ID."
             },
             :sex => "Dreng eller pige skal angives",
             :center => {
               :blank => "TOM! Et center skal angives",
               :do_not_exist => "Centeret eksisterer ikke"
             },
             :parent => {
               :blank => "En gruppe skal angives",
             },
             :person_info => {
               :birthdate => "tjah",
               :nationality => "Nationalitet skal angives",
               :name => "Navn skal angives"
             }
           }
         },
         :center => {
           :attributes => {
             :title => {
               :blank => "Titel skal angives",
               :too_short => "Titel skal være mindst 5 bogstaver",
               :too_long => "Titel skal være højst 100 bogstaver",
             },
             :code => {
               :blank => "Centerkode skal angives",
               :taken => "Centerkode bruges af andet center",
               :invalid => "Centerkode skal være på 4 cifre"
             }  
           }
         },
         :team => {
           :attributes => {
             :title => {
               :blank => "Titel skal angives",
               :too_short => "Titel skal være mindst 5 bogstaver",
               :too_long => "Titel skal være højst 100 bogstaver",
             },
           }
         }
       }
     }
   }
