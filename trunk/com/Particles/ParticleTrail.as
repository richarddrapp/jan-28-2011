package com.Particles {
	import com.GameJam2.BlackHoleParticle;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import com.reddengine.ReddObject;
	import com.reddengine.ReddEngine;
	public class ParticleTrail extends MovieClip {
		var radius:Number;
		
		var density = 2;
		
		var alive:Vector.<gParticle> = new Vector.<gParticle>();
		var dead:Vector.<gParticle> = new Vector.<gParticle>();
		
		var ison:Boolean;
		
		public function ParticleTrail(density:int, colorRed:Boolean, o:Number) {
			var p;
			var offset = (o * Math.PI) / 180;
			
			trace(o + "," + offset);
			
			for (var i = 0; i < 50; i++) {
					p = new gParticle(30, true, 0.5, 25, 0.5 * Math.PI + offset, Math.PI / 24, 0.95, true, 220, 120, 0, 0.8);
					//p = new gParticle(30, true, 0.5, 25, 0.5 * Math.PI + offset, Math.PI / 24, 0.95, true, 0, 0, 220, 0.8);
				dead.push(p);
			}
			
			ison = false;
		}

		public function update() {
			if (ison) {
				for(var i = 0; i < density; i++) {
					if(dead.length > 0) {
						var t:gParticle = dead[dead.length - 1];
						t.respawn();
						this.addChild(t);
						alive.push(t);
						dead.pop();
						//trace("SPAWN: " + alive.length + "," + dead.length + "   " + x + "," + y + "  " + x + parent.x + "," + y + parent.y);
					}
				}
			}
			for(i = 0; i < alive.length; i++) {
				alive[i].update();
				if(alive[i].live == false) {
					var u:gParticle = alive[i];
					this.removeChild(u);
					//dead.push(u);
					alive.splice(i,1);
				}
			}
		}
		
		public function on() {
			ison = true;
			trace("TRAIL ACTIVE");
		}
		
		public function off() {
			ison = false;
		}
	}
}