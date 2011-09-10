/**
 * Copyright (C) 2011 by Matthew Wagerfield
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

//CREATE VARIABLES
var as_swf_name = "flashContent";
var initialised = false;
var IE = document.all ? true : false;
var swfPosition = {
	x : 0,
	y : 0
}
var docMouseX = 0;
var docMouseY = 0;
var swfMouseX = 0;
var swfMouseY = 0;
var delta = 0;

// EXTERNAL MOUSE
var externalmouse = {
	// INITIALISE EXTERNAL MOUSE
	init : function(swfName) {
		as_swf_name = swfName;

		if (!IE) {
			document.captureEvents(Event.MOUSEMOVE);
		}
		if (window.addEventListener) {
			window.addEventListener("DOMMouseScroll", this.onMouseWheel, false);
		}
		window.onmousemove = document.onmousemove = this.onMouseMove;
		window.onmousewheel = document.onmousewheel = this.onMouseWheel;

		initialised = true;
	},

	// CHECK TO SEE IF THE EXTERNAL MOUSE IS INITIALISED
	isInitialised : function() {
		document[as_swf_name].onMouseInit(initialised);
	},

	// ON MOUSE MOVE
	onMouseMove : function(e) {
		if (IE) {
			docMouseX = e.clientX + document.body.scrollLeft;
			docMouseY = e.clientY + document.body.scrollTop;
		} else {
			docMouseX = e.pageX;
			docMouseY = e.pageY;
		}
		if (docMouseX < 0) {
			docMouseX = 0
		}
		if (docMouseY < 0) {
			docMouseY = 0
		}

		swfPosition = utils.getObjectPosition(document[as_swf_name]);

		swfMouseX = docMouseX - swfPosition.x;
		swfMouseY = docMouseY - swfPosition.y;

		document[as_swf_name].onMouseMove(docMouseX, docMouseY, swfMouseX, swfMouseY);
	},

	// ON MOUSE WHEEL
	onMouseWheel : function(e) {
		if (IE) {
			e = window.event;
		}
		if (e.wheelDelta) {
			delta = e.wheelDelta / 120;
		} else {
			delta = -e.detail / 3;
		}
		document[as_swf_name].onMouseWheel(delta, e.ctrlKey, e.altKey,
				e.shiftKey);
	}
}