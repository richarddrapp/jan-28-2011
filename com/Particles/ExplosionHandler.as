package com.Particles{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import com.reddengine.ReddEngine;
	
	public class ExplosionHandler extends MovieClip {
		
		public static var instance:ExplosionHandler = null;
		private static var allowCreation:Boolean = true;
		
		

        var explosions:Vector.<ParticleExplosion>;
		var implosions:Vector.<ParticleBlackHole>;

		public function ExplosionHandler() {
			explosions = new Vector.<ParticleExplosion>();
			implosions = new Vector.<ParticleBlackHole>();
			if (!allowCreation)
				throw new Error( "Invalid Singleton access. Please use ReddEngine.getInstance() instead." );
			else
			{
				instance = this;
				allowCreation = false;
				addEventListener(Event.ENTER_FRAME, onFrame);
				ReddEngine.getInstance().addChild(this);
			}	
		}
		
		public static function getInstance():ExplosionHandler {			
			if (instance == null)
			{								
				instance = new ExplosionHandler();
				allowCreation = false;
			}
			
			return instance;
			
			 
		}
		
		public function explode_at(x:Number, y:Number, number:int, force:int, r:int, g:int, b:int, a:Number, r_off:int, g_off:int, b_off:int, a_off:int, instant:Boolean) {
			var p:ParticleExplosion = new ParticleExplosion(x,y,number,force,r,g,b,a,r_off,g_off,b_off,a_off,instant);
			explosions.push(p);
			this.addChild(p);
			trace("KABOOM");
		}
		
		public function implode_at(x:Number, y:Number, number:int, radius:int ) {
			var p:ParticleBlackHole = new ParticleBlackHole(x, y, number, radius);
			implosions.push(p);
			this.addChild(p);
			trace("WOOOSH");
		}
		
		public function onFrame(e:Event) {
			update();
		}
		
		public function update() {
			//trace("explosions updated");
			for(var i = 0; i < explosions.length; i++) {
				explosions[i].update();
				if(explosions[i].finished == true) {
					removeChild(explosions[i]);
					explosions.splice(i,1);
					i--;
				}
			}
			for(i = 0; i < implosions.length; i++) {
				implosions[i].update();
			}
		}

	}
	
}
