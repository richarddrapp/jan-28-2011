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
		public var mouseDownTime:int = 0;//this only incriments if you can fire
		
		public static var FRAMES_PER_SECOND:int = 30;//Don't change this... it won't change the FPS, this is just for calculations
		public static var RATE_OF_FIRE:Number = 2;//shots per second
		public static var TIME_PER_SHOT:int = 1000/RATE_OF_FIRE; //timer milliseconds
		//public static var TIME_PER_SHOT:int = 1000; //timer milliseconds
		public static var TIME_TO_NEXT_FIRING_STRENGTH:int = TIME_PER_SHOT * (.8) / FRAMES_PER_SECOND; //frames
		public static var MAX_FIRING_STRENGTH:int = 5;
		//public static var TIME_TO_NEXT_FIRING_STRENGTH:int = 15; //frames
		public static var MATTER_SPAWN_TIME:int = 2000; //timer milliseconds
		
		
		var fireMeter:MovieClip = new MovieClip;
		var fireMeterBackground:Sprite = new Sprite;
		var fireMeterFill:Sprite = new Sprite;
		var fireMeterBorder:Sprite = new Sprite;
		var fireMeterRect:Rectangle = new Rectangle(500, 500, 100, 50);
		var fireMeterText:TextField;
		
		public static const PROJECTILETYPE_MATTER:int = 1;
		public static const PROJECTILETYPE_ANTIMATTER:int = 2;
		public static const PROJECTILETYPE_SUPER_COOL_POWERUP_MAYBE:int = 3;

		var projectileType:int = PROJECTILETYPE_MATTER;
		
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
			Density = 0;
			Friction = 0.3;
			isRound = true;		
			debugEnabled = true;
			
			radius = this.height / 2;
			
			key = new KeyObject(stageRef);
			InitializePhysics();
			addEventListener(Event.ENTER_FRAME, Update);
			//ReddEngine.getInstance().stage.addEventListener(MouseEvent.CLICK, fire);
			ReddEngine.getInstance().stage.addEventListener(KeyboardEvent.KEY_UP, keyUp);
			ReddEngine.getInstance().stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			ReddEngine.getInstance().stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			
			initFireMeter();
			
			LaunchTimer = new Timer(TIME_PER_SHOT, 1);
			SpawnTimer = new Timer(MATTER_SPAWN_TIME, 0);
			LaunchTimer.addEventListener(TimerEvent.TIMER, reload);
			SpawnTimer.addEventListener(TimerEvent.TIMER, spawnMeteor);
			SpawnTimer.start();
		}
		
		public function initFireMeter() {//this init has odd colors, but they should be overrulled in the first update
			fireMeterBackground.graphics.beginFill(0x222222, 1);
			fireMeterBackground.graphics.drawRect(fireMeterRect.x, fireMeterRect.y, fireMeterRect.width, fireMeterRect.height);
			fireMeterBackground.graphics.endFill();
			
			fireMeterFill.graphics.beginFill(0x00DD00, 1);
			//trace("% of bar: " + (mouseDownTime%TIME_TO_NEXT_FIRING_STRENGTH)/TIME_TO_NEXT_FIRING_STRENGTH);
			if (((mouseDownTime / TIME_TO_NEXT_FIRING_STRENGTH) + 1) >= MAX_FIRING_STRENGTH) {//at max strength
				fireMeterFill.graphics.drawRect(fireMeterRect.x, fireMeterRect.y, fireMeterRect.width, fireMeterRect.height);
			} else {//not at max strength
				fireMeterFill.graphics.drawRect(fireMeterRect.x, fireMeterRect.y, fireMeterRect.width*((mouseDownTime%TIME_TO_NEXT_FIRING_STRENGTH)/TIME_TO_NEXT_FIRING_STRENGTH), fireMeterRect.height);
			}
			fireMeterFill.graphics.endFill();
			
			fireMeterBorder.graphics.lineStyle(2, 0x000000, 1, false, "normal", null, null, 3);
			fireMeterBorder.graphics.beginFill(0x000000, 0);
			fireMeterBorder.graphics.drawRect(fireMeterRect.x, fireMeterRect.y, fireMeterRect.width, fireMeterRect.height);
			fireMeterBorder.graphics.endFill();
			
			fireMeter.addChild(fireMeterBackground);
			fireMeter.addChild(fireMeterFill);
			fireMeter.addChild(fireMeterBorder);
			ReddEngine.getInstance().stage.addChild(fireMeter);
			
			fireMeterText = new TextField();
			var fireMeterTextFormat:TextFormat = new TextFormat();
			fireMeterTextFormat.size = 30;
			fireMeterTextFormat.color = 0x000000;
			fireMeterText.setTextFormat(fireMeterTextFormat);
			fireMeterText.selectable = false;
			fireMeterText.x = fireMeterRect.x + fireMeterRect.width/2;
			fireMeterText.y = fireMeterRect.y + fireMeterRect.height/2;
			fireMeterText.width = fireMeterRect.width;
			fireMeterText.height = fireMeterRect.height;		
			ReddEngine.getInstance().stage.addChild(fireMeterText);
			fireMeterText.text = "" + int(mouseDownTime / TIME_TO_NEXT_FIRING_STRENGTH + 1);
			fireMeterText.x = fireMeterRect.x -fireMeterText.textWidth;
			fireMeterText.y = fireMeterRect.y -fireMeterText.textHeight/2;
		}
		
		public function updateFireMeter() {
			fireMeterFill.graphics.clear();
			if (canLaunch) {
				if (projectileType == PROJECTILETYPE_MATTER) {//matter = red
					fireMeterBorder.graphics.lineStyle(2, 0x550000, 1, false, "normal", null, null, 3);
					fireMeterBorder.graphics.beginFill(0x000000, 0);
					fireMeterBackground.graphics.beginFill(0x880000, 1);
					fireMeterFill.graphics.beginFill(0xFF0000, 1);
				} else if (projectileType == PROJECTILETYPE_ANTIMATTER) {//antimatter = blue
					fireMeterBorder.graphics.lineStyle(2, 0x000055, 1, false, "normal", null, null, 3);
					fireMeterBorder.graphics.beginFill(0x000000, 0);
					fireMeterBackground.graphics.beginFill(0x000088, 1);
					fireMeterFill.graphics.beginFill(0x0000FF, 1);
				} else { //super crazy powerup
					fireMeterBorder.graphics.lineStyle(2, 0x005500, 1, false, "normal", null, null, 3);
					fireMeterBorder.graphics.beginFill(0x000000, 0);
					fireMeterBackground.graphics.beginFill(0x008800, 1);
					fireMeterFill.graphics.beginFill(0x00DD00, 1);
				}
			} else {//can't launch, make it gray
				fireMeterBorder.graphics.lineStyle(2, 0x000000, 1, false, "normal", null, null, 3);
				fireMeterBorder.graphics.beginFill(0x000000, 0);
				fireMeterBackground.graphics.beginFill(0x222222, 1);
				fireMeterFill.graphics.beginFill(0x000000, 1);//this is the fill, shouldn't BE any
			}
			
			
			fireMeterBackground.graphics.drawRect(fireMeterRect.x, fireMeterRect.y, fireMeterRect.width, fireMeterRect.height);
			fireMeterBackground.graphics.endFill();
			
			fireMeterBorder.graphics.drawRect(fireMeterRect.x, fireMeterRect.y, fireMeterRect.width, fireMeterRect.height);
			fireMeterBorder.graphics.endFill();
			
			
			//trace("% of bar: " + (mouseDownTime%TIME_TO_NEXT_FIRING_STRENGTH)/TIME_TO_NEXT_FIRING_STRENGTH);
			if (((mouseDownTime / TIME_TO_NEXT_FIRING_STRENGTH) + 1) >= MAX_FIRING_STRENGTH) {//at max strength
				fireMeterFill.graphics.drawRect(fireMeterRect.x, fireMeterRect.y, fireMeterRect.width, fireMeterRect.height);
			} else {//not at max strength
				fireMeterFill.graphics.drawRect(fireMeterRect.x, fireMeterRect.y, fireMeterRect.width*((mouseDownTime%TIME_TO_NEXT_FIRING_STRENGTH)/TIME_TO_NEXT_FIRING_STRENGTH), fireMeterRect.height);
			}
			fireMeterFill.graphics.endFill();
			
			//update the strength number (text field)
			if (((mouseDownTime / TIME_TO_NEXT_FIRING_STRENGTH) + 1) >= MAX_FIRING_STRENGTH) {//at max strength
				fireMeterText.text = "" + MAX_FIRING_STRENGTH;
			} else {//not at max strength
				fireMeterText.text = "" + int(mouseDownTime / TIME_TO_NEXT_FIRING_STRENGTH + 1);
			}
			
			fireMeterText.x = fireMeterRect.x + fireMeterRect.width/2 -fireMeterText.textWidth;
			fireMeterText.y = fireMeterRect.y + fireMeterRect.height/2 -fireMeterText.textHeight/2;
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
			//updateFireMeter();
				
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
		
		public function keyUp(e:KeyboardEvent):void {
			if (e.keyCode == Keyboard.SPACE) {
				if (projectileType == PROJECTILETYPE_MATTER) {
					projectileType = PROJECTILETYPE_ANTIMATTER;
				} else if (projectileType == PROJECTILETYPE_ANTIMATTER) {
					projectileType = PROJECTILETYPE_MATTER;
				}
			}
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
					var strength:int;
					//update the strength number
					if (((mouseDownTime / TIME_TO_NEXT_FIRING_STRENGTH) + 1) >= MAX_FIRING_STRENGTH) {//at max strength
						strength = MAX_FIRING_STRENGTH;
					} else {//not at max strength
						strength = mouseDownTime / TIME_TO_NEXT_FIRING_STRENGTH + 1;
					}
					if (projectileType == PROJECTILETYPE_MATTER) {
						mis.value = strength;
						mis.gotoAndStop(1);
					} else if (projectileType = PROJECTILETYPE_ANTIMATTER) {
						mis.value = strength * -1;
						mis.gotoAndStop(2);
					} else {
						//super crazy powerup
					}
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
			if (isMouseDown && canLaunch) {//don't charge up if you can't fire
				mouseDownTime++;
			}
		}
	
		public function mouseMovement() {
			orientation = Math.atan((ReddEngine.getInstance().mouseX - this.x) / -(ReddEngine.getInstance().mouseY - this.y)) ;
			orientation *= 180 / Math.PI;
			
			this.rotation = orientation;
			
		}
	}
 }