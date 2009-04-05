// ------------------------------------------------------------------------------------------
// Switch Behavior
// ------------------------------------------------------------------------------------------

if(wFORMS) {

	// Component properties 
	wFORMS.classNamePrefix_jump 	  	= "jump";
	wFORMS.className_jumpIsOn         = "jmpIsOn";    // used to keep track of the switch state on buttons and links (where the checked attribute is not available)
	wFORMS.className_jumpIsOff        = "jmpIsOff";   // Idea: Use to jump on 0 or 1
	wFORMS.classNamePrefix_jmpZero	  = "jmp_zero";        // 28-11 these are swapped to allow 'None' to switch off when checked
	wFORMS.classNamePrefix_jmpOne	    = "jmp_one";
	wFORMS.classNamePrefix_jmpState	  = "jmp-state";
	wFORMS.switchScopeRootTag         = "";         	  // deprecated.	

	wFORMS.jumpTriggers               = {};			  // associative multi-dimensional array (jumpname->element Ids)
	wFORMS.jumpTargets                = {};			  // associative multi-dimensional array (jumpname->element Ids)


	wFORMS.behaviors['jump'] = {

		// ------------------------------------------------------------------------------------------
		// evaluate: check if the behavior applies to the given node. Adds event handlers if appropriate
		// ------------------------------------------------------------------------------------------
		evaluate: function(node) {

			// Handle Switch Triggers
			// add event handles and populate the wFORMS.jumpTriggers 
			// associative array (switchname->element Ids)
			// ------------------------------------------------------------------------------------------				
			if (wFORMS.helpers.hasClassPrefix(node, wFORMS.classNamePrefix_jump)) {

				if(!node.id) node.id = wFORMS.helpers.randomId();

				wFORMS.debug('jump/evaluate: '+ node.className + ' ' + node.tagName);

				// Go through each class (one element can have more than one switch trigger).
				// var jumpNames = wFORMS.behaviors['jump'].getJumpNames(node);
				// for(var i=0; i < jumpNames.length; i++) {
				// 	if(!wFORMS.jumpTriggers[jumpNames[i]]) 
				// 	wFORMS.jumpTriggers[jumpNames[i]] = new Array();
				// 	if(!wFORMS.jumpTriggers[jumpNames[i]][node.id])
				// 	wFORMS.jumpTriggers[jumpNames[i]].push(node.id);
				// 	wFORMS.debug('switch/evaluate: [trigger] '+ jumpNames[i] + ' ' + node.id,3);
				// }

				// switch(node.tagName.toUpperCase()) {
				// 
				// 	case "OPTION":
				// 	// get the SELECT element
				// 	var selectNode = node.parentNode;
				// 	while(selectNode && selectNode.tagName.toUpperCase() != 'SELECT') {
				// 		var selectNode = selectNode.parentNode;
				// 	}
				// 	if(!selectNode) { alert('Error: invalid markup in SELECT field ?'); return false;  } // invalid markup
				// 	if(!selectNode.id) selectNode.id = wFORMS.helpers.randomId();
				// 
				// 	// Make sure we have only one event handler for the select.
				// 	if(!selectNode.getAttribute('rel') || selectNode.getAttribute('rel').indexOf('wfHandled')==-1) {
				// 		//wFORMS.debug('switch/add event: '+ selectNode.className + ' ' + selectNode.tagName);
				// 		selectNode.setAttribute('rel', (selectNode.getAttribute('rel')||"") + ' wfHandled');
				// 		wFORMS.helpers.addEvent(selectNode, 'change', wFORMS.behaviors['jump'].run);
				// 	}							
				// 	break;
				// 	// TODO: should not evaluate on event, should return jump value/destination
				// 	case "INPUT":							
				// 	if(node.type && node.type.toLowerCase() == 'radio') {
				// 		// Add the onclick event on radio inputs of the same group
				// 		var formElement = node.form;	
				// 		for (var j=0; j<formElement[node.name].length; j++) {
				// 			var radioNode = formElement[node.name][j];
				// 			// prevents conflicts with elements with an id = name of radio group
				// 			if(radioNode.type.toLowerCase() == 'radio') {
				// 				// Make sure we have only one event handler for this radio input.
				// 				if(!radioNode.getAttribute('rel') || radioNode.getAttribute('rel').indexOf('wfHandled')==-1) {								
				// 					wFORMS.helpers.addEvent(radioNode, 'click', wFORMS.behaviors['jump'].run);
				// 					// flag the node 
				// 					radioNode.setAttribute('rel', (radioNode.getAttribute('rel')||"") + ' wfHandled');
				// 				} 
				// 			}
				// 		}
				// 	} else {
				// 		wFORMS.helpers.addEvent(node, 'click', wFORMS.behaviors['jump'].run);
				// 	}
				// 	break;
				// 
				// 	default:		
				// 	wFORMS.helpers.addEvent(node, 'click', wFORMS.behaviors['jump'].run);
				// 	break;
				// }
			}

			// Push targets in the wFORMS.jumpTargets array 
			// (associative array with switchname -> element ids)
			// ------------------------------------------------------------------------------------------
			if (wFORMS.helpers.hasClassPrefix(node, wFORMS.classNamePrefix_jmpZero) ||
			wFORMS.helpers.hasClassPrefix(node, wFORMS.classNamePrefix_jmpOne)) {

				if(!node.id) node.id = wFORMS.helpers.randomId();

				// Go through each class (one element can be the target of more than one switch).
				var jumpNames = wFORMS.behaviors['jump'].getJumpNames(node);

				for(var i=0; i < jumpNames.length; i++) {
					if(!wFORMS.jumpTargets[jumpNames[i]]) 
						wFORMS.jumpTargets[jumpNames[i]] = new Array();
					if(!wFORMS.jumpTargets[jumpNames[i]][node.id]) 
						wFORMS.jumpTargets[jumpNames[i]].push(node.id);
					wFORMS.debug('switch/evaluate: [target] '+ jumpNames[i],3);
					alert("jumptargets: " + wFORMS.jumpTargets.toString());
				}								
			}

			if(node.tagName && node.tagName.toUpperCase()=='FORM') {
				// function to be called when all behaviors for this form have been applied
				//wFORMS.debug('switch/push init');
				wFORMS.onLoadComplete.push(wFORMS.behaviors['jump'].init); 
			}
		},

		// ------------------------------------------------------------------------------------------
		// init: executed once evaluate has been applied to all elements
		// ------------------------------------------------------------------------------------------	   
		init: function() {
			// go through all jump triggers and activate those who are already ON
			wFORMS.debug('jumpName: '+ (wFORMS.jumpTriggers.length));
			// for(var jumpName in wFORMS.jumpTriggers) {
			// 	// go through all triggers for the current switch
			// 	for(var i=0; i< wFORMS.jumpTriggers[jumpName].length; i++) {		   
			// 		var element = document.getElementById(wFORMS.jumpTriggers[jumpName][i]);
			// 		wFORMS.debug('jumpName: ' + element + ' ' + jumpName , 5);	
			// 		if(wFORMS.behaviors['jump'].isTriggerOn(element,jumpName)) {
			// 			//alert("ON: " + wFORMS.behaviors['jump'].isTriggerOn(element,jumpName).toString() + " " + element.id + " " + element.className + " swName: " + jumpName)
			// 			// if it's a select option, get the select element
			// 			if(element.tagName.toUpperCase()=='OPTION') {
			// 				var element = element.parentNode;
			// 				while(element && element.tagName.toUpperCase() != 'SELECT') {
			// 					var element = element.parentNode;
			// 				}
			// 			}
			// 			// run the trigger
			// 			wFORMS.behaviors['jump'].run(element);
			// 		}
			// 
			// 	}
			// }
		},

		// ------------------------------------------------------------------------------------------
		// run: executed when the behavior is activated
		// ------------------------------------------------------------------------------------------	   
		run: function(e) {
			var element   = wFORMS.helpers.getSourceElement(e);
			if(!element) element = e;
			wFORMS.debug('switch/run: ' + element.id , 5);	

			var jumps_ONE  = new Array();
			var jumps_ZERO = new Array();

			// Get list of triggered switches (targets) (some ON, some OFF)
			switch(element.tagName.toUpperCase()) {
				case 'SELECT':  // is not used for selects, but could later implement jump on specific value
				for(var i=0;i<element.options.length;i++) {
					if(i==element.selectedIndex) {	
						jumps_ONE  = jumps_ONE.concat(wFORMS.behaviors['jump'].getJumpNames(element.options[i]));
					} else {
						jumps_ZERO = jumps_ZERO.concat(wFORMS.behaviors['jump'].getJumpNames(element.options[i]));
					}
				}

				break;
				case 'INPUT':
				if(element.type.toLowerCase() == 'radio') {
					// Go through the radio group.

					for(var i=0; i<element.form[element.name].length;i++) { 
						var radioElement = element.form[element.name][i];
						if(radioElement.checked) {
							// if element.hasClass(showIsOn)  switch off - put in hide (jumps_ZERO)
							// else put in show (jumps_ONE)
							jumps_ONE  = jumps_ONE.concat(wFORMS.behaviors['jump'].getJumpNames(radioElement));
							} else {  // unchecked
								// if element.hasClass(showIsOff)  switch on - put in show (jumps_ONE)
								// else put in hide (jumps_ZERO)
								wFORMS.debug(wFORMS.behaviors['jump'].getJumpNames(radioElement).length,1);
								jumps_ZERO = jumps_ZERO.concat(wFORMS.behaviors['jump'].getJumpNames(radioElement));
							}
						}
						} else {  // checkbutton. Does not depend of status of checkbutton. Switch states
							jumpNames = wFORMS.behaviors['jump'].getJumpNames(element);
							// alert("jumpnames: " + jumpNames);
							// for(var k=0; k<jumpNames.length; k++) {  // when one button, multiple switches and multiple targets, switch for all switches
								// targets = wFORMS.behaviors['jump'].getElementsByJumpName(jumpNames[k]);
								// for(var j=0; j<targets.length; j++) {   // we don't use targets
								// 	if( wFORMS.helpers.hasClassPrefix(targets[j], wFORMS.classNamePrefix_jmpOne)) { // if off, and check, set to ON
								// 		jumps_ZERO = jumps_ZERO.concat(wFORMS.behaviors['jump'].getJumpNames(targets[j]));
								// 	}
								// 	if( wFORMS.helpers.hasClassPrefix(targets[j], wFORMS.classNamePrefix_jmpZero)) { // if off, and check, set to ON
								// 		jumps_ONE = jumps_ONE.concat(wFORMS.behaviors['jump'].getJumpNames(targets[j]));
								// 	}
								// }
							// }								
						}
						break;
						default:
						break;
					}

					// Turn off switches first
					// for(var i=0; i < jumps_ZERO.length; i++) {
					// 	// Go through all targets of the switch 
					// 	var elements = wFORMS.behaviors['jump'].getElementsByJumpName(jumps_ZERO[i]);
					// 	for(var j=0;j<elements.length;j++) {
					// 
					// 		if(wFORMS.behaviors['jump'].isWithinJumpScope(element, elements[j])) {
					// 			// one of the triggers is still ON. no switch off
					// 			wFORMS.behaviors['jump'].jumpState(elements[j], wFORMS.classNamePrefix_jmpOne, wFORMS.classNamePrefix_jmpZero);
					// 			doSwitch = false;
					// 		}
					// 	}
					// }
					// // Turn on
					// for(var i=0; i < jumps_ONE.length; i++) {
					// 	var elements = wFORMS.behaviors['jump'].getElementsByJumpName(jumps_ONE[i]);
					// 	for(var j=0;j<elements.length;j++) {   // go thru all targets of the switch
					// 		// An element with the REPEAT behavior limits the scope of switches 
					// 		// targets outside of the scope of the switch are not affected. 
					// 		if(wFORMS.behaviors['jump'].isWithinJumpScope(element, elements[j])) {
					// 
					// 			wFORMS.behaviors['jump'].jumpState(elements[j], wFORMS.classNamePrefix_jmpZero, wFORMS.classNamePrefix_jmpOne);
					// 			wFORMS.debug('switch/run: [turn on ' + jumps_ONE[i] + '] ' + elements[j].id , 3);	
					// 		}
					// 	}
					// }
				},

				// ------------------------------------------------------------------------------------------
				// clear: executed if the behavior should not be applied anymore
				// ------------------------------------------------------------------------------------------
				clear: function(e) {
					// @TODO: go through wFORMS.jumpTriggers to remove events.
					wFORMS.jumpTriggers = {};		
					wFORMS.jumpTargets = {};

				},


				// ------------------------------------------------------------------------------------------
				// Get the list of switches 
				// Note: potential conflict if an element is both a switch and a target.
				getJumpNames: function(element) {
					var jumpNames = new Array();
					var classNames  = element.className.split(' ');
					for(var i=0; i < classNames.length; i++) {
						// Note: Might be worth keeping a prefix on jumpName to prevent collision with reserved names						
						if(classNames[i].indexOf(wFORMS.classNamePrefix_jump) == 0) {
							jumpNames.push(classNames[i].substr(wFORMS.classNamePrefix_jump.length+1));
						}
						// if(classNames[i].indexOf(wFORMS.classNamePrefix_jmpOne) == 0) {
						// 	jumpNames.push(classNames[i].substr(wFORMS.classNamePrefix_jmpOne.length+1));
						// }
						// else if(classNames[i].indexOf(wFORMS.classNamePrefix_jmpZero) == 0) {
						// 	jumpNames.push(classNames[i].substr(wFORMS.classNamePrefix_jmpZero.length+1));
						// }
					}
					// alert(jumpNames.inspect());
					return jumpNames;
				},
				
				// return hash { q7_12_2 : 0 }   { dest_id : jump_value}
				getJump: function(element) {
					var jumpTarget = new Array();
					var classNames  = element.className.split(' ');
					for(var i=0; i < classNames.length; i++) {
						// Note: Might be worth keeping a prefix on jumpName to prevent collision with reserved names						
						if(classNames[i].indexOf(wFORMS.classNamePrefix_jump) == 0) {
							//jumpNames.push
							jumpTarget.push(classNames[i].substr(wFORMS.classNamePrefix_jump.length+1));
						}
						if(classNames[i].indexOf(wFORMS.classNamePrefix_jmpState) == 0) {
							//jumpNames.push
							jumpTarget.push(classNames[i].substr(wFORMS.classNamePrefix_jmpState.length+1));
						}
						// alert("getJump: " + jumpTarget.toString());
					}
					return jumpTarget;
				},

				// ------------------------------------------------------------------------------------------
				// jumpState: function(element, oldStateClass, newStateClass) {		
				// 	if(!element || element.nodeType != 1) return;
				// 	if(element.className) {  		
				// 		element.className = element.className.replace(oldStateClass, newStateClass);
				// 	}		
				// 
				// 	// wFORMS.className_showIsOn						= "showIsOn";
				// 	// wFORMS.className_hideIsOn						= "hideIsOn";
				// 	// wFORMS.className_showIsOff					= "showIsOff";
				// 	// wFORMS.className_hideIsOff					= "hideIsOff";
				// 	if(wFORMS.helpers.hasClass(element, wFORMS.className_showIsOn)) { // set to showIsOff
				// 		element.className = element.className.replace(wFORMS.className_showIsOn, wFORMS.className_switchIsOff);
				// 	} else if(wFORMS.helpers.hasClass(element, wFORMS.className_showIsOff)) {
				// 		element.className = element.className.replace(wFORMS.className_showIsOff, wFORMS.className_showIsOn);
				// 	}	else if(wFORMS.helpers.hasClass(element, wFORMS.className_hideIsOn)) {
				// 		element.className = element.className.replace(wFORMS.className_hideIsOn, wFORMS.className_hideIsOff);
				// 	}	else if(wFORMS.helpers.hasClass(element, wFORMS.className_hideIsOff)) {
				// 		element.className = element.className.replace(wFORMS.className_hideIsOff, wFORMS.className_hideIsOn);
				// 	} 
				// 
				// 
				// 	// For  elements that don't have a native state variable (like checked, or selectedIndex)
				// 	if(wFORMS.helpers.hasClass(element, wFORMS.className_switchIsOff)) {
				// 		element.className = element.className.replace(wFORMS.className_switchIsOff, wFORMS.className_switchIsOn);
				// 	} else if(wFORMS.helpers.hasClass(element, wFORMS.className_switchIsOn)) {
				// 		element.className = element.className.replace(wFORMS.className_switchIsOn, wFORMS.className_switchIsOff);
				// 	}
				// },

				// ------------------------------------------------------------------------------------------
				// getElementsByJumpName: function(jumpName) {
				// 	var elements = new Array();
				// 	if(wFORMS.jumpTargets[jumpName]) {
				// 		for (var i=0; i<wFORMS.jumpTargets[jumpName].length; i++) {
				// 			var element = document.getElementById(wFORMS.jumpTargets[jumpName][i]);
				// 			if(element)
				// 			elements.push(element);
				// 		}
				// 	}
				// 	return elements;
				// },

				// ------------------------------------------------------------------------------------------
				// isTriggerOn: function(element, triggerName) {
				// 	if(!element) return false;
				// 	if(element.tagName.toUpperCase()=='OPTION') {
				// 		var selectElement = element.parentNode;
				// 		while(selectElement && selectElement.tagName.toUpperCase() != 'SELECT') {
				// 			var selectElement = selectElement.parentNode;
				// 		}
				// 		if(!selectElement) return false; // invalid markup					
				// 		if(selectElement.selectedIndex==-1) return false; // nothing selected
				// 		// TODO: handle multiple-select
				// 		if(wFORMS.helpers.hasClass(selectElement.options[selectElement.selectedIndex],
				// 			wFORMS.classNamePrefix_jump + '-' + triggerName)) {
				// 				return true;
				// 			}
				// 			} else { // maybe should only return On when element is checked
				// 				if(element.checked )//|| wFORMS.helpers.hasClass(element, wFORMS.className_switchIsOn)) 
				// 				return true;
				// 			}
				// 			return false;
				// 		},

						// isWithinJumpScope: An element with the REPEAT behavior limits the scope of switches 
						// targets outside of the scope of the switch are not affected. 
						// ------------------------------------------------------------------------------------------			
						// isWithinJumpScope: function(trigger, target) {
						// 
						// 	if(wFORMS.hasBehavior('repeat') && wFORMS.limitSwitchScope == true) { 
						// 		// check if the trigger is in a repeatable/removeable element
						// 		var scope = trigger;
						// 
						// 		while(scope && scope.tagName && scope.tagName.toUpperCase() != 'FORM' && 
						// 		!wFORMS.helpers.hasClass(scope, wFORMS.className_repeat) &&
						// 		!wFORMS.helpers.hasClass(scope, wFORMS.className_delete) ) {
						// 			scope = scope.parentNode;
						// 		}
						// 		if(wFORMS.helpers.hasClass(scope, wFORMS.className_repeat) || 
						// 		wFORMS.helpers.hasClass(scope, wFORMS.className_delete)) {
						// 			// yes, the trigger is nested in a repeat/remove element
						// 
						// 			// check if the target is in the same element.
						// 			var scope2 = target;
						// 			while(scope2 && scope2.tagName && scope2.tagName.toUpperCase() != 'FORM' && 
						// 			!wFORMS.helpers.hasClass(scope2, wFORMS.className_repeat) &&
						// 			!wFORMS.helpers.hasClass(scope2, wFORMS.className_delete) ) {
						// 				scope2 = scope2.parentNode;
						// 			}
						// 			if(scope == scope2) {
						// 				return true;  // target & trigger are in the same repeat/remove element		
						// 			} else {
						// 				return false; // target not in the same repeat/remove element,					
						// 			}
						// 		} else {
						// 			return true;	  // trigger is not nested in a repeat/remove element, scope unaffected
						// 		}
						// 		} else 
						// 		return true;
						// 	}
							} // END wFORMS.behaviors['jump'] object


						}