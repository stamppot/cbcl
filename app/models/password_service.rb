class PasswordService
  
  def self.generate_password
    ord1 = words[srand % (words.size)]
    n1 = rand(10).to_s
    n2 = rand(10).to_s
    ord2 = words[srand % (words.size)]
    assword = { :password => ord1 + n1 + ord2 + n2, :password_confirmation => ord1 + n1 + ord2 + n2 }
  end
  
  def self.words
    return @@words
  end

  @@words = ["hest", "hund", "kat", "mus", "fugl", "fisk", "gris", "and", "dyr", "fod", "ben", "rod", "fest", "stik",
    "luft", "jord", "ild", "vand", "bord", "stol", "post", "sofa", "ske", "sok", "stok", "zoo", "bus", "bil", "have",
    "havn", "hav", "hval", "glas", "blad", "dam", "vej", "gade", "sti", "sten", "lava", "lys", "skov", "mark", "korn",
    "bane", "spil", "tand", "sand", "land", "taxi", "mose", "sild", "grus", "gave", "hus", "telt", "kalk", "quiz",
    "nys", "hjul", "kop", "krat", "hegn", "tegn", "hane", "sol", "sal", "siv", "tur", "tip", "tal", "ord", "bog",
    "gul", "gips", "tog", "jern", "guld", "blik", "blok", "pop", "pap", "bold", "arm", "kage", "seng", "klub",
    "vogn", "knap", "pen", "snip", "fin", "fon", "snap", "fan", "snup", "fun", "snep", "vest", "nord", "syd",
    "nest", "test", "gast", "gust", "hep", "hop", "hip", "pip", "hap", "pep", "hup", "hyp", "snyt", "snit", "tit",
    "fut", "tut", "rat", "rut", "ret", "tast", "sub    til", "told", "tran", "fup", "prop", "top", "tap", "stop",
    "stub", "stil", "stip", "spol", "spul", "brak", "nok", "kok", "kik", "ting", "tom", "bat", "bot", "bit",
    "nat", "dag", "hov", "hof", "bim", "bam", "bom", "bob", "bib", "bip", "pift", "fif", "nip", "nap", "nop",
    "nup", "flip", "flap", "flop"]

end