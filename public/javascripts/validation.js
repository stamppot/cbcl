/*
* Really easy field validation with Prototype
* http://tetlaw.id.au/view/javascript/really-easy-field-validation
* Andrew Tetlaw
* Version 1.5.4.1 (2007-01-05)
* 
* Copyright (c) 2007 Andrew Tetlaw
* Permission is hereby granted, free of charge, to any person
* obtaining a copy of this software and associated documentation
* files (the "Software"), to deal in the Software without
* restriction, including without limitation the rights to use, copy,
* modify, merge, publish, distribute, sublicense, and/or sell copies
* of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
* 
* The above copyright notice and this permission notice shall be
* included in all copies or substantial portions of the Software.
* 
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
* MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
* NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
* BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
* ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
* CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
* 
*/

var submitAction = false;

function tabOnValidate(result, elem) {
	if(result == 2) {
		window.status = "Du kan indtaste mere eller hoppe videre";
		elem.focus();
	}
	if(result == false) { 
		window.status = "Forkert værdi";
		elem.focus();
	}
	if(result == true) {
		window.status = "";
			tabNext(result, elem);
	}
}


function switched_off(elem) {
	var cn = $(elem).classNames();
  var off_state = /offstate/;

	var result = false;
	return cn.any(function(className) {
		result = off_state.test(className);
	});
	return result;
}

/* is a substring and not equal to a value in the array */
function is_a_substring(arr,val) {
	var eq_include = false;
	var isa_sub = false;
	$A(arr).each(function(v) {
		var v1 = new String(v);
		if(v1.startsWith(val)) {
		 	if(!(v1 == val)) { isa_sub = true; } // not equal, thus a sub string
			else { eq_include = true; }
		}
	});
	if(isa_sub) {
		// alert("a substring: " + val + " in " + arr.inspect());
		return 2;
	}
	if(eq_include) {
		// alert("included: " + val + " in " + arr.inspect());
		return 1;
	} else { return 0; }
}


var Validator = Class.create();

Validator.prototype = {
	initialize : function(className, error, test, options) {
		if(typeof test == 'function'){
			this.options = $H(options);
			this._test = test;
		} else {
			this.options = $H(test);
			this._test = function(){return true;};
		}
		this.error = error || 'Validation failed.';
		this.className = className;
	},
	test : function(v, elm) { // class Validator
		// return (this._test(v,elm) && this.options.all(function(p){ // must be able to return 0,1, or 2 for maybe
		var tested_options = 	this.options.collect(function(p){ // must be able to return 0,1, or 2 for maybe
				// alert("Validator.test.  p: " + p.inspect() + "\nkey: " + p.key);
				if(Validator.methods[p.key]) {
					return Validator.methods[p.key](v,elm,p.value);
				}
			});
			
		return (this._test(v,elm) && this.options.collect(function(p){ // must be able to return 0,1, or 2 for maybe
			if(Validator.methods[p.key]) {
				return Validator.methods[p.key](v,elm,p.value);
			}
			
			return Validator.methods[p.key] ? Validator.methods[p.key](v,elm,p.value) : 1;
		}));
	}
};
Validator.methods = {
	pattern : function(v,elm,opt) {return Validation.get('IsEmpty').test(v) || opt.test(v);},
	minLength : function(v,elm,opt) {return v.length >= opt;},
	maxLength : function(v,elm,opt) {return v.length <= opt;},
	min : function(v,elm,opt) {return v >= parseFloat(opt);}, 
	max : function(v,elm,opt) {return v <= parseFloat(opt);},
	notOneOf : function(v,elm,opt) {return $A(opt).all(function(value) {
		return (v != value);
	});},
	oneOf : function(v,elm,opt) {return $A(opt).any(function(value) {
		return v.blank() || (v == value);
	});},
	is : function(v,elm,opt) {return (v == opt);},
	isNot : function(v,elm,opt) {return (v != opt ? 1 : 0);},
	equalToField : function(v,elm,opt) {return (v == $F(opt) ? 1 : 0);},
	notEqualToField : function(v,elm,opt) {return (v != $F(opt) || (v == "88"));},  // not equal to field, except for value 88 (other)
	include : function(v,elm,opt) {return $A(opt).all(function(value) {
		return Validation.get(value).test(v,elm);
	});},
	xOneOf : function(v,elm,opt) { // alert("xOneOf aar: " + opt.inspect() +  "  v: " + v);
		return v.blank() || is_a_substring(opt, v);
	},
	jumpZero : function(v,elm,opt) { if(v == "0") { return $(opt); } },
  jumpNotZero : function(v,elm,opt) {  if(v == "0") { $(opt).focus(); } }
};


var Validation = Class.create();

Validation.prototype = {
	initialize : function(form, options){
		this.options = Object.extend({
			onSubmit : true, // false
			stopOnFirst : false,
			immediate : false,
			focusOnError : true,
			useTitles : false,
			onFormValidate : function(result, form) {},   // return result will prevent submitting?
			onElementValidate : function(result, elm) {}
		}, options || {});
		this.form = $(form);
		if(this.options.onSubmit) Event.observe(this.form,'submit',this.onSubmit.bind(this),false);

		if(this.options.immediate) {
			var useTitles = this.options.useTitles;
			var callback = this.options.onElementValidate;
			var inputs = Form.getInputs(this.form);

			inputs.each(function(input) {
				var classNames  = input.className.split(' ');
				
				var jumpOnTab = $A(classNames).any(function(klassName) {
					return ((klassName == 'rating') || (klassName == 'selectoption'));
				});
				
				if(jumpOnTab) {  // tab jumping can only happen on ratings and selectoptions
				Event.observe(input, 'keyup', function(ev) {
					
					if((Event.element(ev).id == 'submit_btn')) {
						alert("Pressing submit");
						submitAction = true;
					}
					else if((Event.element(ev).className == 'comment') ) {
				  		false;
				  }
				  else {
						submitAction = false;
					
					  switch (ev.keyCode) {
				    	case Event.KEY_RETURN:
							// alert("Du har trykket return");
							submitAction = false;
							var valid_result = Validation.validate(Event.element(ev),{useTitle : useTitles}); //, onElementValidate : tabOnValidate });
							tabOnValidate(valid_result, input);
				    	break;
						case Event.KEY_ENTER:
							var elem = (Event.element(ev)).id;
							// alert("Du kom til at trykke enter. (" + elem.id + ")");
							// todo: activate $(Event.element(ev).id).activate();
							submitAction = false;
							// $(elem).activate();
							if (ev.stopPropagation) {
								ev.stopPropagation();
								if (ev.preventDefault) ev.preventDefault( );
							  	else { ev.returnValue = false; }
							}
					  	  	Event.stop(ev);
							// alert("Du har trykket enter.");
							//tabOnValidate(valid_result, input);
							break;
						case 13: // enter in IE
							var elem = (Event.element(ev)).id;
							// alert("Du kom til at trykke enter. (" + elem.id + ")");
							submitAction = false;
							// $(elem).activate();
							if (ev.stopPropagation) {
								ev.stopPropagation();
								if (ev.preventDefault) ev.preventDefault( );
							  	else { ev.returnValue = false; }
							}
							submitAction = false;
					  	  	Event.stop(ev);
							break;
						case 3: // enter in safari?
						var elem = (Event.element(ev)).id;
						// alert("Du kom til at trykke enter (3). (" + elem.id + ")");
						submitAction = false;
						// $(elem).activate();
						if (ev.stopPropagation) {
							ev.stopPropagation();
							if (ev.preventDefault) ev.preventDefault( );
						  	else { ev.returnValue = false; }
						}
						submitAction = false;
				  	  	Event.stop(ev);
						break;
							// var valid_result = Validation.validate(Event.element(ev),{useTitle : useTitles}); //, onElementValidate : tabOnValidate });
							// break;
				    	case Event.KEY_UP: 
				    	  return tabPrev(true, Event.element(ev));
				    	break;
				    	case Event.KEY_DOWN: 
				    	  return tabNext(true, Event.element(ev));
				    	break;
				    	case 72:  // when 'h' is pressed, field help is toggled
				    	  var c_names = Event.element(ev).className.split(' ');
				    	  for(var i=0; i < c_names.length; i++) {
				    	  	if(c_names[i].indexOf('q') == 0) {
				    	  		var help_tip = $('help_' + c_names[i]);
				    	  		if(help_tip != null) {
				    	  			Element.toggle("help_" + c_names[i]);
				    	  			Event.element(ev).clear();
					  	  			submitAction = false;
				    	  			false;
				    	  		}
				    	  	}
				    	  }
				    	  break;
					  	default:
					  	  // alert("key " + ev.keyCode);
					  	  var wrong_key = false;
					  	  var filter = [0,8,9,13,16,17,18,37,38,39,40,46,91,224]; 	// if tab, do not do validation
					  	    wrong_key = $A(filter).any(function(i) {
					  	    	return (ev.keyCode == i);
					  	    });
					  	  if(wrong_key) {
					  	  	submitAction = false;
							// alert("Wrong key pressed: " + ev.keyCode());
					  	  	Event.stop(ev);
				  			return false;
				  	  	  }
						  else {
							// no wrong keys pressed, now do validation
							var valid_result = Validation.validate(Event.element(ev),{useTitle : useTitles}); //, onElementValidate : tabOnValidate });
							// alert("jeeah " + valid_result);
							tabOnValidate(valid_result, input);
						  }
				      }
						submitAction = false;
						if (ev.stopPropagation) {
							ev.stopPropagation();
							if (ev.preventDefault) ev.preventDefault( );
						  	else { ev.returnValue = false; }
						}
					}
				}); // end observe
			}
			});
		}
	},
	onSubmit :  function(ev){
		if(!submitAction) {
			window.status = "";
			Event.stop(ev);
			return false;
		}
		// window.status = "Sender besvarelse...";
		return true;
	},
	validate : function() {
		var result = false;
		var useTitles = this.options.useTitles;
		var callback = this.options.onElementValidate;
		// alert("Validation.validate() begin")
		if(this.options.stopOnFirst) {
			// something goes wrong here, validation returns always true
			result = Form.getElements(this.form).any(function(elm) { 
				// if any fails, it stops validating
				var valid_result = Validation.validate(elm,{useTitle : useTitles, onElementValidate : callback});
				return !valid_result;
			});
			result = !result;  // turn around, 'any' above returns when a validation fails. This should be false then
		} else {
			result = Form.getElements(this.form).collect(function(elm) { return Validation.validate(elm,{useTitle : useTitles, onElementValidate : callback}); }).all();
		}
		if(!result && this.options.focusOnError) {
			Form.getElements(this.form).findAll(function(elm){return $(elm).hasClassName('validation-failed');}).first().focus();
		}
		this.options.onFormValidate(result, this.form);
		return result;
	},
	reset : function() {
		Form.getElements(this.form).each(Validation.reset);
	}
};

Object.extend(Validation, {
	validate : function(elm, options){
		options = Object.extend({
			useTitle : false,
			onElementValidate : function(result, elm) { }
		}, options || {});
		elm = $(elm);
		// clean up
		elm.removeClassName('validation-passed');
		elm.removeClassName('validation-maybe');
		elm.removeClassName('validation-failed');
		var cn = elm.classNames();
		var valid_results = cn.map(function(value) {
			var test = Validation.test(value,elm,options.useTitle);
			options.onElementValidate(test, elm);
			return test;
		});
		
		var all_tests_result = true;
		if(valid_results.include(false)) { all_tests_result = false; }  // should fail before maybe
		else if(valid_results.include(2)) { all_tests_result = 2; }
		else if(valid_results.include(true)) { all_tests_result = true; }
		// runs onElementValidate when all an element's validations are dones
		return all_tests_result;
	},
	test : function(name, elm, useTitle) {  // class Validation
		var v = Validation.get(name);
		var prop = '__advice'+name.camelize();
		try {
			var test_result = v.test($F(elm), elm);  // calls Validator  // test_results becomes an array of results somehow
			var visible = Validation.isVisible(elm);
			// alert("Validation.test: validation: " + v + "  elem: " + elm.id + "\n" + "test_result: " + test_result);
			var any_false = $A(test_result).any(function(val) { return val == 0; });
			var any_maybe = $A(test_result).include(2); //any(function(val) { return val == 2; });
			
			if(visible && any_false) {
				if(!elm[prop]) {  // add error message for specific validation
					var advice = Validation.getAdvice(name, elm);
					if(advice == null) {
						var errorMsg = useTitle ? ((elm && elm.title) ? elm.title : v.error) : v.error;
						advice = '<div class="validation-advice" id="advice-' + Validation.getElmID(elm) +'" style="display:none;">' + errorMsg + '</div>';
						switch (elm.type.toLowerCase()) {
							case 'checkbox':
							case 'radio':
							var p = elm.parentNode;
							if(p) {
								new Insertion.Top(p, advice);
								// new Insertion.Bottom(p, advice);
							} else {
								new Insertion.Before(elm, advice);
								// new Insertion.After(elm, advice);
							}
							break;
							default:
							//new Insertion.Before(elm, advice);
							new Insertion.After(elm, advice);
						}
						new Insertion.After(elm, advice);
						advice = Validation.getAdvice(name, elm);  // now it's a HTML element
					}
					if(typeof Effect == 'undefined') {
						advice.style.display = 'block';
					} else {
						new Effect.Appear($(advice.id), {duration : 1 });
					}
				}
				elm[prop] = true;
				elm.removeClassName('validation-passed');
				elm.removeClassName('validation-maybe');
				elm.addClassName('validation-failed');
				return false;
			}
			else if(visible && any_maybe) { // maybe
				var advice = Validation.getAdvice(name, elm);
				if(advice != null) advice.hide();
				elm[prop] = '';
				elm.removeClassName('validation-passed');
				elm.removeClassName('validation-failed');
				elm.addClassName('validation-maybe');
				return 2;
			}				
			else {  //   if tested true
				var advice = Validation.getAdvice(name, elm);
				if(advice != null) advice.hide();
				elm[prop] = '';
				elm.removeClassName('validation-failed');
				elm.removeClassName('validation-maybe');
				elm.addClassName('validation-passed');
				return true;
			}
		} catch(e) {
			throw(e);
		}
	},
	/* is visible and not switched off */
	isVisible : function(elm) {
		/* checking for visibility up to enclosing table cell */
		while(elm.tagName != 'TD') {
			var elm = $(elm);

			if(switched_off(elm))
				return false;

			if(!$(elm).visible())
				return false;

			elm = elm.parentNode;
		}
		return true;
	},
	getAdvice : function(name, elm) {
		// return $('advice-' + name + '-' + Validation.getElmID(elm)) || $('advice-' + Validation.getElmID(elm));
		return $('advice-' + Validation.getElmID(elm));
	},
	getElmID : function(elm) {
		return elm.id ? elm.id : elm.name;
	},
	reset : function(elm) {
		elm = $(elm);
		var cn = elm.classNames();
		cn.each(function(value) {
			var prop = '__advice'+value.camelize();
			if(elm[prop]) {
				var advice = Validation.getAdvice(value, elm);
				advice.hide();
				elm[prop] = '';
			}
			elm.removeClassName('validation-failed');
			elm.removeClassName('validation-passed');
			elm.removeClassName('validation-maybe');
		});
	},
	add : function(className, error, test, options) {
		var nv = {};
		nv[className] = new Validator(className, error, test, options);
		Object.extend(Validation.methods, nv);
	},
	addAllThese : function(validators) {
		var nv = {};
		$A(validators).each(function(value) {
				nv[value[0]] = new Validator(value[0], value[1], value[2], (value.length > 3 ? value[3] : {}));
			});
		Object.extend(Validation.methods, nv);
	},
	get : function(name) {
		return  Validation.methods[name] ? Validation.methods[name] : Validation.methods['_LikeNoIDIEverSaw_'];
	},
	methods : {
		'_LikeNoIDIEverSaw_' : new Validator('_LikeNoIDIEverSaw_','',{})
	}
});

Validation.add('IsEmpty', '', function(v) {
				return  (((v == null) || (v.length == 0)) ? 1 : 0); // || /^\s+$/.test(v));
			});

Validation.addAllThese([
	['required', 'This is a required field.', function(v) {
				return (!Validation.get('IsEmpty').test(v) ? 1 : 0);
			}],
	['validate-number', 'Please enter a valid number in this field.', function(v) {
				return Validation.get('IsEmpty').test(v) || (!isNaN(v) && !(/^\s+$/).test(v));
			}],
	['validate-digits', 'Please use numbers only in this field. please avoid spaces or other characters such as dots or commas.', function(v) {
				return Validation.get('IsEmpty').test(v) ||  !(/[^\d]/).test(v);
			}],
	['validate-alpha', 'Please use letters only (a-z) in this field.', function (v) {
				return Validation.get('IsEmpty').test(v) ||  (/^[a-zA-Z]+$/).test(v);
			}],
	['validate-alphanum', 'Please use only letters (a-z) or numbers (0-9) only in this field. No spaces or other characters are allowed.', function(v) {
				return Validation.get('IsEmpty').test(v) ||  !(/\W/).test(v);
			}],
	['validate-date', 'Please enter a valid date.', function(v) {
				var test = new Date(v);
				return Validation.get('IsEmpty').test(v) || !isNaN(test);
			}],
	['validate-email', 'Please enter a valid email address. For example fred@domain.com .', function (v) {
				return Validation.get('IsEmpty').test(v) || (/\w{1,}[@][\w\-]{1,}([.]([\w\-]{1,})){1,3}$/).test(v);
			}],
	['validate-url', 'Please enter a valid URL.', function (v) {
				return Validation.get('IsEmpty').test(v) || (/^(http|https|ftp):\/\/(([A-Z0-9][A-Z0-9_-]*)(\.[A-Z0-9][A-Z0-9_-]*)+)(:(\d+))?\/?/i).test(v);
			}],
	['validate-date-au', 'Please use this date format: dd/mm/yyyy. For example 17/03/2006 for the 17th of March, 2006.', function(v) {
				if(Validation.get('IsEmpty').test(v)) return true;
				var regex = /^(\d{2})\/(\d{2})\/(\d{4})$/;
				if(!regex.test(v)) return false;
				var d = new Date(v.replace(regex, '$2/$1/$3'));
				return ( parseInt(RegExp.$2, 10) == (1+d.getMonth()) ) && 
							(parseInt(RegExp.$1, 10) == d.getDate()) && 
							(parseInt(RegExp.$3, 10) == d.getFullYear() );
			}],
	['validate-currency-dollar', 'Please enter a valid $ amount. For example $100.00 .', function(v) {
				// [$]1[##][,###]+[.##]
				// [$]1###+[.##]
				// [$]0.##
				// [$].##
				return Validation.get('IsEmpty').test(v) ||  (/^\$?\-?([1-9]{1}[0-9]{0,2}(\,[0-9]{3})*(\.[0-9]{0,2})?|[1-9]{1}\d*(\.[0-9]{0,2})?|0(\.[0-9]{0,2})?|(\.[0-9]{1,2})?)$/).test(v);
			}],
	['validate-selection', 'Please make a selection', function(v,elm){
				return elm.options ? elm.selectedIndex > 0 : !Validation.get('IsEmpty').test(v);
			}],
	['validate-one-required', 'Please select one of the above options.', function (v,elm) {
				var p = elm.parentNode;
				var options = p.getElementsByTagName('INPUT');
				return $A(options).any(function(elm) {
					return $F(elm);
				});
			}]
]);
