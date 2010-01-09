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

// call a method that updates the dynamic parts of a survey 
function get_dynamic_fragments(url, arg) {
 // alert ("Loading: " + url + "  args: " + arg );
 //new Ajax.Updater('draft-message', '/survey_answers/save_draft/3158', {asynchronous:true, evalScripts:true, parameters:value})})
     new Ajax.Request( url, {
            // method: 'get', // default is post
						parameters: arg,
            onSuccess: function(transport) {
                // alert( transport.responseText );
                 },
            onFailure: function() {
                //alert( "Unable to raise request" );
                }
            }
        );
};

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