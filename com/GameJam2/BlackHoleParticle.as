 package com.GameJam2{
	
	import com.Box2D.Collision.Shapes.b2CircleDef;
	import com.Box2D.Dynamics.b2Body;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.display.BitmapData;
	import flash.geom.*;
	import flash.text.engine.BreakOpportunity;
	import flash.utils.Timer;
	
	import flash.display.Sprite;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;	
	
	import flash.events.Event;
	
	import com.Box2D.Collision.*;
	import com.Box2D.Collision.Shapes.*;
	import com.Box2D.Common.Math.*;
	import com.Box2D.Dynamics.*;
	import com.Particles.ParticleBlackHole;
	
	import com.reddengine.SoundEngine;
	
	import com.reddengine.ReddObject;
	import com.reddengine.ReddEngine;
	import flash.events.TimerEvent;
	public class BlackHoleParticle extends ReddObject	
	{
		public var particleBlackHole:ParticleBlackHole;
		
		public function BlackHoleParticle(x:Number=0, y:Number=0, r:Number=0, particleBH:ParticleBlackHole = null) 
		{
			particleBlackHole = particleBH;
			
			this.x = x;
			this.y = y;			
			
			value = Math.random() * 3 + 6;// 6 to 9
			if (Math.random() > .5) {//flip a coin for negative
				value *= -1;
			}
			numSymbol.numText.text = "" + value;
			
			//width = Math.abs(value) * 10;
			width = SetWidthBasedOnValue(value);
			height = width;	
			
			Density = 0;
			Friction = 1;
			isRound = true;			
			InitializePhysics();
			addEventListener(Event.ENTER_FRAME, Update);
			
			ReddEngine.blackHoleObjects.push(this);
		}
		
		override public function InitializePhysics():void
		{
			var BodyDef:b2BodyDef = new b2BodyDef();			
			BodyDef.position.Set((this.x)/ReddEngine.WORLD_CONSTANT, (this.y)/ReddEngine.WORLD_CONSTANT);			
									
			var CircleDef:b2CircleDef = new b2CircleDef();				
			CircleDef.radius = (this.width / 2) / ReddEngine.WORLD_CONSTANT;
			CircleDef.friction = Friction;				
			CircleDef.density = Density;	
			CircleDef.restitution = 1;
				
			Body=ReddEngine.getInstance().World.CreateBody(BodyDef);					
			Body.CreateShape(CircleDef);
			Body.m_linearDamping = 0.1;
			
			Body.SetUserData(this);
			
			Body.SetMassFromShapes();		
		}
		
		override public function Update(e:Event) :void  {					
			super.Update(e);
			
			numSymbol.numText.text = "" + value;
			numSymbol.rotation = rotation;
			
			if (debugEnabled)
				debug();							
									
			if (this.Delete)
				Destroy();
						
		}
		
		public function checkCollisions(robj:ReddObject) {
			trace("BLACKHOLE COLLISHUN!");
			if (robj is Particle)
			{
				if (value == -robj.value) {
					//if it matches our magic value
					//REMOVE BLACK HOLE AND ROBJ, YAY!!!!
					particleBlackHole.off();
					robj.Delete = true;
					this.Explode();
					SoundEngine.stopBHHum();
					SoundEngine.playExplosion();
					//explosion for effect?
				} else if (Math.abs(robj.value) < Math.abs(value)) {//if object is closer to 0 than black hole
					if(value > 0){//if it's opposite side of 0 as me
						robj.Delete = true;//eat it
					} else {
						value += robj.value;
						robj.Delete = true;//decrement and eat it
					}
				} else {
					//IGNORE THAT MOTHER FUCKER, TOO BIG TO EAT
					//robj.Delete = true;
				}									
			}
			else if (robj is Antiparticle)
			{
				if (value == -robj.value) {
					//if it matches our magic value
					//REMOVE BLACK HOLE AND ROBJ, YAY!!!!
					particleBlackHole.off();
					robj.Delete = true;
					this.Explode();
					SoundEngine.stopBHHum();
					SoundEngine.playExplosion();
					//explosion for effect?
				} else if (Math.abs(robj.value) < Math.abs(value)) {//if object is closer to 0 than black hole
					if(value < 0){//if it's on the same side of 0 as me
						robj.Delete = true;//eat it
					} else {
						value += robj.value;
						robj.Delete = true;//decrement and eat it
					}
				} else {
					//IGNORE THAT MOTHER FUCKER, TOO BIG TO EAT
					//robj.Delete = true;
				}	
			} else if (robj != null){
				//CONSUME THAT MOTHER FUCKER
				robj.Delete = true;
			}
		}
		
		override public function Destroy() : void {
			super.Destroy();
			ReddEngine.antiMatterObjects.splice(ReddEngine.antiMatterObjects.indexOf(this), 1);
		}
		
		override public function debug() : void {
			label.appendText("\nCol posy : " + this.y);
		}		
		
	}

}