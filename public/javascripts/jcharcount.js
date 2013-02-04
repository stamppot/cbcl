/* 
Description :	Functions in relation to limiting and displaying the number of characters allowed in a textarea
Version:		2.1
Changes:		Added overage override.  Read blog for updates: http://blog.ninedays.org/2008/01/17/limit-characters-in-a-textarea-with-prototype/
Functions:		init()						Function called when the window loads to initiate and apply character counting capabilities to select textareas
			charCounter(id, maxlimit, limited)	Function that counts the number of characters, alters the display number and the class applied to the display number
			makeItCount(id, maxsize, limited)	Function called in the init() function, sets the listeners on the textarea and instantiates the feedback display number if it does not exist
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
*/
	
	function charCounter(id, maxlimit, limited){
		// console.log("id: " + id);
		if ($('#counter-'+id).length == 0) {
			$('#' + id).append('<div id="counter-'+id+'"></div>');
			console.log($('counter-'+id));
		}
		var text_val = $('#'+id).val();
		// console.log(text_val);
		if(text_val.length >= maxlimit) {
			if(limited) {
				text_val = text_val.substring(0, maxlimit);
				$('#'+id).val(text_val);
			}
			$('#counter-'+id).addClass('charcount-limit');
			$('#counter-'+id).removeClass('charcount-safe');
		} else {	
			$('#counter-'+id).removeClass('charcount-limit');
			$('#counter-'+id).addClass('charcount-safe');
		}
		$('#counter-'+id).val( text_val.length + '/' + maxlimit );	
	}
	
	function makeItCount(id, maxsize, limited){
		if(limited == null) limited = true;
		if ($('#'+id)){
			$('#'+id).bind('keyup', function(){charCounter(id, maxsize, limited);});
			$('#'+id).bind('keydown', function(){charCounter(id, maxsize, limited);});
			charCounter(id,maxsize,limited);
		}
	}