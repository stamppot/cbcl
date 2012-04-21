// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

/* javascript logger */
var inspector = {};

Inspector = {
    inspect: function(val) {
        if (val.innerHTML) {
            Logger.log(val.innerHTML);
        } else {
            Logger.log(val);
        }
    },

    inspectArray: function(array) {
        array.each(this.inspect);
    }
};

// cookies.js
var Document = {
  cookies: function(document){
    return $A(document.cookie.split("; ")).inject($H({}), function(memo, pair){
      pair = pair.split('=');
      memo.set(pair[0], pair[1]);
      return memo;
    });
  }
};
Object.extend(document, { cookies: Document.cookies.methodize() });

function get_journal_entry_id() {
  if(document.cookies().get('journal_entry') == "true"){
    $('login_box').show();
  }
}
// document.observe("dom:loaded", handle_login_box);


// call a method that updates the dynamic parts of a survey 
function get_dynamic_fragments(url, opt) {
 // alert ("Loading: " + url + "  args: " + opt );
	new Ajax.Request( url, {
	// method: 'post', // default is post
		parameters: opt,
		onSuccess: function(transport) { /* alert( transport.responseText ); */ },
		onFailure: function() { /* alert( "Unable to raise request" ); */ }
	});
};

function get_draft(url, opt) {
  new Ajax.Request(url, {
		parameters: opt,
    // contentType: "text/javascript",
    // evalJS: true,
	  onSuccess: function(transport) { eval(transport.responseText); }
	});
}

function changeAction(formid, actionvalue) {
 	document.getElementById(formid).action = actionvalue;
}

function setFormStatusInWindow(result, form) {
	if(!result) {
		window.status = "Der er manglende eller forkerte værdier i besvarelsen";
		return false;
	}
	if(result) { 
		window.status = "Sender besvarelsen...";
	}
	return true;
}

function getElementValue(formElement)
{
	if(formElement.length != null) var type = formElement[0].type;
	if((typeof(type) == 'undefined') || (type == 0)) var type = formElement.type;

	switch(type)
	{
		case 'undefined': return;

		case 'radio':
			for(var x=0; x < formElement.length; x++) 
				if(formElement[x].checked == true)
			return formElement[x].value;

		case 'select-multiple':
			var myArray = new Array();
			for(var x=0; x < formElement.length; x++) 
				if(formElement[x].selected == true)
					myArray[myArray.length] = formElement[x].value;
			return myArray;

		case 'checkbox': return formElement.checked;
	
		default: return formElement.value;
	}
}

function setElementValue(formElement, value)
{
	switch(formElement.type)
	{
		case 'undefined': return;
		case 'radio': formElement.checked = value; break;
		case 'checkbox': formElement.checked = value; break;
		case 'select-one': formElement.selectedIndex = value; break;

		case 'select-multiple':
			for(var x=0; x < formElement.length; x++) 
				formElement[x].selected = value[x];
			break;

		default: formElement.value = value; break;
	}
}

function toggleRadio(rObj) {
	if (!rObj) return false;
	
	rObj.__chk = rObj.__chk ? rObj.checked = !rObj.__chk : rObj.checked;

	// when a button is unchecked, the default button is checked
	if(!rObj.checked) {
		var def_radio = new String(rObj.id.match(/q[0-9]+_[0-9]+_[0-9]+_/));
		def_radio = def_radio + "9";
		$(def_radio).checked = true;
	}
	return true;
}

function toggleComments(form) {
    var comments = document.getElementsByClassName('comment');
    comments.all(function(v) {
      v.toggle(); 
    });
}

// turns on/off comment boxes
function toggleComment(input) {
    var elm = $(input);
		if(elm.disabled) {
      elm.enable();
			elm.show();
     }
    else {
      elm.disable();
			elm.hide();
    }
		return false;
}

function toggleElem(input) {
	var elm = $(input);
	elm.toggle();
}

function toggleElems(input) {
  try { 

		var elms = $A(document.getElementsByClassName(input)).reverse();
		elms.each(function(elm) {
			// Effect.toggle(elm,'blind',{});;
			(elm.toggle());
		});
  } catch (e) {}
}

function toggleActionFormat(formid, element) {
	var format = $(element).value;
	var input = $(formid).action;
	// alert("input before: " + input);
	if(input.lastIndexOf('http') > -1) {
		input = input.replace(/(http|https).\/\//, "");
		input = input.replace(/.3000/, "");
		input = input.replace(/(?:(?:(?:(?:[a-zA-Z0-9][-a-zA-Z0-9]*)?[a-zA-Z0-9])[.])*(?:[a-zA-Z][-a-zA-Z0-9]*[a-zA-Z0-9]|[a-zA-Z])[.]?)/, "");
		// alert("input after: " + input);
	}
	var output = "";
	if(input.lastIndexOf('.') === -1)
		output = input + '.' + format;
	else 
		output = input.substr(0, input.lastIndexOf('.')) || input;

		output = output.replace('.html', '');

	// alert("output: " + output);
	document.getElementById(formid).action = output;
}

function toggleReportType(formid, element) {
	var format = $(element).value;
	var input = $(formid).action;

	var isChecked = $(element).getValue();
	if(isChecked == "on")
		input = input.replace('score', 'answer');
	else
		input = input.replace('answer', 'score')
	
	document.getElementById(formid).action = input;
}