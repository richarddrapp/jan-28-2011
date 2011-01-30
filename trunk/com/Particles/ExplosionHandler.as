package com.Particles{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	
	public class ExplosionHandler extends MovieClip{

        var explosions:Vector.<ParticleExplosion>;

		public function ExplosionHandler() {
			explosions = new Vector.<ParticleExplosion>();
		}
		
		public function explode_at(x:Number, y:Number, number:int, force:int, r:int, g:int, b:int, a:Number, r_off:int, g_off:int, b_off:int, a_off:int, instant:Boolean) {
			var p:ParticleExplosion = new ParticleExplosion(x,y,number,force,r,g,b,a,r_off,g_off,b_off,a_off,instant);
			explosions.push(p);
			this.addChild(p);
		}
		
		public function update() {
			for(var i = 0; i < explosions.length; i++) {
				explosions[i].update();
				if(explosions[i].finished == true) {
					removeChild(explosions[i]);
					explosions.splice(i,1);
					i--;
				}
			}
		}

	}
	
}
