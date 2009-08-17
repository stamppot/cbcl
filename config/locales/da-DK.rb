I18n.backend.store_translations 'da-DK', 
  {
    :previous => 'Forrige',
    :next => 'Næste',
    :in_total => 'i alt',
    :of => 'af',
    
    # :domain => ENV["VIAVIA_DOMAIN"] + '.nl',
    :country => 'Danmark',
    :countries => {
      "The Netherlands" => "Holland",
      "Great Britain"   => "Storbritannien",
      "Denmark"         => "Danmark"  
    },
    :access => {
      :error => "Du har ikke adgang til denne side."
    },
    :site => {
      :test => {
        :lipsum_short => "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam ante eros, consectetur a, condimentum sit amet, eleifend vitae, arcu. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean et lectus ac eros auctor imperdiet. Donec a ante. In hac habitasse platea dictumst.",
        :lipsum => "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam ante eros, consectetur a, condimentum sit amet, eleifend vitae, arcu. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean et lectus ac eros auctor imperdiet. Donec a ante. In hac habitasse platea dictumst. Maecenas faucibus neque et odio. Cras pharetra arcu. Suspendisse ante. Mauris pellentesque enim vehicula ipsum placerat aliquam. Praesent sollicitudin purus nec est bibendum suscipit. Mauris sapien. Aenean tempus, purus lobortis volutpat consequat, felis eros rutrum pede, vitae hendrerit tellus pede ut eros. ",
      },
      
      ######################################
      ###### new layout localizations ######
      ######################################
      
      # homepage
      :login => {
        :login_on_viavia => "Login on Viavia",
        :lost_password => "Ik ben mijn wachtwoord verloren of kan niet inloggen",
        :login => "Inloggen",
        :retrieve_password => "Wachtwoord vergeten",
        :create_new_password => "Kies een nieuw wachtwoord voor ViaVia",
        :logged_out => "U bent nu uitgelogd",
        :login_successful => "Succesvol ingelogd",
        :invalid_activation_token => "Jouw account activatie token is niet geldig",
        :account_activated => "Jouw account is gëactiveerd",
        :expired_token => "Your lost password token has expired. Please apply for a new, and create a new password within 3 hours",
        :password_strength => "Wachtwoord sterkte",
        :password_weak => "Wachtwoord is onveilig",
        :tip => {
          :tips => "Hints: ",
          :password_too_short => "Password is too short",
          :password_add_number => "Add number",
          :password_add_uppercase => "Add uppercase letter",
          :password_add_symbol => "Add symbol"
        }
      },
      :dashboard => {
        :edit_profile => {
          :change_profile => "Profiel wijzigen",
        },
        :classified => {
          :edit => "Bewerken",
          :remove => "Verwijderen",
          :sold => "Verkocht",
        },
      },
      :faq => {
        :create_section => "Create new section",
        :post_question => "Post your question",
        :question => "Vraag",
        :answer => "Antwoord",
        :new_section => "New section",
        :index => "Index",
        :reorder_list => "Reorder list",
        :done_reordering => "Done!",
        :updated_section => "Updated FAQ section"
      },
      :admin => {
        :back_to_admin => "U bent opnieuw ingelogd in uw admin account",
        :logged_in_user => "You are logged in as another user",
        :cms => {
          "placeholder_destroyed" => 'Placeholder and Contents have successfully been deleted',
          "placeholder_destroy_error" => "Could not destroy placeholder"
        },
      },
      :user => {
        :activity_new => "{{time_in_words}} geleden geregistreerd",
      },
      
      ##### Classified Message Related #######
      :classified_messages => {
        :your_response_was_posted => "Je bericht is verstuurd naar {{full_name}}",
        :your_response_was_posted_and_account_created => "Je bericht is verstuurd naar {{full_name}}, er is automatisch een account voor je aangemaakt",
        :see_all_responses => "Bekijk alle berichten",
      },
      
      ######## Registration Related ##########
      :registration => {
        :registration_succesful => "Je bent nu geregisteerd, bedankt!",
      },
      
      ######### Classified Related ###########
      :classified => {
        :best_price => "Beste Prijs",
        :free => "Gratis",
      },
      
      :pagination => {
        "page current_pagex of total_pagesx" => "side {{current_page}} af {{total_pages}}",
        "previous" => "forrige",
        "next" => "næste"
        },
      },
  
   #start default rails translations  
   :support => {
     :array => {
       :sentence_connector => 'en'
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
       :half_a_minute => 'halve minuut',
       :less_than_x_seconds => {
         :one => 'korter dan 1 seconden',
         :other => 'korter dan {{count}} seconden',
       },
       :x_seconds => {
         :one => '1 seconde',
         :other => '{{count}} seconden',
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
       :inclusion => "komt niet voor in de lijst",
       :exclusion => "is gereserveerd",
       :invalid => "is ongeldig",
       :confirmation => "komt niet overeen met de bevestiging",
       :accepted  => "meot worden geaccepteerd",
       :empty => "kan niet leeg zijn",
       :blank => "kan niet leeg zijn",
       :too_long => "is te lang (maximum aantal karakters is {{count}})",
       :too_short => "is te kort (minimaal aantal karakters is {{count}})",
       :wrong_length => "heeft de verkeerde lengte (moet {{count}} karakter(s) zijn)",
       :taken => "is al in gebruik",
       :not_a_number => "is geen nummer",
       :greater_than => "moet groter zijn dan {{count}}",
       :greater_than_or_equal_to => "moet groter zijn dan of gelijk aan {{count}}",
       :equal_to => "moet gelijk zijn aan {{count}}",
       :less_than => "moet kleiner zijn dan {{count}}",
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
             # :id => 
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
