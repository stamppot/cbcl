function updateRowCol(cell_id) {
	var element = $(cell_id);
	
	if(!element.id.toString().match(/td_q/)) {
		element = element.parentNode;

		while(element && element.id.toString().match(/td_q/)) {
			var element = element.parentNode;
		}
	}
	// get question, row, col
	var matches = cell_id.match(/td_q([0-9]+)_([0-9]+)_([0-9]+)/);

	if(matches && (matches.length > 1)) {
		// alert("matches: " + matches.inspect());
		var q = matches[1];
		var row = parseInt(matches[2]) - 1;
		var col = parseInt(matches[3]) - 1;
		
		setElementValue($('variable_row'), row);
		setElementValue($('variable_col'), col);
	}
	highlightBackground(element.id);
}

function highlightBackground(elem_id) {
	// alert("elem_id: " + elem_id.toString());
	// first remove old highlight
	if(($(currHighlight) != undefined) &&  currHighlight.match(/td_q/)) {
		$(currHighlight).style.backgroundColor = 'white';
	}
	// set currHighlight to argument
	currHighlight = elem_id;
	if(($(currHighlight) != undefined) && elem_id.match(/td_q/)) {
		$(currHighlight).style.backgroundColor = 'lightBlue';
	}
}

function highlightCell(question, row, col) {
	var cell_id = "td_q" + question + "_" + row + "_" + col;
	highlightBackground(cell_id);
	new Effect.Highlight("variable_row",{duration:2,startcolor: "#ff0000", endcolor: "#ff00ff", restorecolor: "#ffffff"});
	new Effect.Highlight("variable_col",{duration:2,startcolor: "#00ff00", endcolor: "#0000ff", restorecolor: "#ffffff"});
	new Effect.Pulsate($(cell_id),{duration:4});
}

function updatePreview() {
	prefix = $('variable_item').value.toString() + $('variable_short').value;
	$('preview').innerHTML = prefix;
	$('variable_var').value = prefix;
	// alert("Prefix: " + prefix.toString());
}