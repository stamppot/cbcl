// ------------------------------------------------------------------------------------------
// Switch Behavior
// ------------------------------------------------------------------------------------------

if(wFORMS) {

	// Component properties 
	wFORMS.classNamePrefix_switch 	  	= "switch";
	wFORMS.className_switchIsOn         = "swtchIsOn";    // used to keep track of the switch state on buttons and links (where the checked attribute is not available)
	wFORMS.className_switchIsOff        = "swtchIsOff";
	wFORMS.classNamePrefix_offState	  	= "offstate";        // 28-11 these are swapped to allow 'None' to switch off when checked
	wFORMS.classNamePrefix_onState	  	= "onstate";
	wFORMS.switchScopeRootTag           = "";         	  // deprecated.	

	wFORMS.switchTriggers               = {};			  // associative multi-dimensional array (switchname->element Ids)
	wFORMS.switchTargets                = {};			  // associative multi-dimensional array (switchname->element Ids)


	wFORMS.behaviors['switch'] = {

		// ------------------------------------------------------------------------------------------
		// evaluate: check if the behavior applies to the given node. Adds event handlers if appropriate
		// ------------------------------------------------------------------------------------------
		evaluate: function(node) {

			// Handle Switch Triggers
			// add event handles and populate the wFORMS.switchTriggers 
			// associative array (switchname->element Ids)
			// ------------------------------------------------------------------------------------------				
			if (wFORMS.helpers.hasClassPrefix(node, wFORMS.classNamePrefix_switch)) {

				if(!node.id) node.id = wFORMS.helpers.randomId();

				wFORMS.debug('switch/evaluate: '+ node.className + ' ' + node.tagName);

				// Go through each class (one element can have more than one switch trigger).
				var switchNames = wFORMS.behaviors['switch'].getSwitchNames(node);
				for(var i=0; i < switchNames.length; i++) {
					if(!wFORMS.switchTriggers[switchNames[i]]) 
					wFORMS.switchTriggers[switchNames[i]] = new Array();
					if(!wFORMS.switchTriggers[switchNames[i]][node.id])
					wFORMS.switchTriggers[switchNames[i]].push(node.id);
					wFORMS.debug('switch/evaluate: [trigger] '+ switchNames[i] + ' ' + node.id,3);
				}

				switch(node.tagName.toUpperCase()) {

					case "OPTION":
					// get the SELECT element
					var selectNode = node.parentNode;
					while(selectNode && selectNode.tagName.toUpperCase() != 'SELECT') {
						var selectNode = selectNode.parentNode;
					}
					if(!selectNode) { alert('Error: invalid markup in SELECT field ?'); return false;  } // invalid markup
					if(!selectNode.id) selectNode.id = wFORMS.helpers.randomId();

					// Make sure we have only one event handler for the select.
					if(!selectNode.getAttribute('rel') || selectNode.getAttribute('rel').indexOf('wfHandled')==-1) {
						//wFORMS.debug('switch/add event: '+ selectNode.className + ' ' + selectNode.tagName);
						selectNode.setAttribute('rel', (selectNode.getAttribute('rel')||"") + ' wfHandled');
						wFORMS.helpers.addEvent(selectNode, 'change', wFORMS.behaviors['switch'].run);
					}							
					break;

					case "INPUT":							
					if(node.type && node.type.toLowerCase() == 'radio') {
						// Add the onclick event on radio inputs of the same group
						var formElement = node.form;	
						for (var j=0; j<formElement[node.name].length; j++) {
							var radioNode = formElement[node.name][j];
							// prevents conflicts with elements with an id = name of radio group
							if(radioNode.type.toLowerCase() == 'radio') {
								// Make sure we have only one event handler for this radio input.
								if(!radioNode.getAttribute('rel') || radioNode.getAttribute('rel').indexOf('wfHandled')==-1) {								
									wFORMS.helpers.addEvent(radioNode, 'click', wFORMS.behaviors['switch'].run);
									// flag the node 
									radioNode.setAttribute('rel', (radioNode.getAttribute('rel')||"") + ' wfHandled');
								} 
							}
						}
					} else {
						wFORMS.helpers.addEvent(node, 'click', wFORMS.behaviors['switch'].run);
					}
					break;

					default:		
					wFORMS.helpers.addEvent(node, 'click', wFORMS.behaviors['switch'].run);
					break;
				}
			}

			// Push targets in the wFORMS.switchTargets array 
			// (associative array with switchname -> element ids)
			// ------------------------------------------------------------------------------------------
			if (wFORMS.helpers.hasClassPrefix(node, wFORMS.classNamePrefix_offState) ||
			wFORMS.helpers.hasClassPrefix(node, wFORMS.classNamePrefix_onState)) {

				if(!node.id) node.id = wFORMS.helpers.randomId();

				// Go through each class (one element can be the target of more than one switch).
				var switchNames = wFORMS.behaviors['switch'].getSwitchNames(node);

				for(var i=0; i < switchNames.length; i++) {
					if(!wFORMS.switchTargets[switchNames[i]]) 
					wFORMS.switchTargets[switchNames[i]] = new Array();
					if(!wFORMS.switchTargets[switchNames[i]][node.id]) 
					wFORMS.switchTargets[switchNames[i]].push(node.id);
					wFORMS.debug('switch/evaluate: [target] '+ switchNames[i],3);
				}										
			}

			if(node.tagName && node.tagName.toUpperCase()=='FORM') {
				// function to be called when all behaviors for this form have been applied
				//wFORMS.debug('switch/push init');
				wFORMS.onLoadComplete.push(wFORMS.behaviors['switch'].init); 
			}
		},

		// ------------------------------------------------------------------------------------------
		// init: executed once evaluate has been applied to all elements
		// ------------------------------------------------------------------------------------------	   
		init: function() {
			// go through all switch triggers and activate those who are already ON
			wFORMS.debug('switch/init: '+ (wFORMS.switchTriggers.length));
			for(var switchName in wFORMS.switchTriggers) {
				// go through all triggers for the current switch
				for(var i=0; i< wFORMS.switchTriggers[switchName].length; i++) {		   
					var element = document.getElementById(wFORMS.switchTriggers[switchName][i]);
					wFORMS.debug('switch/init: ' + element + ' ' + switchName , 5);	
					if(wFORMS.behaviors['switch'].isTriggerOn(element,switchName)) {
						//alert("ON: " + wFORMS.behaviors['switch'].isTriggerOn(element,switchName).toString() + " " + element.id + " " + element.className + " swName: " + switchName)
						// if it's a select option, get the select element
						if(element.tagName.toUpperCase()=='OPTION') {
							var element = element.parentNode;
							while(element && element.tagName.toUpperCase() != 'SELECT') {
								var element = element.parentNode;
							}
						}
						// run the trigger
						wFORMS.behaviors['switch'].run(element);
					}

					}
				}
			},

			// ------------------------------------------------------------------------------------------
			// run: executed when the behavior is activated
			// ------------------------------------------------------------------------------------------	   
			run: function(e) {
				var element   = wFORMS.helpers.getSourceElement(e);
				if(!element) element = e;
				wFORMS.debug('switch/run: ' + element.id , 5);	

				var switches_ON  = new Array();
				var switches_OFF = new Array();

				// Get list of triggered switches (some ON, some OFF)
				switch(element.tagName.toUpperCase()) {
					case 'SELECT':
					for(var i=0;i<element.options.length;i++) {
						if(i==element.selectedIndex) {	
							switches_ON  = switches_ON.concat(wFORMS.behaviors['switch'].getSwitchNames(element.options[i]));
						} else {
							switches_OFF = switches_OFF.concat(wFORMS.behaviors['switch'].getSwitchNames(element.options[i]));
						}
					}

					break;
					case 'INPUT':
					if(element.type.toLowerCase() == 'radio') {
						// Go through the radio group.

						for(var i=0; i<element.form[element.name].length;i++) { 
							var radioElement = element.form[element.name][i];
							if(radioElement.checked) {
								// if element.hasClass(showIsOn)  switch off - put in hide (switches_OFF)
								// else put in show (switches_ON)
								switches_ON  = switches_ON.concat(wFORMS.behaviors['switch'].getSwitchNames(radioElement));
								} else {  // unchecked
									// if element.hasClass(showIsOff)  switch on - put in show (switches_ON)
									// else put in hide (switches_OFF)
									wFORMS.debug(wFORMS.behaviors['switch'].getSwitchNames(radioElement).length,1);
									switches_OFF = switches_OFF.concat(wFORMS.behaviors['switch'].getSwitchNames(radioElement));
								}
							}
							} else {  // checkbutton. Does not depend of status of checkbutton. Switch states
								switchNames = wFORMS.behaviors['switch'].getSwitchNames(element);
								for(var k=0; k<switchNames.length; k++) {  // when one button, multiple switches and multiple targets, switch for all switches
									targets = wFORMS.behaviors['switch'].getElementsBySwitchName(switchNames[k]);
									for(var j=0; j<targets.length; j++) { 
										if( wFORMS.helpers.hasClassPrefix(targets[j], wFORMS.classNamePrefix_onState)) { // if off, and check, set to ON
											switches_OFF = switches_OFF.concat(wFORMS.behaviors['switch'].getSwitchNames(targets[j]));
										}
										if( wFORMS.helpers.hasClassPrefix(targets[j], wFORMS.classNamePrefix_offState)) { // if off, and check, set to ON
											switches_ON = switches_ON.concat(wFORMS.behaviors['switch'].getSwitchNames(targets[j]));
										}
									}
								}								
							}
							break;
							default:
							break;
						}

							// Turn off switches first
							for(var i=0; i < switches_OFF.length; i++) {
								// Go through all targets of the switch 
								var elements = wFORMS.behaviors['switch'].getElementsBySwitchName(switches_OFF[i]);
								for(var j=0;j<elements.length;j++) {

									if(wFORMS.behaviors['switch'].isWithinSwitchScope(element, elements[j])) {
										// one of the triggers is still ON. no switch off
										wFORMS.behaviors['switch'].switchState(elements[j], wFORMS.classNamePrefix_onState, wFORMS.classNamePrefix_offState);
										doSwitch = false;
									}
								}
							}
							// Turn on
							for(var i=0; i < switches_ON.length; i++) {
								var elements = wFORMS.behaviors['switch'].getElementsBySwitchName(switches_ON[i]);
								for(var j=0;j<elements.length;j++) {   // go thru all targets of the switch
									// An element with the REPEAT behavior limits the scope of switches 
									// targets outside of the scope of the switch are not affected. 
									if(wFORMS.behaviors['switch'].isWithinSwitchScope(element, elements[j])) {

										wFORMS.behaviors['switch'].switchState(elements[j], wFORMS.classNamePrefix_offState, wFORMS.classNamePrefix_onState);
										wFORMS.debug('switch/run: [turn on ' + switches_ON[i] + '] ' + elements[j].id , 3);	
									}
								}
							}
						},

										// ------------------------------------------------------------------------------------------
										// clear: executed if the behavior should not be applied anymore
										// ------------------------------------------------------------------------------------------
										clear: function(e) {
											// @TODO: go through wFORMS.switchTriggers to remove events.
											wFORMS.switchTriggers = {};		
											wFORMS.switchTargets = {};

										},


										// ------------------------------------------------------------------------------------------
										// Get the list of switches 
										// Note: potential conflict if an element is both a switch and a target.
										getSwitchNames: function(element) {
											var switchNames = new Array();
											var classNames  = element.className.split(' ');
											for(var i=0; i < classNames.length; i++) {
												// Note: Might be worth keeping a prefix on switchName to prevent collision with reserved names						
												if(classNames[i].indexOf(wFORMS.classNamePrefix_switch) == 0) {
													switchNames.push(classNames[i].substr(wFORMS.classNamePrefix_switch.length+1));
												}
												if(classNames[i].indexOf(wFORMS.classNamePrefix_onState) == 0) {
													switchNames.push(classNames[i].substr(wFORMS.classNamePrefix_onState.length+1));
												}
												else if(classNames[i].indexOf(wFORMS.classNamePrefix_offState) == 0) {
													switchNames.push(classNames[i].substr(wFORMS.classNamePrefix_offState.length+1));
												}
											}
											return switchNames;
										},

										// ------------------------------------------------------------------------------------------
										switchState: function(element, oldStateClass, newStateClass) {		
											if(!element || element.nodeType != 1) return;
											if(element.className) {  		
												element.className = element.className.replace(oldStateClass, newStateClass);
											}		

											// wFORMS.className_showIsOn						= "showIsOn";
											// wFORMS.className_hideIsOn						= "hideIsOn";
											// wFORMS.className_showIsOff					= "showIsOff";
											// wFORMS.className_hideIsOff					= "hideIsOff";
											if(wFORMS.helpers.hasClass(element, wFORMS.className_showIsOn)) { // set to showIsOff
												element.className = element.className.replace(wFORMS.className_showIsOn, wFORMS.className_switchIsOff);
											} else if(wFORMS.helpers.hasClass(element, wFORMS.className_showIsOff)) {
												element.className = element.className.replace(wFORMS.className_showIsOff, wFORMS.className_showIsOn);
											}	else if(wFORMS.helpers.hasClass(element, wFORMS.className_hideIsOn)) {
												element.className = element.className.replace(wFORMS.className_hideIsOn, wFORMS.className_hideIsOff);
											}	else if(wFORMS.helpers.hasClass(element, wFORMS.className_hideIsOff)) {
												element.className = element.className.replace(wFORMS.className_hideIsOff, wFORMS.className_hideIsOn);
											} 


											// For  elements that don't have a native state variable (like checked, or selectedIndex)
											if(wFORMS.helpers.hasClass(element, wFORMS.className_switchIsOff)) {
												element.className = element.className.replace(wFORMS.className_switchIsOff, wFORMS.className_switchIsOn);
											} else if(wFORMS.helpers.hasClass(element, wFORMS.className_switchIsOn)) {
												element.className = element.className.replace(wFORMS.className_switchIsOn, wFORMS.className_switchIsOff);
											}
										},

										// ------------------------------------------------------------------------------------------
										getElementsBySwitchName: function(switchName) {
											var elements = new Array();
											if(wFORMS.switchTargets[switchName]) {
												for (var i=0; i<wFORMS.switchTargets[switchName].length; i++) {
													var element = document.getElementById(wFORMS.switchTargets[switchName][i]);
													if(element)
													elements.push(element);
												}
											}
											return elements;
										},

										// ------------------------------------------------------------------------------------------
										isTriggerOn: function(element, triggerName) {
											if(!element) return false;
											if(element.tagName.toUpperCase()=='OPTION') {
												var selectElement = element.parentNode;
												while(selectElement && selectElement.tagName.toUpperCase() != 'SELECT') {
													var selectElement = selectElement.parentNode;
												}
												if(!selectElement) return false; // invalid markup					
												if(selectElement.selectedIndex==-1) return false; // nothing selected
												// TODO: handle multiple-select
												if(wFORMS.helpers.hasClass(selectElement.options[selectElement.selectedIndex],
													wFORMS.classNamePrefix_switch + '-' + triggerName)) {
														return true;
													}
													} else { // maybe should only return On when element is checked
														if(element.checked )//|| wFORMS.helpers.hasClass(element, wFORMS.className_switchIsOn)) 
														return true;
													}
													return false;
												},

												// isWithinSwitchScope: An element with the REPEAT behavior limits the scope of switches 
												// targets outside of the scope of the switch are not affected. 
												// ------------------------------------------------------------------------------------------			
												isWithinSwitchScope: function(trigger, target) {

													if(wFORMS.hasBehavior('repeat') && wFORMS.limitSwitchScope == true) { 
														// check if the trigger is in a repeatable/removeable element
														var scope = trigger;

														while(scope && scope.tagName && scope.tagName.toUpperCase() != 'FORM' && 
														!wFORMS.helpers.hasClass(scope, wFORMS.className_repeat) &&
														!wFORMS.helpers.hasClass(scope, wFORMS.className_delete) ) {
															scope = scope.parentNode;
														}
														if(wFORMS.helpers.hasClass(scope, wFORMS.className_repeat) || 
														wFORMS.helpers.hasClass(scope, wFORMS.className_delete)) {
															// yes, the trigger is nested in a repeat/remove element

															// check if the target is in the same element.
															var scope2 = target;
															while(scope2 && scope2.tagName && scope2.tagName.toUpperCase() != 'FORM' && 
															!wFORMS.helpers.hasClass(scope2, wFORMS.className_repeat) &&
															!wFORMS.helpers.hasClass(scope2, wFORMS.className_delete) ) {
																scope2 = scope2.parentNode;
															}
															if(scope == scope2) {
																return true;  // target & trigger are in the same repeat/remove element		
															} else {
																return false; // target not in the same repeat/remove element,					
															}
														} else {
															return true;	  // trigger is not nested in a repeat/remove element, scope unaffected
														}
														} else 
														return true;
													}
													} // END wFORMS.behaviors['switch'] object


												}