/**** Tabbing between fields and other stuff used in surveys ****/

function tabbing(input, e) {
    var keyCode = e.keyCode;
    if(e.keyCode == 13) { // enter
        if(input.id != 'submit') {
            event.keyCode = 9;
        }
        //else if (input.id == 'submit')
    }
}


function disableQuestions(input, e) {

    if(e.keyCode == 13) {
        var nextform = input.form[getIndex(input)];
        $(nextform).focus();
    }
}

/* not currently used */
function inc_cell_col(cell_id)
{ 
  var re = /Q(\d+)_q(\d+)_cell(\d+)_(\d+)/;
  var matches = cell_id.match(re);
	var next_col = "Q" + matches[1].toString() + "_q" + matches[2].toString() + "_cell" + (parseInt(matches[3])+1).toString() + "_" + matches[4].toString(); 
	return next_col;
}

function inc_cell_row(cell_id)
{ 
  var re = /q(\d+)_cell(\d+)_(\d+)/;
  var matches = cell_id.match(re);
	var next_col = "q" + matches[1].toString() + "_cell" + matches[2].toString() + "_" + (parseInt(matches[3])+1).toString(); 
	return next_col;
}

function submitSurvey(input, e) {
    var keyCode = e.keyCode;
    if(e.keyCode == 13) {
        $('surveyform').submit();
    }
}

function displaykey(event) {
    alert(event.keyCode+' : '+String.fromCharCode(event.keyCode) + " pressed");
}

function getIndexPrevious(input) {	
	// first use binary search. That doesn't work when in input field of different format than Qx_celly_z
	// when in different field, use linear search
	var index = binary_search(input.form, input.id);

	if (index < 0) {   // if other type of input (not matching, use linear search to find next)
		var i = 0;
		while (i < input.form.length && index == -1)
		{
			if (input.form[i].id == input.id)
			index = i;
			else i++;
		}
	}
	index--;  // find next visible form element

	while (index < input.form.length)
	{
		if( !(input.form[index].type == 'hidden' || input.form[index].disabled == true)) {
			return index;
		}
		else index--;
	}
	return index;
}

function getIndex(input) {	
	// first use binary search. That doesn't work when in input field of different format than Qx_celly_z
	// when in different field, use linear search
	var index = binary_search(input.form, input.id);

	if (index < 0) {   // if other type of input (not matching, use linear search to find next)
		var i = 0;
		while (i < input.form.length && index == -1)
		{
			if (input.form[i].id == input.id)
			index = i;
			else i++;
		}
	}

	index++;  // find next visible form element

	//alert("binsearch index: " + index);
	while (index < input.form.length)
	{
		if( !(input.form[index].type == 'hidden' || input.form[index].disabled == true)) {
			// alert("Index count: " + index);
			return index;
		}
		else index++;
	}
	return index;
}

function compare_cell(lhs_q, lhs_row, lhs_col, rhs_q, rhs_row, rhs_col) {
  if (lhs_q == rhs_q) {   // questions are equal, usually the case
    if (lhs_row < rhs_row)
      return -1;
    else if (lhs_row > rhs_row)
      return 1;
    else  // both questions and rows are equal
		if (lhs_col < rhs_col)
      return -1;
		else if (lhs_col == rhs_col)
		   // found
    	return 0;
		else  // rhs is greater
	    return 1;
  }
  else if (lhs_q < rhs_q)
	  return -1;
	else
	  return 1;
}

function binary_search(elements, input) {  // input == value to find
  var funCompare = compare_cell;
  var floor = Math.floor;
	var test_q = "", test_row = "", test_col = "";
	re = /Q(\d+)_cell(\d+)_(\d+)/;

  var match = input.match(re);
	if(match == null)
		return -1;

  var q = match[1], row = match[2], col = match[3];
  var test = -1;
  var low = 0;
  var high = elements.length - 1;
  while (low <= high) {
    mid = floor((low + high) / 2);
    var watch = elements[mid].id.match(re);
		//alert("input, elements[mid]:" + input + ", " + elements[mid].id);
		if(watch == null) {
			low++;
		}
		else {
			test_q   = watch[1];
			test_row = watch[2];
			test_col = watch[3];
			test = funCompare(q, row, col, test_q, test_row, test_col);
			//alert("searching low, mid, high, <=>: " + low + ", " + mid + ", " + high + ",  <=> " + test);
			//alert("input, match: " + input + ":  " + test_q + " " + test_row + " " + test_col);
			if (test == -1) {   // < 0
				high = mid - 1;
			}
			else if (test == 1) {   // > 0
				low = mid + 1;
			}
			else {
				// alert("found! " + mid + " input: " + input + "   result: " + elements[mid].id);
				return mid;
			}
		}
	}
	return -1;
}

// function toggleRadio(rObj) {
// 	if (!rObj) return false;
// 	
// 	rObj.__chk = rObj.__chk ? rObj.checked = !rObj.__chk : rObj.checked;
// 
// 	// when a button is unchecked, the default button is checked
// 	if(!rObj.checked) {
// 		var def_radio = new String(rObj.id.match(/q[0-9]+_[0-9]+_[0-9]+_/));
// 		def_radio = def_radio + "9";
// 		$(def_radio).checked = true;
// 	}
// 	return true;
// }

function getWindowHeight() {
		var body  = document.body;
		var docEl = document.documentElement;
		return window.innerHeight || 
      (docEl && docEl.clientHeight) ||
      (body  && body.clientHeight)  || 
      0;
}

function scrollElemToCenter(id, duration) {
  var el = $(id);
  var winHeight = getWindowHeight();
  var offsetTop = el.offsetTop;
  if (offsetTop > winHeight) { 
    var y = offsetTop - (winHeight-el.offsetHeight)/2;
    // wo animation: scrollTo(0, y);
    scrollToAnim(y, duration);
  }
}

function interpolate(source,target,pos) { return (source+(target-source)*pos); }
function easing(pos) { return (-Math.cos(pos*Math.PI)/2) + 0.5; }

function scrollToAnim(targetTop, duration) {
  duration || (duration = 500);
  var start    = +new Date,
      finish   = start + duration,
      startTop = getScrollRoot().scrollTop,
      interval = setInterval(function(){
        var now = +new Date, 
            pos = (now>finish) ? 1 : (now-start)/duration;
        var y = interpolate(startTop, targetTop, easing(pos)) >> 0;
        window.scrollTo(0, y);
        if(now > finish) { 
          clearInterval(interval);
        }
      }, 10);
} 

// var getScrollRoot = (function() {
// var SCROLL_ROOT;
//  return function() {
//    if (!SCROLL_ROOT) {
//      var bodyScrollTop  = document.body.scrollTop;
//      var docElScrollTop = document.documentElement.scrollTop;
//      window.scrollBy(0, 1);
//      if (document.body.scrollTop != bodyScrollTop)
//        (SCROLL_ROOT = document.body);
//      else 
//        (SCROLL_ROOT = document.documentElement);
//      window.scrollBy(0, -1);
//    }
//    return SCROLL_ROOT;
//  };
// })();


function tabNext(valid, input) {
	if(valid) {
    var nextelem = $(input.form[getIndex(input)]);
    			// console.log('input1: ' + input.id);
    			// console.log('input2: ' + nextelem);
 	  	if((typeof nextelem) !== 'undefined' && nextelem.value == "9") {  // when element is prefilled with 'no answer', select to ease input
			nextelem.focus();  // both focus and select, then the window scrolls along
			nextelem.select();
			// console.log('input: ' + input);
			// scrollTo(input.id, input.offsetTop-300);
		}
		else
			if((typeof nextelem) !== 'undefined') {
				nextelem.focus();
			// scrollTo(input.id, input.offsetTop-300);
			}
	}
};

function tabPrev(valid, input) {
	if(valid) {
    var prevelem = input.form[getIndexPrevious(input)];
 	  $(prevelem).focus();
			// scrollTo(input.id, input.offsetTop-300);
	} 
	else {
	}
};
