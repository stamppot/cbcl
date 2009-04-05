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