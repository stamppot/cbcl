// ------------------------------------------------------------------------------------------
// Form On-Blur Validation Behavior
// Runs the validation when the user leaves a field (onblur event)
// Requires the wForms validation behavior.
// ------------------------------------------------------------------------------------------
  
   if(wFORMS) {

		wFORMS.behaviors['onblur_validation'] = {
						
		   // ------------------------------------------------------------------------------------------
		   // evaluate: check if the behavior applies to the given node. Adds event handlers if appropriate
		   // ------------------------------------------------------------------------------------------
			evaluate: function(node) {
				if (wFORMS.helpers.hasClassPrefix(node,wFORMS.classNamePrefix_validation) ||
				  	wFORMS.helpers.hasClass(node,wFORMS.className_required)) {
					switch(node.tagName.toUpperCase()) {
						case 'INPUT':
						case 'SELECT':
						case 'TEXTAREA':						
		                   	wFORMS.helpers.addEvent(node,'blur', wFORMS.behaviors['onblur_validation'].run);
							// wFORMS.debug('onblur_validation/evaluate: '+ node.id,3);
							break;
					}
						
				   
               }
           },
		   // ------------------------------------------------------------------------------------------
           // init: executed once evaluate has been applied to all elements
		   // ------------------------------------------------------------------------------------------	   
		   init: function() {
		   },
		   
		   // ------------------------------------------------------------------------------------------
           // run: executed when the behavior is activated
		   // ------------------------------------------------------------------------------------------	   		   
           run: function(e) {
				var element  = wFORMS.helpers.getSourceElement(e);
				if(!element) element = e;
				// wFORMS.debug('onblur_validation/run: ' + element.id , 5);	
							
				var nbErrors = wFORMS.behaviors['validation'].validateElement(element, false, true);
				
				// save the value in a property if someone else needs it.
				wFORMS.behaviors['validation'].errorCount = nbErrors;
				
				if (nbErrors > 0) {					
					//if(wFORMS.showAlertOnError){ wFORMS.behaviors['validation'].showAlert(nbErrors); }
				}
				return true;
			},
		   
			// ------------------------------------------------------------------------------------------
			// remove: executed if the behavior should not be applied anymore
			// ------------------------------------------------------------------------------------------
			remove: function() {
			}
		   
   }
}
   
   