package com.Particles {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	public class ParticleExplosion extends MovieClip {
		var age;
		var die_on_end:Boolean;
		var finished:Boolean;
		
		var alive:Vector.<gParticle> = new Vector.<gParticle>();
		var dead:Vector.<gParticle> = new Vector.<gParticle>();
		
		public function ParticleExplosion(x:int, y:int, number:int, force:int, r:int, g:int, b:int, a:Number, r_off:int, g_off:int, b_off:int, a_off, instant:Boolean) {
			age = 0;
			die_on_end = false;
			
			this.x = x;
			this.y = y;

			
			var p;
			for (var i = 0; i < number; i++) {
				p = new gParticle(50,true,0.5,force,0,Math.PI,0.92,true, r + Math.random() * r_off, g + Math.random() * g_off, b + Math.random() * b_off, a + Math.random() * a_off);
				dead.push(p);
			}
			
			if(instant) {
				explode(instant);
			}
			
			finished = false;
		}
		
		public function explode(destroy_on_completion) {
			while(dead.length > 0) {
				dead[dead.length -1].respawn();
				this.addChild(dead[dead.length - 1]);
				alive.push(dead[dead.length - 1]);
				dead.pop();
			}
			if(destroy_on_completion) {
				die_on_end = true;
			}
		}

		public function update() {
			for (var i = 0; i < alive.length; i++) {
				if(alive[i].live == true) {
					alive[i].update();
				} else {
					this.removeChild(alive[i]);
					dead.push(alive[i]);
					alive.splice(i,1);
					i--;
				}
			}
			if ((die_on_end) && (alive.length <= 0)) {
				finished = true;
			}
		}
	}
}