 package com.GameJam2{
	
	import com.Box2D.Collision.Shapes.b2CircleDef;
	import com.Box2D.Dynamics.b2Body;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.display.BitmapData;
	import flash.geom.*;
	import flash.text.engine.BreakOpportunity;
	
	import flash.display.Sprite;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;	
	
	import flash.events.Event;
	
	import com.Box2D.Collision.*;
	import com.Box2D.Collision.Shapes.*;
	import com.Box2D.Common.Math.*;
	import com.Box2D.Dynamics.*;
	
	import com.reddengine.ReddObject;
	import com.reddengine.ReddEngine;
	
	public class Particle extends ReddObject {				
		
		public function Particle(x:Number, y:Number, r:Number) {				
			super(); //density = 0.7								
			
			this.x = x;
			this.y = y;
			this.width = r*2;
			this.height = r*2;
			
			Density = 2;
			Friction = 10;
			isRound = true;			
			InitializePhysics();
			addEventListener(Event.ENTER_FRAME, Update);
		}
		
		override public function InitializePhysics():void
		{
			var BodyDef:b2BodyDef = new b2BodyDef();			
			BodyDef.position.Set((this.x)/ReddEngine.WORLD_CONSTANT, (this.y)/ReddEngine.WORLD_CONSTANT);			
									
			var CircleDef:b2CircleDef = new b2CircleDef();				
			CircleDef.radius = (this.width / 2 -2 ) / ReddEngine.WORLD_CONSTANT;
			CircleDef.friction = Friction;				
			CircleDef.density = Density;	
			CircleDef.restitution = 0;
				
			Body=ReddEngine.getInstance().World.CreateBody(BodyDef);					
			Body.CreateShape(CircleDef);						
			
			Body.SetMassFromShapes();		
		}
		
		override public function Update(e:Event) :void  {					
			super.Update(e);
			//this.x -= 1;												
			if (debugEnabled)
				debug();							
			
			checkCollisions();
		}		
		
		public function checkCollisions():void {
			var robj:ReddObject;
			for (var x:int = 0; x < ReddEngine.reddObjects.length; x++)
			{
				robj = ReddEngine.reddObjects[x];
				if (ReddEngine.getInstance().DetectCollision(this, robj) && robj != this)
				{	
					if (robj is Antiparticle)
					{
						trace("ANIHILATION");
						var numToSpawn:int = this.width / 11;
						var newPart:Particle;
						
						this.parent.removeChild(robj);
						this.removeEventListener(Event.ENTER_FRAME, robj.Update);
						ReddEngine.getInstance().World.DestroyBody(this.Body);
						
						for (var x:int = 0; x < numToSpawn; x++)
						{
							newPart = new Particle(this.x + Math.random() * 20 -10, this.y + Math.random() * 20 - 10, 10);
							newPart.Body.SetLinearVelocity(new b2Vec2(Math.random() * 6 -3, Math.random() * 6 - 3));
							ReddEngine.getInstance().addChild(newPart);
							ReddEngine.reddObjects.push(newPart);
						}
					}
				}
			}
		}
		
		override public function debug() : void {
			label.appendText("\nCol posy : " + this.y);
		}								
		
	}
 }