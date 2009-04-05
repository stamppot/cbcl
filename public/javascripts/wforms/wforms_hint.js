
// ------------------------------------------------------------------------------------------
// Field Hint / Tooltip Behavior
// ------------------------------------------------------------------------------------------
  
if(wFORMS) {

       // Component properties 
       wFORMS.idSuffix_fieldHint           = "-H";                     // a hint id is the associated field id (or name) plus this suffix
       wFORMS.className_inactiveFieldHint  = "field-hint-inactive";    // visual effect depends on CSS stylesheet
       wFORMS.className_activeFieldHint    = "field-hint";             // visual effect depends on CSS stylesheet
       
       
       wFORMS.behaviors['hint'] = {
           name: 'hint', 
           
		   // evaluate: check if the behavior applies to the given node. Adds event handlers if appropriate
             evaluate: function(node) {
               if(node.id) {
               	   if(node.id.indexOf(wFORMS.idSuffix_fieldHint)>0) {               	   
               	     // this looks like a field-hint. See if we have a matching field.               	    
               	     // try first with the id, then with the name attribute.
               	     var id     = node.id.replace(wFORMS.idSuffix_fieldHint, '');               	     
               	     var hinted = document.getElementById(id) || wFORMS.processedForm[id];
               	   } 
                   if(hinted) {
					   // is hint placed on a radio group using the name attribute?
					   if(hinted.length > 0 && hinted[0].type=='radio') {
						   var hintedGroup = hinted;
						   l = hinted.length;
					   } else {
						   var hintedGroup = new Array(hinted);
						   l = 1;
					   }
					   
					   for(var i=0;i<l;i++) {
						   hinted = hintedGroup[i];

						   wFORMS.debug('hint/evaluate: '+ (node.id || node.name));
						   switch(hinted.tagName.toUpperCase()) {
							   case 'SELECT': 
							   case 'TEXTAREA':						   
							   case 'INPUT':
									wFORMS.helpers.addEvent(hinted,'focus',wFORMS.behaviors['hint'].run);
									wFORMS.helpers.addEvent(hinted,'blur' ,wFORMS.behaviors['hint'].remove);
									break;
							   default:
									wFORMS.helpers.addEvent(hinted,'mouseover',wFORMS.behaviors['hint'].run);
									wFORMS.helpers.addEvent(hinted,'mouseout' ,wFORMS.behaviors['hint'].remove);
									break;
						   }
						   
					   }
                   } 
               }
           },

		   
           // run: executed when the behavior is activated
           run: function(e) {
               var element   = wFORMS.helpers.getSourceElement(e);
               var fieldHint = document.getElementById(element.id   + wFORMS.idSuffix_fieldHint);
               if(!fieldHint) // try again with the element's name attribute
                   fieldHint = document.getElementById(element.name + wFORMS.idSuffix_fieldHint);
               if(fieldHint) {
                   fieldHint.className = fieldHint.className.replace(wFORMS.className_inactiveFieldHint,
                                                                     wFORMS.className_activeFieldHint);
				   // Field Hint Absolute Positionning
				   fieldHint.style.top  =  (wFORMS.helpers.getTop(element)+ element.offsetHeight).toString() + "px";
				   if(element.tagName.toUpperCase() == 'SELECT') 
					   fieldHint.style.left =  (wFORMS.helpers.getLeft(element) + (element.offsetWidth- 8)).toString() + "px";
				   else 
					   fieldHint.style.left =  (wFORMS.helpers.getLeft(element)).toString() + "px"; /* + element.offsetWidth */
//				   wFORMS.debug('hint/run: ' + (element.id || element.name) , 5);				   
			   }
           },
		   
           // remove: executed if the behavior should not be applied anymore
           remove: function(e) {
               var element   = wFORMS.helpers.getSourceElement(e);
               var fieldHint = document.getElementById(element.id   + wFORMS.idSuffix_fieldHint);
               if(!fieldHint) // try again with the element's name attribute
                   fieldHint = document.getElementById(element.name + wFORMS.idSuffix_fieldHint);
               if(fieldHint)
                   fieldHint.className = fieldHint.className.replace(wFORMS.className_activeFieldHint,
                                                                     wFORMS.className_inactiveFieldHint);
//			   wFORMS.debug('hint/remove: ' + (element.id || element.name) , 5);				   
           }
       }
   }