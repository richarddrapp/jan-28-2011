 package com.reddengine{
	
	import com.GameJam2.Particle;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.display.BitmapData;
	import flash.geom.*;
	
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
		
			//call particle effect for particle explosion
			if (this is Particle) {
				ExplosionHandler.getInstance().explode_at(this.x, this.y, 35, 12, 220, 20, 0, 0.8, 20, 220, 0, 0.1, true);
			}
			//call particle effect for antiparticle explosion
			if (this is Particle) {
				ExplosionHandler.getInstance().explode_at(this.x, this.y, 35, 12, 0, 220, 220, 0.8, 0, 220, 220, 0.1, true);
			}
		
		}
		
		public function BlackHole() :void {
			
			//call particle effect
			trace("A black hole is being spawned. WOOOOOOOOOOOOSH!");
		}
		
		public function debug() : void {
			trace("Debug is enabled. Override this in subclasses.");
			
		}
		
	}
}