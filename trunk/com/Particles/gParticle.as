package com.Particles{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flashx.textLayout.formats.Float;

	public class gParticle extends MovieClip {
		var age;
		var color;
		var t;
		var death_age;
		
		var angle;
		var xspeed;
		var yspeed;
		var drag;
		
		var decay:Boolean;
		var decay_at:Number;
		
		var live;
		
		var initial_speed;
		var direct;
		var spread;
		var face_dir;
		var a;
		
		var suck:Boolean;
		var go_x:Number;
		var go_y:Number;
		
		public function gParticle(death_age:Number, decay:Boolean, decay_at:Number, initial_speed:Number, direct:Number, spread:Number, drag:Number, face_dir:Boolean, r:int, g:int, b:int, a:Number) {
			age = 0;
			this.death_age = death_age;
			this.decay = decay;
			this.decay_at = decay_at;
			
			this.drag = drag;
			
			var t=new ColorTransform(0,0,0,1,r,g,b,0);
			this.transform.colorTransform = t;
			
			live = false;
			
			this.initial_speed = initial_speed;
			this.direct = direct;
			this.spread = spread;
			this.face_dir = face_dir;
			this.a = a;
		}
		
		public function update() {
			age++;
			x += xspeed;
			y += yspeed;
			
			xspeed *= drag;
			yspeed *= drag;
			
			if ((age > death_age * decay_at ) && (decay)) {
				alpha -= .05;
			}
			
			if (age >= death_age) {
				live = false;
			}
			
			if ((ExplosionHandler.getInstance().implosions.length > 0) && (!suck)) {
				var closest:ParticleBlackHole = ExplosionHandler.getInstance().implosions[0];
				var dist = Math.sqrt(ExplosionHandler.getInstance().implosions[0].x^2 + ExplosionHandler.getInstance().implosions[0].y^2);
				for (var i = 1; i < ExplosionHandler.getInstance().implosions.length; i++) {
					var dx = ExplosionHandler.getInstance().implosions[i].x - this.x;
					var dy = ExplosionHandler.getInstance().implosions[i].y - this.y;
					var nd = Math.sqrt(dx * dx + dy * dy);
					if (nd < dist) {
						dist = nd;
						closest = ExplosionHandler.getInstance().implosions[i];
					}
				}
				go_x = closest.x;
				go_y = closest.y;
				suck = true;
			}
				
			if(suck) {
				var xchange = go_x - this.x;
				var ychange = go_y - this.y;
				var mag = Math.sqrt(xchange ^ 2 + ychange ^ 2);
				xchange /= mag;
				ychange /= mag;
				xspeed += xchange/6;
				yspeed += ychange / 6;
				if (dist <= 50) {
					xspeed /= 2;
					yspeed /= 2;
				}
			}
		}
		
		public function respawn() {
			x = 0;
			y = 0;
			
			age = 0;
			
			angle = direct + Math.random()*spread*2 - spread;
			xspeed = initial_speed*Math.cos(angle)*(Math.random()/2 + .5);
			yspeed = initial_speed*Math.sin(angle)*(Math.random()/2 + .5);
			if(face_dir ==  true) {
				this.rotation = angle / Math.PI * 180;
			} else {
				this.rotation = Math.random() * 360;
			}
			
			this.alpha = a;
			live = true;
		}
	}
}