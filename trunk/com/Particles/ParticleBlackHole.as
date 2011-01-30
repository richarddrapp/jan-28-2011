package com.Particles {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	public class ParticleBlackHole extends MovieClip {
		var radius:Number;
		
		var density = 2;
		
		var alive:Vector.<bhParticle> = new Vector.<bhParticle>();
		var dead:Vector.<bhParticle> = new Vector.<bhParticle>();
		

		
		public function ParticleBlackHole(x:int, y:int, number:int, radius:Number) {
			this.radius = radius;
			
			this.x = x;
			this.y = y;
			
			var p;
			for (var i = 0; i < number; i++) {
				p = new bhParticle(radius);
				dead.push(p);
			}
		}

		public function update() {
			for(var i = 0; i < density; i++) {
			if(dead.length > 0) {
				var t:bhParticle = dead[dead.length - 1];
				t.respawn();
				this.addChild(t);
				alive.push(t);
				dead.pop();
				//trace("SPAWN: " + alive.length + "," + dead.length);
			}
			}
			for(i = 0; i < alive.length; i++) {
				alive[i].update();
				if(alive[i].live == false) {
					var t:bhParticle = alive[i];
					this.removeChild(t);
					dead.push(t);
					alive.splice(i,1);
				}
			}
			this.rotation += 0.5;
		}
	}
}