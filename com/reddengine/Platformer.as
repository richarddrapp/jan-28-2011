package com.reddengine
{
 
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.MouseEvent;

	
	import com.senocular.utils.KeyObject; //not part of Flash Std. API
	import flash.ui.Keyboard;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
 
	import flash.utils.Timer;
	import flash.events.TimerEvent;

	import com.Box2D.Collision.*;
	import com.Box2D.Collision.Shapes.*;
	import com.Box2D.Common.Math.*;
	import com.Box2D.Dynamics.*;
	import com.Box2D.Dynamics.Contacts.*;
	import com.Box2D.Dynamics.Joints.*;
	

 
	public class Platformer extends ReddObject
	{		
		public var key:KeyObject;
		public var speed:Number;	
		public var jump:Number;
		public var friction:Number;
		public var maxSpeed:Number;
		public var canJump:Boolean;		
				
		
		
		//wasd keys
		public var keyA:uint = 65;
		public var keyS:uint = 83;
		public var keyD:uint = 68;
		public var keyW:uint = 87;
		public var keyLeft:uint = 37;
		public var keyDown:uint = 40;
		public var keyRight:uint = 39;
		public var keyUp:uint = 38;
		
		public var keyU:uint = 85;
		public var keyI:uint = 73;
		public var keyO:uint = 79;
		
		public var keySpace:uint = 32;
		
		
		public var LinearDamping:Number;
		public var Foot:PhysicsLimb;
		public var Arm:PhysicsLimb;
		public var Center:b2Vec2;
		public var MouseVelocity:b2Vec2;

		public function Platformer()		
		{				
			super(); 
			
			Arm = new PhysicsLimb(this.x, this.y, this.width + 10, this.height / 8);			
			ReddEngine.getInstance().addChild(Arm);
			//Arm = new PhysicsLimb();			
						
			debugEnabled = true;			
			canJump = true;
						
			key = new KeyObject(stageRef);					
			
			speed = 1.3;
			jump = 8;			
			maxSpeed = 9;			
						
			Velocity = new b2Vec2(0, 0);
			MouseVelocity = new b2Vec2(0, 0);
			Density = 0.7;
			Friction = 0.1;
			LinearDamping = 1.7;
			InitializePhysics();
			ReddEngine.getInstance().stage.addEventListener(MouseEvent.MOUSE_MOVE, moveArm);
			addEventListener(Event.ENTER_FRAME, Update); //executes on every redraw			
			
		}

		override public function InitializePhysics():void {				
			var BodyDef = new b2BodyDef();			
			BodyDef.position.Set((this.x)/ReddEngine.WORLD_CONSTANT, (this.y)/ReddEngine.WORLD_CONSTANT);			
									
			var BoxDef:b2PolygonDef = new b2PolygonDef();
			BoxDef.SetAsBox((this.width / 2) / ReddEngine.WORLD_CONSTANT, (this.height / 2) / ReddEngine.WORLD_CONSTANT);			
			BoxDef.friction = Friction;
			BoxDef.density = Density;
			
			Body = ReddEngine.getInstance().World.CreateBody(BodyDef);
			Body.CreateShape(BoxDef);									
			Body.m_linearDamping = LinearDamping;
			Body.m_angularDamping = 2000;
			Body.SetMassFromShapes();						
			
			//Define limbs			
			
			var ArmDef = new b2BodyDef();
			ArmDef.position.Set((this.x + 10) / ReddEngine.WORLD_CONSTANT, (this.y + this.height / 2) / ReddEngine.WORLD_CONSTANT);
			BoxDef.SetAsBox((Arm.width/2) / ReddEngine.WORLD_CONSTANT, (Arm.height/2) / ReddEngine.WORLD_CONSTANT);
			BoxDef.friction = 0.2;
			BoxDef.density = 1;
			
			
			Arm.Body = ReddEngine.getInstance().World.CreateBody(ArmDef);
			Arm.Body.SetBullet(true);
			Arm.Body.CreateShape(BoxDef);
			Arm.Body.m_linearDamping = LinearDamping;
			Arm.Body.SetMassFromShapes();
						
			
			//join them
			var jointDef:b2DistanceJointDef = new b2DistanceJointDef();			
			//jointDef.Initialize(Body, Arm.Body, new b2Vec2(Body.GetWorldCenter().x, Body.GetWorldCenter().y + ((this.height / 2+5) / ReddEngine.WORLD_CONSTANT)));			
			jointDef.Initialize(Body, Arm.Body, Body.GetWorldCenter(), Arm.Body.GetWorldCenter());						
			jointDef.length = 2;
			jointDef.dampingRatio = 0;
			jointDef.frequencyHz = 2.3;
			jointDef.collideConnected = false;
			
			var joint:b2DistanceJoint;
			joint = (ReddEngine.getInstance().World.CreateJoint(jointDef) as b2DistanceJoint);
		
		}
		public override function Update(e:Event) : void
		{						
			super.Update(e);			
			if((key.isDown(keyA)))
				Body.ApplyImpulse(new b2Vec2( -speed, 0), Body.GetWorldCenter());
			else if ((key.isDown (keyD)))
				Body.ApplyImpulse(new b2Vec2( speed, 0), Body.GetWorldCenter());
							
			if (key.isDown(keyLeft))
				Arm.Body.ApplyImpulse(new b2Vec2( -4, 0), Arm.Body.GetWorldCenter());
			else if (key.isDown(keyRight))
				Arm.Body.ApplyImpulse(new b2Vec2( 4, 0), Arm.Body.GetWorldCenter());
			
			if(key.isDown(keyUp))
				Arm.Body.ApplyImpulse(new b2Vec2( 0, -4), Arm.Body.GetWorldCenter());
			else if(key.isDown(keyDown))
				Arm.Body.ApplyImpulse(new b2Vec2( 0, 4), Arm.Body.GetWorldCenter());
				
			calcMouseVelocity();									
			
			if ((rotation > -92 && rotation < -88) || (rotation > 88 && rotation < 92))
			{
				Body.m_angularDamping = 0;				
			}			
			
			if (key.isDown(keyU))
			{
				if (rotation < -2)
				{
					Body.ApplyTorque(2);
				}
				else if (rotation > 2)
				{
					Body.ApplyTorque( -2);
				}
				else
					Body.m_angularDamping = 2000;
			}
			
			Velocity.x = Arm.Body.GetLinearVelocity().x;	
			Velocity.y = Arm.Body.GetLinearVelocity().y;													
			
			
			//conditions to make sure jumping is allowed			
			if (key.isDown(keySpace))
			{					 
				if (canJump)
				{					
					Body.ApplyImpulse(new b2Vec2(0, -jump),Body.GetWorldCenter());
					grounded = false;									
				}
				
			}									
			
				
				
			//checkSpeed			
			capSpeed();
			
			if(debugEnabled)
				debug();			
			
						
				
		}
		
		override public function debug() : void {						
			label.text = "Velocity.X = " + Velocity.x + 
						 "\nVelocity.Y = " + Velocity.y +
						 "\nRotation = " + rotation + 
						 "\nNumObjects = " + ReddEngine.getInstance().numChildren + 
						 "\nRegisteredObjects = " + ReddEngine.reddObjects.length +
						 "\nMouse[X,Y] = [" + ReddEngine.getInstance().mouseX + "],[" + ReddEngine.getInstance().mouseY + "]" +
						 "\nMouse[VX,VY] = [" + MouseVelocity.x.toFixed(2) + "],[" + MouseVelocity.y.toFixed(2) + "]";
						 
		}
		
		var oldX:Number = ReddEngine.getInstance().stage.mouseX;
		var oldY:Number = ReddEngine.getInstance().stage.mouseY;
		public function calcMouseVelocity():void {
			var vx:Number;
			var vy:Number;
			
			vx = (ReddEngine.getInstance().stage.mouseX - oldX) / 30;
			vy = (ReddEngine.getInstance().stage.mouseY - oldY) / 30;
						
			MouseVelocity.x = vx;
			MouseVelocity.y = vy;
			
			oldX = ReddEngine.getInstance().stage.mouseX;
			oldY = ReddEngine.getInstance().stage.mouseY;
			
		}
		
		public function moveArm(e:MouseEvent) {			
			if (e.buttonDown)				
			{
				trace("wut");
				//MouseVelocity.Multiply(1 / ReddEngine.WORLD_CONSTANT);
				//Arm.Body.m_linearVelocity = MouseVelocity;
				Arm.Body.ApplyImpulse(MouseVelocity, Arm.Body.GetWorldCenter());
			}
		}
		
		public function capSpeed() : void
		{
			
		}
		

	}
}