// ------------------------------------------------------------------------------------------
// Form Validation Behavior
// ------------------------------------------------------------------------------------------
  
   if(wFORMS) {
		// Component properties 
		// wFORMS.functionName_formValidation  is defined at the bottom of this file
		// Those should be moved inside wFORMS.behaviors['validation']. Stays here for now for backward compatibility
       	wFORMS.preventSubmissionOnEnter   		= false; 			// prevents submission when pressing the 'enter' key. Set to true if pagination behavior is used.
	   	wFORMS.showAlertOnError 			  	= true; 			// sets to false to not show the alert when a validation error occurs.
		wFORMS.className_required 			 	= "required";
		wFORMS.className_validationError_msg 	= "errMsg";		 
		wFORMS.className_validationError_fld	= "errFld";  
		wFORMS.classNamePrefix_validation 		= "validate";	
		wFORMS.idSuffix_fieldError				= "-E";

		wFORMS.behaviors['validation'] = {
			
			// Error messages. This may be overwritten in a separate js file for localization or customization purposes.			
			errMsg_required 	: "This field is required. ",
			errMsg_alpha 		: "The text must use alphabetic characters only (a-z, A-Z). Numbers are not allowed.",
			errMsg_email 		: "This does not appear to be a valid email address.",
			errMsg_integer 		: "Please enter an integer.",
			errMsg_float 		: "Please enter a number (ex. 1.9).",
			errMsg_password 	: "Unsafe password. Your password should be between 4 and 12 characters long and use a combinaison of upper-case and lower-case letters.",
			errMsg_alphanum 	: "Please use alpha-numeric characters only [a-z 0-9].",
			errMsg_date 		: "This does not appear to be a valid date.",
			errMsg_notification : "%% error(s) detected. Your form has not been submitted yet.\nPlease check the information you provided.",  // %% will be replaced by the actual number of errors.
			errMsg_custom		: "Please enter a valid value.",
			
			// Class Names
			className_allRequired : "allrequired",
			
			// first page w/ error in a multi-page form
			jumpToErrorOnPage : null,
			currentPageIndex  : -1,
			
			// do not submit fields turned off by switch behavior
			submitSwitchedOffFields : false,
			switchedOffFields : [],
			
		   // ------------------------------------------------------------------------------------------
		   // evaluate: check if the behavior applies to the given node. Adds event handlers if appropriate
		   // ------------------------------------------------------------------------------------------
			evaluate: function(node) {
               if(node.tagName.toUpperCase()=="FORM") {
				   // functionName_formValidation can be a reference to a function, or a string with the name of the function.
				   // avoid using typeof
				   if(wFORMS.functionName_formValidation.toString()==wFORMS.functionName_formValidation) {
					   // this is a string, not a function
					   wFORMS.functionName_formValidation = eval(wFORMS.functionName_formValidation);
				   }
                   wFORMS.helpers.addEvent(node,'submit',wFORMS.functionName_formValidation);
				   //wFORMS.debug('validation/evaluate: FORM '+ node.id,3);
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
				//wFORMS.debug('validation/run: ' + element.id , 5);	
				
				var currentPageOnly = arguments.length>1 ? arguments[1]:false;
				// arguments[1] : (wFORMS.hasBehavior('paging') && wFORMS.behaviors['paging'].behaviorInUse);

				wFORMS.behaviors['validation'].switchedOffFields = [];
				wFORMS.behaviors['validation'].jumpToErrorOnPage = null;

				// on multi-page forms we need to prevent the submission when the 'enter' key is pressed
				// (doesn't work in Opera. Further tests needed in IE and Safari)
				if(wFORMS.preventSubmissionOnEnter) { 
					if(element.type && element.type.toLowerCase()=='text') 
						// source element is a text field, the form was submitted with the 'enter' key.
						return wFORMS.preventEvent(e); 
				}
				// make sure we have the form element
				while (element && element.tagName.toUpperCase() != 'FORM') {
					element = element.parentNode;
				}		
				
				var nbErrors = wFORMS.behaviors['validation'].validateElement(element, currentPageOnly, true);
				
				// save the value in a property if someone else needs it.
				wFORMS.behaviors['validation'].errorCount = nbErrors;
				
				if (nbErrors > 0) {					
					if(wFORMS.behaviors['validation'].jumpToErrorOnPage) {					
						wFORMS.behaviors['paging'].gotoPage(wFORMS.behaviors['validation'].jumpToErrorOnPage);
					}
					if(wFORMS.showAlertOnError){ wFORMS.behaviors['validation'].showAlert(nbErrors); }
					return wFORMS.helpers.preventEvent(e); 
				}

				// Remove switched-off content if any
				// Note: in multi-page behavior the validation is run on "page next" without submitting the form.
				//       In this situation (currentPageOnly==true) switched-off conditionals should not be removed. 
				if(!wFORMS.behaviors['validation'].submitSwitchedOffFields && !currentPageOnly) {
					for(var i=0; i < wFORMS.behaviors['validation'].switchedOffFields.length; i++) {
						var element = wFORMS.behaviors['validation'].switchedOffFields[i];
						while(element.childNodes[0]) 
							element.removeChild(element.childNodes[0]);
					}
				}				
				return true;
			},
		   
			// ------------------------------------------------------------------------------------------
			// remove: executed if the behavior should not be applied anymore
			// ------------------------------------------------------------------------------------------
			remove: function() {
			},
		   
		   
			// ------------------------------------------------------------------------------------------
			// validation functions
			// ------------------------------------------------------------------------------------------
			validateElement: function(element /*, currentPageOnly, deep */) {

				var deep = arguments.length>2 ? arguments[2] : true;
				
				// used in multi-page forms
				var currentPageOnly = arguments[1] ? arguments[1] : false;				
				
				var wBehavior = wFORMS.behaviors['validation'];		// shortcut
				
				// do not validate elements that are in a OFF-Switch
				// Note: what happens if an element is the target of 2+ switches, some ON and some OFF ?
				if(wFORMS.hasBehavior('switch') && wFORMS.helpers.hasClassPrefix(element,wFORMS.classNamePrefix_offState)) {
					if(!wBehavior.submitSwitchedOffFields) {
						wBehavior.switchedOffFields.push(element);
					}
					return 0;
				}
				// do not validate elements that are not in the current page (Paging Behavior)
				if(wFORMS.hasBehavior('paging') && wFORMS.helpers.hasClass(element,wFORMS.className_paging)) {
					if(!wFORMS.helpers.hasClass(element,wFORMS.className_pagingCurrent) && currentPageOnly)
						return 0;
					wBehavior.currentPageIndex = wFORMS.behaviors['paging'].getPageIndex(element);
				}
				
				var nbErrors = 0;
				
				// check if required
				if(!wBehavior.checkRequired(element)) {
					wBehavior.showError(element, wBehavior.errMsg_required);
					nbErrors++;
					//wFORMS.debug('validation/error: [required]' + element.id + '('+nbErrors+')' , 5);
				} else {
				
					// input format validation
					if (wFORMS.helpers.hasClassPrefix(element,wFORMS.classNamePrefix_validation)) {
		
						var arrClasses = element.className.split(" ");
						for (j=0;j<arrClasses.length;j++) {
							switch(arrClasses[j]) {
								case "validate-alpha":
									if(!wBehavior.isAlpha(element.value)) {
										wBehavior.showError(element, wBehavior.errMsg_alpha);
										nbErrors++;
									}
									break;
								case "validate-alphanum":
									if(!wBehavior.isAlphaNum(element.value)) {
										wBehavior.showError(element, wBehavior.errMsg_alphanum);
										nbErrors++;
									}
									break;
								case "validate-date":
									if(!wBehavior.isDate(element.value)) {
										wBehavior.showError(element, wBehavior.errMsg_date);
										nbErrors++;
									}
									break;
								case "validate-time":
									/* NOT IMPLEMENTED */
									break;
								case "validate-email":
									if(!wBehavior.isEmail(element.value)) {
										wBehavior.showError(element, wBehavior.errMsg_email);
										nbErrors++;
									}
									break;
								case "validate-integer":
									if(!wBehavior.isInteger(element.value)) {
										wBehavior.showError(element, wBehavior.errMsg_integer);
										nbErrors++;
									}					
									break;
								case "validate-float":
									if(!wBehavior.isFloat(element.value)) {
										wBehavior.showError(element,wBehavior.errMsg_float);
										nbErrors++;
									}
									break;
								case "validate-strongpassword": // NOT IMPLEMENTED
									if(!wBehavior.isPassword(element.value)) {
										wBehavior.showError(element, wBehavior.errMsg_password);
										nbErrors++;
									}
									break;
								case "validate-custom": 
									var pattern = new RegExp("\/([^\/]*)\/([gi]*)");
									var matches = element.className.match(pattern);
									if(matches[0]) {										
										var validationPattern = new RegExp(matches[1],matches[2]);
										if(!element.value.match(validationPattern)) {
											wBehavior.showError(element, wBehavior.errMsg_custom);
											nbErrors++;											
										}
									}															
									break;									
							} // end switch
						} // end for
					}
				} // end validation check
				
				// remove previous error flags if any.
				if(nbErrors==0) {
					wBehavior.removeErrorMessage(element);
				} else {
					// flag the first page with an error (if multi-page form)
					if(wBehavior.currentPageIndex>0 && !wBehavior.jumpToErrorOnPage) {
						wBehavior.jumpToErrorOnPage = wBehavior.currentPageIndex;
					}
				}
					
				// recursive loop					
				if(deep) {
					for(var i=0; i < element.childNodes.length; i++) {
						if(element.childNodes[i].nodeType==1) { // Element Nodes only
							nbErrors += wBehavior.validateElement(element.childNodes[i], currentPageOnly, deep);
						}
					}
				}
				
				return nbErrors;
			},
			
			// ------------------------------------------------------------------------------------------
			checkRequired: function(element) {
				var wBehavior = wFORMS.behaviors['validation'];		// shortcut				

				if(wFORMS.helpers.hasClass(element,wFORMS.className_required)) {
					switch(element.tagName.toUpperCase()) {
						case "INPUT":
							var inputType = element.getAttribute("type");
							if(!inputType) inputType = 'text'; // handles lame markup
							switch(inputType.toLowerCase()) {
								case "checkbox":
									return element.checked; 
									break;
								case "radio":
									return element.checked; 
									break;
								default:
									return !wBehavior.isEmpty(element.value);
							}
							break;
						case "SELECT":							
							if(element.selectedIndex==-1) {
								// multiple select with no selection
								return false;
							} else 												
								return !wBehavior.isEmpty(element.options[element.selectedIndex].value);
							break;
						case "TEXTAREA":
							return !wBehavior.isEmpty(element.value);
							break;
						default:
							return wBehavior.checkOneRequired(element);
							break;
					} 	
				} else if(wFORMS.helpers.hasClass(element,wBehavior.className_allRequired)) {
					return wBehavior.checkAllRequired(element);
				}
				return true;
			},
			checkOneRequired: function(element) {	
				if(element.nodeType != 1) return false;
				var tagName = element.tagName.toUpperCase();
				var wBehavior = wFORMS.behaviors['validation'];
				
				if(tagName == "INPUT" || tagName == "SELECT" || tagName == "TEXTAREA" ) {
					var value = wBehavior.getFieldValue(element);	
					if(!wBehavior.isEmpty(value)) {					
						return true;
					}			
				}
				for(var i=0; i<element.childNodes.length;i++) {
					if(wBehavior.checkOneRequired(element.childNodes[i])) return true;
				}
				return false;
			},
			checkAllRequired: function(element)	{
				
				if(element.nodeType != 1) return true;
				var tagName = element.tagName.toUpperCase();
				var wBehavior = wFORMS.behaviors['validation'];

				if(tagName == "INPUT" || tagName == "SELECT" || tagName == "TEXTAREA" ) {
					var value = wBehavior.getFieldValue(element);	
					if(wBehavior.isEmpty(value)) {					
						return false;
					}			
				}
				for(var i=0; i<element.childNodes.length;i++) {
					if(!wBehavior.checkAllRequired(element.childNodes[i])) return false;
				}
				return true;
			},
			getFieldValue: function(element) {
				var value = null;
				if(element && element.tagName) {
					if(element.tagName.toUpperCase() == "INPUT") {
						var inputType = element.getAttribute("type");
						if(!inputType) inputType = 'text'; // handles lame markup
					
						switch(inputType.toLowerCase()) {
							case "checkbox": 
								value = element.checked?element.value:null; 
								break;
							case "radio":								
								var radioGroup = element.form[element.name]; 							
								for (var i = 0; i< radioGroup.length; i++) {
								    if (radioGroup[i].checked) {
								    	if(!value) value = new Array();
										value[value.length] = radioGroup[i].value;
								    }
								} 								
								break;
							default:
								value = element.value;
						}
					} else if(element.tagName.toUpperCase() == "SELECT") {	
						if(element.selectedIndex!=-1)																
							value = element.options[element.selectedIndex].value						
						else
							value = null; // multiple select with no selection
					} else if(element.tagName.toUpperCase() == "TEXTAREA") {
						value = element.value;
					}
				}
				return value;
			},
			// ------------------------------------------------------------------------------------------
			isEmpty: function(s) {				
				var regexpWhitespace = /^\s+$/;
				return  ((s == null) || (s.length == 0) || regexpWhitespace.test(s));
			},
			isAlpha: function(s) {
				var regexpAlphabetic = /^[a-zA-Z\s]+$/; // Add ' and - ?
				return wFORMS.behaviors['validation'].isEmpty(s) || regexpAlphabetic.test(s);
			},
			isAlphaNum: function(s) {
				var validChars = /^[\w\s]+$/;
				return wFORMS.behaviors['validation'].isEmpty(s) || validChars.test(s);
			},
			isDate: function(s) {
				var testDate = new Date(s);
				return wFORMS.behaviors['validation'].isEmpty(s) || !isNaN(testDate);
			},
			isEmail: function(s) {
				var regexpEmail = /\w{1,}[@][\w\-]{1,}([.]([\w\-]{1,})){1,3}$/;
				return wFORMS.behaviors['validation'].isEmpty(s) || regexpEmail.test(s);
			},
			isInteger: function(s) {
				var regexp = /^[+]?\d+$/;
				return wFORMS.behaviors['validation'].isEmpty(s) || regexp.test(s);
			},
			isFloat: function(s) {		
				return wFORMS.behaviors['validation'].isEmpty(s) || !isNaN(parseFloat(s));
			},
			// NOT IMPLEMENTED
			isPassword: function(s) {
				// Matches strong password : at least 1 upper case letter, one lower case letter. 4 characters minimum. 12 max.
				//var regexp = /^(?=.*[a-z])(?=.*[A-Z])(?!.*\s).{4,12}$/;  // <= breaks in IE5/Mac
				return wFORMS.behaviors['validation'].isEmpty(s);
			},
			
			// ------------------------------------------------------------------------------------------		
			// Error Alert Functions
			// ------------------------------------------------------------------------------------------		
			showError: function (element,errorMsg) {		
				// remove existing error message if any.
				wFORMS.behaviors['validation'].removeErrorMessage(element);
				
				if (!element.id) element.id = wFORMS.helpers.randomId(); // we'll need an id here.		
				// Add error flag to the field
				element.className += " " + wFORMS.className_validationError_fld;
				// Prepare error message
				var msgNode = document.createTextNode(" " + errorMsg);
				// Find error message placeholder.
				var fe = document.getElementById(element.id +  wFORMS.idSuffix_fieldError);
				if(!fe) { // create placeholder.
					fe = document.createElement("div"); 
					fe.setAttribute('id', element.id +  wFORMS.idSuffix_fieldError);			
					// attach the error message after the field label if possible
					var fl = document.getElementById(element.id +  wFORMS.idSuffix_fieldLabel);
					if(fl)
						fl.parentNode.insertBefore(fe,fl.nextSibling);
					else
						// otherwise, attach it after the field tag.
						element.parentNode.insertBefore(fe,element.nextSibling);
				}
				// Finish the error message.
				fe.appendChild(msgNode);  	
				fe.className += " " + wFORMS.className_validationError_msg;
			},
			
			showAlert: function (nbTotalErrors) {
			   alert(wFORMS.behaviors['validation'].errMsg_notification.replace('%%',nbTotalErrors));
			},
			
			removeErrorMessage: function(element) {
				if(wFORMS.helpers.hasClass(element,wFORMS.className_validationError_fld)) {
					var rErrClass     = new RegExp(wFORMS.className_validationError_fld,"gi");
					element.className = element.className.replace(rErrClass,"");
					var errorMessage  = document.getElementById(element.id + wFORMS.idSuffix_fieldError);
					if(errorMessage)  {				
						errorMessage.innerHTML=""; 
					}
				}
			}
					
       } // End wFORMS.behaviors['validation']
	   
		wFORMS.functionName_formValidation = wFORMS.behaviors['validation'].run;


		// ----------------------------------------------------------------------
		// wForms 1.0 backward compatibility
		// ----------------------------------------------------------------------
		wFORMS.formValidation = wFORMS.behaviors['validation'].run;
		
		// Error messages. 
		wFORMS.arrErrorMsg = new Array(); 
		wFORMS.arrErrorMsg[0] = wFORMS.behaviors['validation'].errMsg_required;	
		wFORMS.arrErrorMsg[1] = wFORMS.behaviors['validation'].errMsg_alpha; 			
		wFORMS.arrErrorMsg[2] = wFORMS.behaviors['validation'].errMsg_email;		
		wFORMS.arrErrorMsg[3] = wFORMS.behaviors['validation'].errMsg_integer;		
		wFORMS.arrErrorMsg[4] = wFORMS.behaviors['validation'].errMsg_float;
		wFORMS.arrErrorMsg[5] = wFORMS.behaviors['validation'].errMsg_password;
		wFORMS.arrErrorMsg[6] = wFORMS.behaviors['validation'].errMsg_alphanum;
		wFORMS.arrErrorMsg[7] = wFORMS.behaviors['validation'].errMsg_date;
		wFORMS.arrErrorMsg[8] = wFORMS.behaviors['validation'].errMsg_notification;
		
   }
   
   
   