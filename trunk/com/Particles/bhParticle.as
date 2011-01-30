package com.Particles {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flashx.textLayout.formats.Float;

	public class bhParticle extends MovieClip {
		var xspeed;
		var yspeed;
		
		var live;
		
		var drag = 0.999;
		
		var radius:Number;
		
		
		var px:Boolean;
		var py:Boolean;
		
		
		public function bhParticle(radius:Number) {
			
			var t=new ColorTransform(0,0,0,1,0,0,0,0);
			this.transform.colorTransform = t;
			
			live = false;
			this.radius = radius;
			
			this.scaleX = 2;
			this.scaleY = 2;
		}
		
		public function update() {
			x += xspeed;
			y += yspeed;
			
			xspeed *= drag;
			yspeed *= drag;
			
			alpha = 1 - Math.sqrt(x*x + y*y) / radius;;
			//
			//trace(alpha);
			
			if (((px) && (x <= 0)) && ((py) && (y <= 0))) {
				live = false;
			}
			if (((!px) && (x >= 0)) && ((!py) && (y >= 0))) {
				live = false;
			}
			if (((px) && (x <= 0)) && ((!py) && (y >= 0))) {
				live = false;
			}
			if (((!px) && (x >= 0)) && ((py) && (y <= 0))) {
				live = false;
			}
			
	
			
		}
		
		public function respawn() {
			x = 10; 
			y = 10;
			var angle;
			
				angle = Math.random() * Math.PI * 2;
				x = Math.cos(angle) * radius;
				y = Math.sin(angle) * radius;
			
			
			this.rotation = angle / Math.PI * 180 + 90;
			
			xspeed = (-1) * Math.cos(angle) / 4;
			yspeed = (-1) * Math.sin(angle) / 4;
			
			this.alpha = 0;
			live = true;
			//trace(" " + x + "," + y);
			
			if(x > 0) {
				px = true;
			} else {
				px = false;
			}
			if(y > 0) {
				py = true;
			} else {
				py = false;
			}
		}
	}
}