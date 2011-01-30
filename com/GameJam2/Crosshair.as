package com.GameJam2 {
	
	import flash.display.MovieClip;
	import flash.events.*;
	
	
	public class Crosshair extends MovieClip {
		
		
		public function Crosshair() {
			// constructor code
				addEventListener(Event.ENTER_FRAME, frameH);
		}
		
		public function frameH (e:Event) {
 			this.x = parent.mouseX;
 			this.y = parent.mouseY;
		}
		
	}
	
}
