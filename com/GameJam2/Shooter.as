 package com.GameJam2{
		
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.display.BitmapData;
	import flash.events.TimerEvent;
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
	
	import com.reddengine.ReddObject;
	import com.reddengine.ReddEngine;
	import com.senocular.utils.KeyObject;
	import flash.ui.Keyboard;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	import flash.events.MouseEvent;
	
	public class Shooter extends ReddObject {				
		
		public var keyA:uint = 65;
		public var keyD:uint = 68;
		public var key:KeyObject;
		public var keySpace:uint = 32;
		public var isMouseDown:Boolean = false;
		public var mouseDownTime:int = 0;
		
		var radius:Number;
		var newX:Number;
		var newY:Number;
		var newVX:Number;
		var newVY:Number;
		
		var metVX:Number;
		var metVY:Number;
		var atkAngle:Number;
		
		var LaunchSpeed:Number = 7;
		
		var LaunchTimer:Timer;
		var SpawnTimer:Timer;
		var canLaunch:Boolean = true;
		var orientation:Number;
		
		
		
		public function Shooter() {							
			super(); //density = 0.7											
			Density = 20;
			Friction = 0.3;
			isRound = true;		
			debugEnabled = true;
			
			radius = this.height / 2;
			
			key = new KeyObject(stageRef);					
			InitializePhysics();
			addEventListener(Event.ENTER_FRAME, Update);
			//ReddEngine.getInstance().stage.addEventListener(MouseEvent.CLICK, fire);
			ReddEngine.getInstance().stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			ReddEngine.getInstance().stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			
			
			LaunchTimer = new Timer(1000, 1);
			SpawnTimer = new Timer(2000, 0);
			LaunchTimer.addEventListener(TimerEvent.TIMER, reload);
			SpawnTimer.addEventListener(TimerEvent.TIMER, spawnMeteor);
			SpawnTimer.start();
		}
		
		override public function InitializePhysics():void
		{
			var BodyDef:b2BodyDef = new b2BodyDef();			
			BodyDef.position.Set((this.x)/ReddEngine.WORLD_CONSTANT, (this.y)/ReddEngine.WORLD_CONSTANT);			
									
			var CircleDef:b2CircleDef = new b2CircleDef();				
			CircleDef.radius = (this.width / 2) / ReddEngine.WORLD_CONSTANT;
			CircleDef.friction = Friction;				
			CircleDef.density = Density;	
				
			Body=ReddEngine.getInstance().World.CreateBody(BodyDef);					
			Body.CreateShape(CircleDef);						
			
			Body.m_angularDamping = 2;
			Body.m_linearDamping = 1;
			
			Body.SetMassFromShapes();		
		}
		
		override public function Update(e:Event) :void  {					
			super.Update(e);
			//this.x -= 1;												
			
			mouseDownUpdate();
			mouseMovement();										
				
			if (debugEnabled)
				debug();
				
			
			
		}						
		
		override public function debug() : void {
			label.text = "Rotation: " + this.rotation + 
						"\nOrientation: " + this.orientation;
		}								
		
		public function reload(e:TimerEvent) :void {
			canLaunch = true;
		}
		
		public function mouseDown(e:MouseEvent):void {
			isMouseDown = true;
		}
		
		public function mouseUp(e:MouseEvent):void {
			isMouseDown = false;
			fire();
			mouseDownTime = 0;
		}
		
		public function fire():void {
			//trace("CLICK");
					
			if (canLaunch && Math.abs(orientation-rotation) < 15)
				{					
					canLaunch = false;
					LaunchTimer.start();				
					newX = this.x + radius * Math.sin(orientation * Math.PI / 180);
					newY = (this.y + radius * -Math.cos(orientation * Math.PI / 180));
					
					newVX = (LaunchSpeed * Math.sin(orientation * Math.PI / 180));
					newVY = (LaunchSpeed * -Math.cos(orientation * Math.PI / 180));
					
					var mis:ShotParticle = new ShotParticle(newX, newY, 10);
					mis.value = mouseDownTime / 15 + 1;
					mis.Body.ApplyImpulse(new b2Vec2(newVX, newVY), mis.Body.GetWorldCenter());					
					ReddEngine.getInstance().addChild(mis);
				}			
		}
		
		public function spawnMeteor(e:TimerEvent):void {				
			if (Math.random() > 0.4)
			{
				var met:Particle;
				if(Math.random() > 0.5)
					met = new Particle(0, Math.random()*400, 15);
				else
					met = new Particle(600, Math.random()*400, 15);
					
				atkAngle = Math.atan((met.y - this.y) / (met.x - this.x))
				metVX = (2) * Math.cos(atkAngle);
				metVY = (2) * Math.sin(atkAngle);
				if (met.x > 500)
				{
					metVX *= -1;
					metVY *= -1;
				}
				
				met.Body.ApplyImpulse(new b2Vec2(metVX, metVY), met.Body.GetWorldCenter());
				ReddEngine.getInstance().addChild(met);
				ReddEngine.reddObjects.push(met);
			}
			else
			{
				var met2:Antiparticle
				if(Math.random() > 0.5)
					met2 = new Antiparticle(0, Math.random()*400, 15);
				else
					met2 = new Antiparticle(600, Math.random()*400, 15);
					
				atkAngle = Math.atan((met2.y - this.y) / (met2.x - this.x))
				metVX = (2) * Math.cos(atkAngle);
				metVY = (2) * Math.sin(atkAngle);
				if (met2.x > 500)
				{
					metVX *= -1;
					metVY *= -1;
				}
				
				met2.Body.ApplyImpulse(new b2Vec2(metVX, metVY), met2.Body.GetWorldCenter());
				ReddEngine.getInstance().addChild(met2);
				ReddEngine.reddObjects.push(met2);
			}
		}
		
		public function mouseDownUpdate() {
			if (isMouseDown) {
				mouseDownTime++;
			}
		}
	
		public function mouseMovement() {
			orientation = Math.atan((ReddEngine.getInstance().mouseX - this.x) / -(ReddEngine.getInstance().mouseY - this.y)) ;
			orientation *= 180 / Math.PI;
			
			if (Math.abs(rotation - orientation) > 10)
			{
				if (rotation < orientation)
				{
					//trace("rotate right");
					this.Body.ApplyTorque(5000);
				}
				else
				{
					//trace("rotate left");
					this.Body.ApplyTorque(-5000);
				}
			}
			
		}
	}
 }