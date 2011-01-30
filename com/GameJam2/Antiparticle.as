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
	
	public class Antiparticle extends ReddObject {				
		
		public var valueText:TextField;
		
		
		public function Antiparticle(x:Number=0, y:Number=0, r:Number=0) {				
			super(); //density = 0.7								
			
			this.x = x;
			this.y = y;
			this.width = r*2;
			this.height = r * 2;
			
			value = Math.random() * -8 -1;
			initText();
			
			Density = 2;
			Friction = 10;
			isRound = true;			
			InitializePhysics();
			addEventListener(Event.ENTER_FRAME, Update);
			ReddEngine.antiMatterObjects.push(this);
		}
		
		public function initText() {
			valueText = new TextField();
			var valueTextFormat:TextFormat = new TextFormat();
			valueTextFormat.size = 30;
			valueTextFormat.color = 0x000000;
			valueText.setTextFormat(valueTextFormat);
			valueText.selectable = false;
			valueText.width = this.width;
			valueText.height = this.height;			
			ReddEngine.getInstance().stage.addChild(valueText);
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
			
			valueText.text = "" + value;
			valueText.x = this.x -valueText.textWidth;
			valueText.y = this.y -valueText.textHeight / 2;
			
			if (this.value <= -25) {
				
				this.BlackHole();
				this.Delete = true;
			}
			
			if (debugEnabled)
				debug();							
									
			if (this.Delete)
				Destroy();
			
		}		
		
		public function checkCollisions(robj:ReddObject) {
			var total:int;
			if (robj is ShotParticle)
				{
					total = value + robj.value;
					//trace("shot collided with antimatter");
					// sum the values					
					// if 0, explode
					if (total == 0) {
						this.Explode();
						robj.Delete = true;
						//ReddEngine.antiMatterObjects[i].explode();
						trace("CALL EXPLOSIONS");
					}
					else
					{		
						if (Math.abs(robj.Body.m_linearVelocity.Length()) > ReddEngine.COMBINE_V)
						{
							value = total;
							trace("combining");				
							width += robj.value;
							height = width;							
							robj.Delete = true;											
						}
						else
						{							
							if (!(robj as ShotParticle).needConvert)
							{	
								(robj as ShotParticle).needConvert = true;
								(robj as ShotParticle).conversion.start();							
							}
						}
					}						
				}
				else if (robj is Particle)
				{
					total = value + robj.value;
					//trace("matter collided with antimatter");
					// sum the values					
					// if 0, explode
					if (total == 0) {
						this.BlackHole();
						robj.Delete = true;
						//ReddEngine.antiMatterObjects[i].explode();
						trace("CALL EXPLOSIONS");
					}
					else
					{		
						value = total;						
						if (Math.abs(Body.m_linearVelocity.Length() + robj.Body.m_linearVelocity.Length()) > ReddEngine.COMBINE_V)
						{						
							trace("combining");
							width + robj.width;
							height = width;							
							robj.Delete = true;
						}							
							//convert ShotParticle into Particle/Antiparticle																				
						if (value > 0)						
						{
							
							//convert ShotParticle into Particle/Antiparticle
						}
						
					}											
				}
				else if (robj is Antiparticle)
				{
					total = value + robj.value;
					if (Math.abs(Body.m_linearVelocity.Length()+robj.Body.m_linearVelocity.Length()) > ReddEngine.COMBINE_V)
					{			
						if (Body.m_linearVelocity.Length() > robj.Body.m_linearVelocity.Length())
						{
							trace("combining");
							width += robj.value;
							height = width;							
							robj.Delete = true;
							value = total;
						}										
						else
						{
							robj.width += value;
							robj.height = robj.width;
							robj.value = total;
							this.Delete = true;
						}
					}	
					
				}			
						
		}
		
		override public function Destroy() : void {
			super.Destroy();
			ReddEngine.getInstance().stage.removeChild(valueText);
			ReddEngine.antiMatterObjects.splice(ReddEngine.antiMatterObjects.indexOf(this), 1);
		}
		
		override public function debug() : void {
			label.appendText("\nCol posy : " + this.y);
		}								
		
	}
 }