/* Pop-Up Calendar Built from Scratch by Marc Grabanski */
/* ported to prototype dependency and drastically reduced the number of observers */
/* current version unmaintained; porting by Jiju Thomas Mathew; http://www.saturn.in */

popUpCal = Class.create();

popUpCal.prototype = {
    selectedMonth: new Date().getMonth(), // 0-11
    selectedYear: new Date().getFullYear(), // 4-digit year
    selectedDay: new Date().getDate(),
    calendarId: 'calendarDiv',
    inputClass: 'datePick',
    minDate: null,
    maxDate: null,

	initialize: function () {
        var x = $$('.'+this.inputClass);
        this.minDate = new Date(1990, 1, 1, 12, 1, 1, 1);
        this.maxDate = new Date(this.minDate.getTime() + (364 * 24 * 60 * 60 * 1000));
        if(calendarConfig !== undefined){
            if(calendarConfig.inputClass !== undefined)
                this.inputClass = calendarConfig.inputClass;
            if(calendarConfig.minDate !== undefined)
                this.minDate = calendarConfig.minDate;
            if(calendarConfig.maxDate !== undefined)
                this.maxDate = calendarConfig.maxDate;
        }
        this.inputObj = null;
        if(!$(this.calendarId)){
            var p = '';
            if(Prototype.Browser.IE){
               p = '<iframe id="' + this.calendarId + 'Frame" src="about:blank" frameborder="0" style="display:none"></iframe>';
            }
            p += '<div id="' + this.calendarId + '" class="isCalendarArea"></div>';
            new Insertion.Bottom($$('body')[0], p);
        }
        
        // set the calendar position based on the input position
        for (var i=0; i<x.length; i++) {
           x[i].addClassName('isCalendarArea');
           Event.observe(x[i], 'focus', this.popupCalendar.bindAsEventListener(this));
        }
        Event.observe(document, 'click', this.calendarClose.bindAsEventListener(this));
        Event.observe(this.calendarId, 'click', this.calendarClicked.bindAsEventListener(this));
    },
    calendarClicked: function (evt){
        cElem = Event.element(evt);
        var evDone = false;
        if(cElem.hasClassName('monthNav')){
            if(cElem.id.toString() == 'prevMonth')
                this.eventPrevMonth();
            else
                this.eventNextMonth();
        }else if(cElem.hasClassName('sD')){
            this.selectedDay = cElem.innerHTML;
            this.inputObj.value = formatDate(this.selectedDay, this.selectedMonth, this.selectedYear);		
            this.closeCalendar();
        }
        Event.stop(evt);
    },
    calendarClose: function (evt){
        cElem = Event.element(evt);
        if(cElem.hasClassName('isCalendarArea') == false){
            this.closeCalendar();
        }else
            this.calendarClicked(evt);
    },
    closeCalendar: function(){
        $(this.calendarId).hide();
        if(Prototype.Browser.IE){
            $(this.calendarId + 'Frame').hide();
        }    
    },
    popupCalendar: function (evt) {
        this.inputObj = Event.element(evt);
        this.selectedMonth = new Date().getMonth();
        this.setPos(Event.element(evt)); 
        this.drawCalendar();
    },
    setPos: function(inputObj){
        $(this.calendarId).absolutize();
        var tPos = $(inputObj).cumulativeOffset();
        var tHeight = $(inputObj).getHeight();
        $(this.calendarId).setStyle({left: tPos.left + 'px', top: (tPos.top + tHeight) + 'px'});
        $(this.calendarId).show();
        if(Prototype.Browser.IE){
           $(this.calendarId).setStyle({zIndex: 99});
           $(this.calendarId + 'Frame').absolutize();
           $(this.calendarId + 'Frame').setStyle({left: tPos.left + 'px', top: (tPos.top + tHeight) + 'px'});
           $(this.calendarId + 'Frame').show();
        }   
    },
    drawCalendar: function () {
		
		var html = '';
		html += '<table id="calendar" cellpadding="0" cellspacing="0"><tr>';
		html += '<th colspan="7" class="calendarHeader">'
		html += '<table cellpadding="0" cellspacing="0" width="100%"><tr><td><a id="prevMonth" class="monthNav">&laquo;</a></td>';
		html += '<td><a class="calTitle">' +getMonthName(this.selectedMonth)+' '+this.selectedYear+ '</a></td>';
		html += '<td><a id="nextMonth" class="monthNav">&raquo;</a></td></tr></table></th>';
		html += '</tr><tr class="weekDaysTitleRow">';
        var weekDays = new Array('S','M','T','O','T','F','L');
        for (var j=0; j<weekDays.length; j++) {
			html += '<td>'+weekDays[j]+'</td>';
        }
		
        var daysInMonth = getDaysInMonth(this.selectedYear, this.selectedMonth);
        var startDay = getFirstDayofMonth(this.selectedYear, this.selectedMonth);
        var numRows = 0;
        var printDate = 1;
        if (startDay != 7) {
            numRows = Math.ceil(((startDay+1)+(daysInMonth))/7); // calculate the number of rows to generate
        }
		
        // calculate number of days before calendar starts
        if (startDay != 7) {
            var noPrintDays = startDay + 1; 
        } else {
            var noPrintDays = 0; // if sunday print right away	
        }
		var today = new Date().getDate();
		var thisMonth = new Date().getMonth();
		var thisYear = new Date().getFullYear();
        // create calendar rows
        for (var e=0; e<numRows; e++) {
			html += '<tr class="weekDaysRow">';
            // create calendar days
            for (var f=0; f<7; f++) {
				if ( (printDate == today) 
					 && (this.selectedYear == thisYear) 
					 && (this.selectedMonth == thisMonth) 
					 && (noPrintDays == 0)) {
					html += '<td id="today" class="weekDaysCell">';
				} else {
                	html += '<td class="weekDaysCell">';
				}
                if (noPrintDays == 0) {
					if (printDate <= daysInMonth) {
						html += this.checkDateClickable(printDate);
					}
                    printDate++;
                }
                html += '</td>';
                if(noPrintDays > 0) noPrintDays--;
            }
            html += '</tr>';
        }
		html += '</table>';
        
        // add calendar to element to calendar Div
        $(this.calendarId).update(html);
        
        $(this.calendarId).setStyle({width: 'auto', height: 'auto', display: 'block'});
        var dimensions = $(this.calendarId).getDimensions();

        if(Prototype.Browser.IE){
            $(this.calendarId + 'Frame').setStyle({width: dimensions.width + 'px', height: dimensions.height + 'px', display: 'block'});
        }    
       
    }, 
    checkDateClickable: function(pDate){
       var rv = '<a class="sD">'+pDate+'</a>';
       if (((pDate < this.minDate.getDate()) 
            && (this.selectedMonth == this.minDate.getMonth())
            && (this.selectedYear == this.minDate.getFullYear())) ||
            ((pDate > this.maxDate.getDate()) 
            && (this.selectedMonth == this.maxDate.getMonth())
            && (this.selectedYear == this.maxDate.getFullYear()))) rv = pDate;
      return rv;
    },
    eventPrevMonth: function () {
        if(this.testRange('p')){
            this.selectedMonth--;
            if (this.selectedMonth < 0) {
                this.selectedMonth = 11;
                this.selectedYear--;
            }
            this.drawCalendar(); 
         }    
        },
    eventNextMonth: function () {
        if(this.testRange('n')){
            this.selectedMonth++;
            if (this.selectedMonth > 11) {
                this.selectedMonth = 0;
                this.selectedYear++;
            }
            this.drawCalendar(); 
         }   
        },
    testRange: function (dir){
     switch(dir){
        case 'p':
            tMonth = this.minDate.getMonth();
            tYear = this.minDate.getFullYear();
        break;
        case 'n':    
            tMonth = this.maxDate.getMonth();
            tYear = this.maxDate.getFullYear();
        break;       
     }   
      if(tMonth == this.selectedMonth && tYear == this.selectedYear) 
            return false;
      else
            return true;          
    }       
}

var calendarConfig = {
    inputClass: 'datePick',
    minDate: new Date(1990,1,1)
}

console.log(calendarConfig.minDate);
calendarConfig.maxDate = new Date(calendarConfig.minDate.getTime() + (364 * 24 * 60 * 60 * 1000));


var myPopupHandler = {};
function myPageInit(){
   myPopupHandler = new popUpCal();
}

// Add calendar event that has wide browser support
Event.observe(window, 'load', myPageInit);

/* Functions Dealing with Dates */

function formatDate(Day, Month, Year) {
    Month++; // adjust javascript month
    if (Month <10) Month = '0'+Month; // add a zero if less than 10
    if (Day < 10) Day = '0'+Day; // add a zero if less than 10
    var dateString = Day+'/'+Month+'/'+Year;
    return dateString;
}

function getMonthName(month) {
    var monthNames = new Array('Januar','Februar','Marts','April','Maj','Juni','Juli','August','September','Oktober','November','December');
    return monthNames[month];
}

function getDayName(day) {
    var dayNames = new Array('Mandag','Tirsdag','Onsdag','Torsdag','Fredag','Lørdag','Søndag')
    return dayNames[day];
}

function getDaysInMonth(year, month) {
    return 32 - new Date(year, month, 32).getDate();
}

function getFirstDayofMonth(year, month) {
    var day;
    day = new Date(year, month, 0).getDay();
    return day;
}


