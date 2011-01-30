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