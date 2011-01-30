package com.Particles {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	
	public class ParticleTest extends MovieClip {
		var b;
		var counter;
		var handle:ExplosionHandler;
		//var hole:ParticleBlackHole;
		public function ParticleTest() {
			counter = 0;
			
			this.addEventListener(Event.ENTER_FRAME,EnterFrameHandler);
			//this.addEventListener(MouseEvent.MOUSE_UP,MouseUpHandler);
			handle = new ExplosionHandler();
			this.addChild(handle);
			//hole = new ParticleBlackHole(100,100,1000,80);
			//this.addChild(hole);
		}
		
		function EnterFrameHandler(event:Event) {		
			handle.update();
			
			if(counter % 80 == 0) {
				handle.explode_at(Math.random() * 500, Math.random() * 500, 50, 12, Math.random() * 220, Math.random() * 220, Math.random() * 220, 0.8, Math.random() * 220, Math.random() * 220, Math.random() * 220, 0.1, true);
			}
			if (counter == 50) {
				handle.implode_at(250, 250, 1000, 60);
			}
			
			counter++;
			//hole.update();
		}
	}
}