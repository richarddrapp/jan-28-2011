 package com.reddengine{
	
	import com.GameJam2.Particle;
	import com.GameJam2.Antiparticle;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.display.BitmapData;
	import flash.events.TimerEvent;
	import flash.geom.*;
	import flash.utils.Timer;
	
	import flash.display.Sprite;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
	
	import com.Box2D.Collision.*;
	import com.Box2D.Collision.Shapes.*;
	import com.Box2D.Common.Math.*;
	import com.Box2D.Dynamics.*;

	import flash.events.Event;
	
	import com.Particles.ExplosionHandler;
	
	public class ReddObject extends MovieClip{
	
		
		public var deadified:Boolean = false;
		public var stageRef:Stage;		
		public var engineRef:ReddEngine;								
		public var debugEnabled:Boolean;
		public var Delete:Boolean = false;
		private var timer:Timer;
		
		public var grounded:Boolean;		
		public var Velocity:b2Vec2;				
		public var label:TextField;
				
		public var isStatic:Boolean = false;
		public var isRound:Boolean = false;
		
		//physics vars
		public var Body:b2Body;		
		public var Density:Number;
		public var Friction:Number;
		
		public var value:int;

		public function ReddObject()
		{
			//trace("Called by sublcass");		
							 							
			label = new TextField();  
			var format:TextFormat = new TextFormat();
            format.font = "Verdana";
            format.color = 0xFFFFFF;
            format.size = 12;
            format.underline = false;		
			label.width = 200;
			label.height = 400;
			label.defaultTextFormat = format;
			label.x = 10;
			label.y = 10;
			label.selectable = false;
						
			//trace("DEBUG! FML");
			stageRef = ReddEngine.getInstance().stage;
			
									
			
			stageRef.addChild(label);								
			ReddEngine.reddObjects.push(this);
								
			//ReddEngine.getInstance().addChild(this);			
		}
		
		public function InitializePhysics():void {			
		}												
		
		public function Update(e:Event) :void {							
			
			this.x = Body.GetPosition().x * ReddEngine.WORLD_CONSTANT;
			this.y = Body.GetPosition().y * ReddEngine.WORLD_CONSTANT;
			this.rotation = Body.GetAngle()*180/Math.PI;
			
			if (debugEnabled)
				debug();				
				
			
		}
		
		public function Destroy() :void {			
			ReddEngine.getInstance().World.DestroyBody(this.Body);			
			removeEventListener(Event.ENTER_FRAME, Update);
			parent.removeChild(this);			
			
		}
		
		public function Explode() :void {
		
			SoundEngine.playExplosion();
			trace("in ReddObject Explode()");
			this.Delete = true;
			//call particle effect for particle explosion
			if (this is Particle) {
				ExplosionHandler.getInstance().explode_at(this.x, this.y, 70, 12, 220, 20, 0, 0.8, 20, 220, 0, 0.1, true);
			}
			//call particle effect for antiparticle explosion
			if (this is Antiparticle) {
				ExplosionHandler.getInstance().explode_at(this.x, this.y, 70, 12, 0, 220, 220, 0.8, 0, 220, 220, 0.1, true);
			}
		
			//this.Delete = true;
			
			applyExplosiveImpulse(this.x, this.y, 400, 0, 30);
		}
		
		public function applyExplosiveImpulse(xPos:int, yPos:int, radius:Number, minval:Number, maxval:Number) {
			var radiusSquared:Number = radius * radius;
			var distSquared:Number;
			var xDiff:Number;
			var yDiff:Number;
			var particleObjects:Array = new Array();
			var i:int
			for (i = 0; i < ReddEngine.matterObjects.length; i++) {
				particleObjects.push(ReddEngine.matterObjects[i]);
			}
			
			for (i = 0; i < ReddEngine.antiMatterObjects.length; i++) {
				particleObjects.push(ReddEngine.antiMatterObjects[i]);
			}
			
			for (i = 0; i < ReddEngine.projectileObjects.length; i++) {
				particleObjects.push(ReddEngine.projectileObjects[i]);
			}
			//the following three loops are all the same just on different arrays.
			//If those 3 arrays were combined into one array of Reddobjects, it could easily
			//just do the loop once on that array (it would look better, but have the same runtime)
			
			//apply force to matter
			for (i = 0; i < particleObjects.length; i++) {
				xDiff = xPos - particleObjects[i].x;
				yDiff = yPos - particleObjects[i].y;
				distSquared = Math.pow(xDiff, 2) + Math.pow(yDiff, 2);
				if (distSquared < radiusSquared) {
					//ReddEngine.matterObjects[i].Body.
					var dist:Number = Math.sqrt(distSquared);
					var weight:Number = (maxval - minval) * (1 - (dist / radius)) + minval;//lerp lerp lerp
					//var vectorScale:Number = Math.sqrt((xDiff * xDiff + yDiff * yDiff));
					
					//a ^ 2 + b ^ 2 = distSquared
					//(a^2)/x^2 + (b^2)/x^2 = dist/x
					//distSquared*weight = a^2
					//*weight
					
					//sqrt((a ^ 2 + b ^ 2)) = x;
					//a ^ 2 + b ^ 2 = 1 * x ^ 2;
					//a ^ 2 / x ^ 2  +  b ^ 2 / x ^ 2 = 1;
					//(a / x) ^ 2 + (b / x) ^ 2 = 1;
					var xFrac:Number = -xDiff / dist;
					var yFrac:Number = -yDiff / dist;
					//var xFrac:Number = xDiff / (xDiff + yDiff);
					//var yFrac:Number = yDiff / (xDiff + yDiff);
					
					particleObjects[i].Body.ApplyImpulse(new b2Vec2(weight * xFrac, weight * yFrac), particleObjects[i].Body.GetWorldCenter());
					//trace("explosive force applied with weight: " + weight + " xDiff: " + xDiff + " yDiff: " + yDiff, " xFrac: " + xFrac + " yFrac: " + yFrac);
				}
			}
		}
		
		public function BlackHole() :void {
			SoundEngine.playBHHum();
			//call particle effect
			trace("A black hole is being spawned. WOOOOOOOOOOOOSH!");
			
			//ExplosionHandler.getInstance().setImplosiveAttributes(this, 400, 0, -1);
			ExplosionHandler.getInstance().implode_at(this.x, this.y, 500, 100, this, 400, 0, -.5);
			timer = new Timer (10000, 0);
			timer.addEventListener(TimerEvent.TIMER, timerListener);
			timer.start();
			
			//applyExplosiveImpulse(this.x, this.y, 400, 0, -1);
			
			this.Delete = true;
		}
		
		function timerListener (e: TimerEvent):void {
			ReddEngine.getInstance().StopGame();
		}
		
		public function debug() : void {
			trace("Debug is enabled. Override this in subclasses.");
			
		}
		
		public function SetWidthBasedOnValue(val:int) : int {
			val = Math.abs(val);
			var size:int;
			
			switch (val) {
				
				case 1:
				size = 33;
				break;
				case 2:
				size = 38;
				break;
				case 3: 
				size = 44;
				break;
				case 4:
				size = 48;
				break;
				case 5:
				size = 52;
				break;
				case 6: 
				size = 57;
				break;
				case 7:
				size = 61;
				break;
				case 8:
				size = 65;
				break;
				case 9: 
				size = 69;
				break;
				case 10:
				size = 73;
				break;
				case 11:
				size = 77;
				break;
				case 12: 
				size = 81;
				break;
				case 13:
				size = 83;
				break;
				case 14:
				size = 86;
				break;
				case 15: 
				size = 90;
				break;
				
				
			}
			
			return size;
		}
		
	}
}