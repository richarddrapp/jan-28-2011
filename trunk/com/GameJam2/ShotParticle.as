 package com.GameJam2{
	
	import com.Box2D.Collision.Shapes.b2CircleDef;
	import com.Box2D.Dynamics.b2Body;
	import com.reddengine.StaticWallFloor;
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
	import flash.events.TimerEvent;	
	import flash.utils.Timer;
	
	import com.Box2D.Collision.*;
	import com.Box2D.Collision.Shapes.*;
	import com.Box2D.Common.Math.*;
	import com.Box2D.Dynamics.*;
	
	import com.reddengine.ReddObject;
	import com.reddengine.ReddEngine;
	import com.reddengine.CollisionDetection;
	
	public class ShotParticle extends ReddObject {				
		
		//public var valueText:TextField;		
		public var needConvert:Boolean = false;		
		public var conversion:Timer;
		
		public function ShotParticle(x:Number, y:Number, r:Number) {					
			super(); //density = 0.7													
			this.x = x;
			this.y = y;
			this.width = r*2;
			this.height = r * 2;	
			
			value = Math.random() * 9;
			numSymbol.numText.text = "" + value;
			//initText();
			
			Density = 8;
			Friction = 10;
			isRound = true;				
			InitializePhysics();			
			addEventListener(Event.ENTER_FRAME, Update);
			
			conversion = new Timer(500, 1);
			conversion.addEventListener(TimerEvent.TIMER, convert);
			
			ReddEngine.projectileObjects.push(this);
		}
		
		/*public function initText() {
			valueText = new TextField();
			var valueTextFormat:TextFormat = new TextFormat();
			valueTextFormat.size = 30;
			valueTextFormat.color = 0x000000;
			valueText.setTextFormat(valueTextFormat);
			valueText.selectable = false;
			valueText.width = this.width;
			valueText.height = this.height;			
			ReddEngine.getInstance().stage.addChild(valueText);
		}*/
		
		public function convert(e:TimerEvent):void {				
			trace("Converting");	
				//trace("In Val: " + value);				
							
				if (value > 0)
				{
					var newP:Particle = new Particle(this.x, this.y, 15);	
					newP.Body.SetLinearVelocity(Body.GetLinearVelocity());
					newP.value = value;
					ReddEngine.getInstance().addChild(newP);
					ReddEngine.reddObjects.push(newP);
					ReddEngine.matterObjects.push(newP);
				}
				else
				{
					var newAP:Antiparticle = new Antiparticle(this.x, this.y, 15);	
					newAP.Body.SetLinearVelocity(Body.GetLinearVelocity());
					newAP.value = value;
					ReddEngine.getInstance().addChild(newAP);
					ReddEngine.reddObjects.push(newAP);
					ReddEngine.matterObjects.push(newAP);
				}								
				this.Delete = true;					
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
			
			Body.SetUserData(this);
			
			Body.SetMassFromShapes();		
		}
		
		override public function Update(e:Event) :void  {					
			super.Update(e);
			//this.x -= 1;		
			
			numSymbol.numText.text = "" + value;
			numSymbol.rotation = -rotation;
			//valueText.text = "" + value;
			//valueText.x = this.x -valueText.textWidth;
			//valueText.y = this.y -valueText.textHeight/2;
			
			if (debugEnabled)
				debug();	
							
			
			if (this.Delete)
				Destroy();
			
			checkCollisions();
		}		
		
		public function checkCollisions():void {
			for each (var wall:StaticWallFloor in ReddEngine.wallfloors)
			{
				if (this.hitTestObject(wall))
				{
					if (!needConvert)
					{
						needConvert = true;
						conversion.start();
					}
				}				
			}
		}
		
		override public function Destroy() : void {
			super.Destroy();			
			//ReddEngine.getInstance().stage.removeChild(valueText);
			ReddEngine.projectileObjects.splice(ReddEngine.projectileObjects.indexOf(this), 1);			
		}
		
		override public function debug() : void {
			label.appendText("\nCol posy : " + this.y);
		}								
		
	}
 }