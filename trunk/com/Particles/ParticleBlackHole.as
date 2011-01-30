package com.Particles {
	import com.GameJam2.BlackHoleParticle;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import com.reddengine.ReddObject;
	import com.reddengine.ReddEngine;
	public class ParticleBlackHole extends MovieClip {
		var radius:Number;
		
		var density = 4;
		
		var alive:Vector.<bhParticle> = new Vector.<bhParticle>();
		var dead:Vector.<bhParticle> = new Vector.<bhParticle>();
		
		var on:Boolean;
		
		var blackHoleParticle:BlackHoleParticle;
		
		//physics implode variables for black hole
		public var ImplodeObject:ReddObject;
		public var ImplodeRadius:Number;
		public var ImplodeMinval:Number;
		public var ImplodeMaxval:Number;
		
		public function ParticleBlackHole(x:int, y:int, number:int, radius:Number) {
			this.radius = radius;
			
			this.x = x;
			this.y = y;
			
			trace("BH.X = " + this.x);
			trace("BH.Y = " + this.y);
			
			blackHoleParticle = new BlackHoleParticle(this.x, this.y, 20);
			ReddEngine.getInstance().addChild(blackHoleParticle);
			
			var p;
			for (var i = 0; i < number; i++) {
				p = new bhParticle(radius);
				dead.push(p);
			}
			
			on = true;
		}
		
		public function setImplosivePhysicsAttributes(reddObj:ReddObject, radius:Number, minval:Number, maxval:Number) {
			ImplodeObject = reddObj;
			ImplodeRadius = radius;
			ImplodeMinval = minval;
			ImplodeMaxval = maxval;
		}

		public function update() {
			if (on) {
				ImplodeObject.applyExplosiveImpulse(ImplodeObject.x, ImplodeObject.y, ImplodeRadius, ImplodeMinval, ImplodeMaxval);
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
		
		public function off() {
			on = false;
		}
	}
}