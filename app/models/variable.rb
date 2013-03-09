class Variable < ActiveRecord::Base
  belongs_to :question
  belongs_to :survey
  validates_presence_of :var
  validates_presence_of :question
  validates_presence_of :survey
  validates_presence_of :col
  validates_presence_of :row
  validates_uniqueness_of :var
  # validates_uniqueness_of :survey, :scope => [:question, :col, :row], :message => 'A variable for this cell already exists'
  
  named_scope :and_survey, :include => :survey
  named_scope :and_question, :include => :question
  named_scope :for_survey, lambda { |survey_id| { :conditions => ["survey_id = ?", survey_id] } }
  named_scope :for_cell, lambda { |cell| { :conditions => ['question_id = ? and row = ? and col = ?', cell.question_id, cell.row, cell.col] } }

  attr_accessor :short, :value

  @@question_hash = nil
  @@survey_hash = nil

  @@survey_variables = {
    1 => "cci1;;cci2;;cci3;;cci4;;cci5;;cci6;;cci7;;cci8;;cci9;;cci10;;cci11;;cci12;;cci13;;cci14;;cci15;;cci16;;cci17;;cci18;;cci19;;cci20;;cci21;;cci22;;cci23;;cci24;;cci24hv;;cci25;;cci26;;cci27;;cci28;;cci29;;cci30;;cci31;;cci31hv;;cci32;;cci32hv;;cci33;;cci34;;cci35;;cci36;;cci37;;cci38;;cci39;;cci40;;cci41;;cci42;;cci43;;cci44;;cci45;;cci46;;cci46hv;;cci47;;cci48;;cci49;;cci50;;cci51;;cci52;;cci53;;cci54;;cci54hv;;cci55;;cci56;;cci57;;cci58;;cci59;;cci60;;cci61;;cci62;;cci63;;cci64;;cci65;;cci66;;cci67;;cci68;;cci69;;cci70;;cci71;;cci72;;cci73;;cci74;;cci74hv;;cci75;;cci76;;cci76hv;;cci77;;cci78;;cci79;;cci80;;cci80hv;;cci81;;cci82;;cci83;;cci84;;cci85;;cci86;;cci87;;cci88;;cci89;;cci90;;cci91;;cci92;;cci92hv;;cci93;;cci94;;cci95;;cci96;;cci97;;cci98;;cci99;;cci100;;cci100hv;;cchandic;;cchandhv;;ccbekyhv;;ccbedshv;;ccfodtid;;ccfoduge;;ccfodg;;ccorebet;;ccsproan;;ccsprohv;;cctale;;cctalehv;;ccsprobe;;ccsprobehv;;ccudvian",
    2 => "ccyspor;;ccyasp;;ccyaspt;;ccyaspg;;ccybsp;;ccybspt;;ccybspg;;ccycsp;;ccycspt;;ccycspg;;ccyhob;;ccyahob;;ccybhob;;ccychob;;ccyahobt;;ccybhobt;;ccychobt;;ccyahobg;;ccybhobg;;ccychobg;;ccyfo;;ccyafo;;ccybfo;;ccycfo;;ccyafog;;ccybfog;;ccycfog;;ccyjob;;ccyajob;;ccybjob;;ccycjob;;ccyajobg;;ccybjobg;;ccycjobg;;ccy1ven;;ccy2vea;;ccysos;;ccybor;;ccyfor;;ccyale;;ccysko;;ccyund;;calae;;casta;;camat;;canat;;caeng;;caan1;;caan2;;cavu1;;cavu2;;ctcundty;;ctcgomkl;;ctcgomhv;;ctcfagpro;;ctcfagprohv;;ctcfagho;;ccyhandic;;ccyhandhv;;ccybekyhv;;ccybedshv;;ccyx1;;ccyx2;;ccyx2hv;;ccyx3;;ccyx4;;ccyx5;;ccyx6;;ccyx7;;ccyx8;;ccyx9;;ccyx9hv;;ccyx10;;ccyx11;;ccyx12;;ccyx13;;ccyx14;;ccyx15;;ccyx16;;ccyx17;;ccyx18;;ccyx19;;ccyx20;;ccyx21;;ccyx22;;ccyx23;;ccyx24;;ccyx25;;ccyx26;;ccyx27;;ccyx28;;ccyx29;;ccyx29hv;;ccyx30;;ccyx31;;ccyx32;;ccyx33;;ccyx34;;ccyx35;;ccyx36;;ccyx37;;ccyx38;;ccyx39;;ccyx40;;ccyx40hv;;ccyx41;;ccyx42;;ccyx43;;ccyx44;;ccyx45;;ccyx46;;ccyx46hv;;ccyx47;;ccyx48;;ccyx49;;ccyx50;;ccyx51;;ccyx52;;ccyx53;;ccyx54;;ccyx55;;ccyx56a;;ccyx56b;;ccyx56c;;ccyx56d;;ccyx56dhv;;ccyx56e;;ccyx56f;;ccyx56g;;ccyx56h;;ccyx56hhv;;ccyx57;;ccyx58;;ccyx58hv;;ccyx59;;ccyx60;;ccyx61;;ccyx62;;ccyx63;;ccyx64;;ccyx65;;ccyx66;;ccyx66hv;;ccyx67;;ccyx68;;ccyx69;;ccyx70;;ccyx70hv;;ccyx71;;ccyx72;;ccyx73;;ccyx73hv;;ccyx74;;ccyx75;;ccyx76;;ccyx77;;ccyx77hv;;ccyx78;;ccyx79;;ccyx79hv;;ccyx80;;ccyx81;;ccyx82;;ccyx83;;ccyx83hv;;ccyx84;;ccyx84hv;;ccyx85;;ccyx85hv;;ccyx86;;ccyx87;;ccyx88;;ccyx89;;ccyx90;;ccyx91;;ccyx92;;ccyx92hv;;ccyx93;;ccyx94;;ccyx95;;ccyx96;;ccyx97;;ccyx98;;ccyx99;;ccyx100;;ccyx100hv;;ccyx101;;ccyx102;;ccyx103;;ccyx104;;ccyx105;;ccyx105hv;;ccyx106;;ccyx107;;ccyx108;;ccyx109;;ccyx110;;ccyx111;;ccyx112;;ccyx113hv",
    3 => "ctinst;;ctpasty;;ctpashv;;ctborn;;cttimer;;ctkendla;;ctkendgo;;cttraen;;cttraehv;;ctvii1;;ctvii2;;ctvii3;;ctvii4;;ctvii5;;ctvii6;;ctvii7;;ctvii8;;ctvii9;;ctvii10;;ctvii11;;ctvii12;;ctvii13;;ctvii14;;ctvii15;;ctvii16;;ctvii17;;ctvii18;;ctvii19;;ctvii20;;ctvii21;;ctvii22;;ctvii23;;ctvii24;;ctvii25;;ctvii26;;ctvii27;;ctvii28;;ctvii29;;ctvii30;;ctvii31;;ctvii31hv;;ctvii32;;ctvii32hv;;ctvii33;;ctvii34;;ctvii35;;ctvii36;;ctvii37;;ctvii38;;ctvii39;;ctvii40;;ctvii41;;ctvii42;;ctvii43;;ctvii44;;ctvii45;;ctvii46;;ctvii46hv;;ctvii47;;ctvii48;;ctvii49;;ctvii50;;ctvii51;;ctvii52;;ctvii53;;ctvii54;;ctvii54hv;;ctvii55;;ctvii56;;ctvii57;;ctvii58;;ctvii59;;ctvii60;;ctvii61;;ctvii62;;ctvii63;;ctvii64;;ctvii65;;ctvii66;;ctvii67;;ctvii68;;ctvii69;;ctvii70;;ctvii71;;ctvii72;;ctvii73;;ctvii74;;ctvii75;;ctvii76;;ctvii76hv;;ctvii77;;ctvii78;;ctvii79;;ctvii80;;ctvii80hv;;ctvii81;;ctvii82;;ctvii83;;ctvii84;;ctvii85;;ctvii86;;ctvii87;;ctvii88;;ctvii89;;ctvii90;;ctvii91;;ctvii92;;ctvii92hv;;ctvii93;;ctvii94;;ctvii95;;ctvii96;;ctvii97;;ctvii98;;ctvii99;;ctvii100;;ctvii100hv;;cthandic;;cthandhv;;ctbekyhv;;ctbedshv",
    4 => "ttkltrin;;ttskolen;;ttkent;;ttkend;;ttlekt;;ttundty;;ttcgomkl;;ttcgomhv;;talae;;tasta;;tamat;;tanat;;taeng;;taan1;;taan2;;tavu1;;tavu2;;ttarb;;ttopf;;ttind;;tthum;;tthandic;;ttbekyhv;;ttbedshv;;tt1;;tt2;;tt3;;tt4;;tt5;;tt6;;tt7;;tt8;;tt9;;tt9hv;;tt10;;tt11;;tt12;;tt13;;tt14;;tt15;;tt16;;tt17;;tt18;;tt19;;tt20;;tt21;;tt22;;tt23;;tt24;;tt25;;tt26;;tt27;;tt28;;tt29;;tt29hv;;tt30;;tt31;;tt32;;tt33;;tt34;;tt35;;tt36;;tt37;;tt38;;tt39;;tt40;;tt40hv;;tt41;;tt42;;tt43;;tt44;;tt45;;tt46;;tt46hv;;tt47;;tt48;;tt49;;tt50;;tt51;;tt52;;tt53;;tt54;;tt55;;tt56a;;tt56b;;tt56c;;tt56d;;tt56dhv;;tt56e;;tt56f;;tt56g;;tt56h;;tt56hhv;;tt57;;tt58;;tt58hv;;tt59;;tt60;;tt61;;tt62;;tt63;;tt64;;tt65;;tt66;;tt66hv;;tt67;;tt68;;tt69;;tt70;;tt70hv;;tt71;;tt72;;tt73;;tt73hv;;tt74;;tt75;;tt76;;tt77;;tt78;;tt79;;tt79hv;;tt80;;tt81;;tt82;;tt83;;tt83hv;;tt84;;tt84hv;;tt85;;tt85hv;;tt86;;tt87;;tt88;;tt89;;tt90;;tt91;;tt92;;tt93;;tt94;;tt95;;tt96;;tt97;;tt98;;tt99;;tt100;;tt101;;tt102;;tt103;;tt104;;tt105;;tt105hv;;tt106;;tt107;;tt108;;tt109;;tt110;;tt111;;tt112;;tthv",
    5 => "ycyspor;;ycyasp;;ycyaspt;;ycyaspg;;ycybsp;;ycybspt;;ycybspg;;ycycsp;;ycycspt;;ycycspg;;ycyhob;;ycyahob;;ycybhob;;ycychob;;ycyahobt;;ycybhobt;;ycychobt;;ycyahobg;;ycybhobg;;ycychobg;;ycyfo;;ycyafo;;ycybfo;;ycycfo;;ycyafog;;ycybfog;;ycycfog;;ycyjob;;ycyajob;;ycybjob;;ycycjob;;ycyajobg;;ycybjobg;;ycycjobg;;ycyen1;;ycyea2;;ycysos;;ycybor;;ycyfor;;ycyale;;yalae;;yasta;;yamat;;yanat;;yaeng;;yaan1;;yaan2;;yavu1;;yavu2;;ycy1;;ycy2;;ycy2hv;;ycy3;;ycy4;;ycy5;;ycy6;;ycy7;;ycy8;;ycy9;;ycy9hv;;ycy10;;ycy11;;ycy12;;ycy13;;ycy14;;ycy15;;ycy16;;ycy17;;ycy18;;ycy19;;ycy20;;ycy21;;ycy22;;ycy23;;ycy24;;ycy25;;ycy26;;ycy27;;ycy28;;ycy29;;ycy29hv;;ycy30;;ycy31;;ycy32;;ycy33;;ycy34;;ycy35;;ycy36;;ycy37;;ycy38;;ycy39;;ycy40;;ycy40hv;;ycy41;;ycy42;;ycy43;;ycy44;;ycy45;;ycy46;;ycy46hv;;ycy47;;ycy48;;ycy49;;ycy50;;ycy51;;ycy52;;ycy53;;ycy54;;ycy55;;ycy56a;;ycy56b;;ycy56c;;ycy56d;;ycy56dhv;;ycy56e;;ycy56f;;ycy56g;;ycy56h;;ycy56hhv;;ycy57;;ycy58;;ycy58hv;;ycy59;;ycy60;;ycy61;;ycy62;;ycy63;;ycy64;;ycy65;;ycy66;;ycy66hv;;ycy67;;ycy68;;ycy69;;ycy70;;ycy70hv;;ycy71;;ycy72;;ycy73;;ycy74;;ycy75;;ycy76;;ycy77;;ycy78;;ycy79;;ycy79hv;;ycy80;;ycy81;;ycy82;;ycy83;;ycy83hv;;ycy84;;ycy84hv;;ycy85;;ycy85hv;;ycy86;;ycy87;;ycy88;;ycy89;;ycy90;;ycy91;;ycy92;;ycy93;;ycy94;;ycy95;;ycy96;;ycy97;;ycy98;;ycy99;;ycy100;;ycy100hv;;ycy101;;ycy102;;ycy103;;ycy104;;ycy105;;ycy105hv;;ycy106;;ycy107;;ycy108;;ycy109;;ycy110;;ycy111;;ycy112"
  }
  
  def self.survey_variables(survey_id = nil)
    if survey_id
      @@survey_variables[survey_id]
    else
      @@survey_variables
    end
  end

	def question_cell
		question.question_cells.select { |qc| qc.row == self.row && qc.col == self.col}.first
	end
	
  # order in hash by hash[by][row][col], where by is by default survey_id or question_id
  def self.all_in_hash(options = {})
    by_id = options[:by] || 'survey_id'

    if by_id == 'question_id'
      return @@question_hash if @@question_hash
    else
      return @@survey_hash if @@survey_hash
    end
    
    vars = self.all(:order => "#{by_id}, row")    

    if by_id == 'question_id'
      vars.inject({}) do |h, elem|
        h[elem.question_id] = { elem.row => { elem.col => elem } } if !h.key? elem.question_id
        h[elem.question_id][elem.row] = { elem.col => elem } if !h[elem.question_id].key? elem.row
        h[elem.question_id][elem.row].merge!({ elem.col => elem })
        h
      end
    else
      vars.inject({}) do |h, elem|
        h[elem.survey_id] = { elem.row => { elem.col => elem } } if !h.key? elem.survey_id
        h[elem.survey_id][elem.row] = { elem.col => elem.var } if !h[elem.survey_id].key? elem.row
        h[elem.survey_id][elem.row].merge!({ elem.col => elem })
        h
      end
    end
  end
  
  def self.get_by_question(question, row, col)
    @@question_hash ||= self.all_in_hash({:by => 'question_id'})
    
    if (s = @@question_hash[question]) && (the_row = s[row]) # && (the_col = the_row[col])
      var = the_row[col]
    end
  end

  def self.get_by_survey(survey, row, col)
    @@survey_hash ||= self.all_in_hash
    
    if (q = @@survey_hash[question]) && (the_row = q[row]) # && (the_col = the_row[col])
      var = the_row[col]
    end
  end


end
