 package com.GameJam2{
	
	import com.Box2D.Collision.Shapes.b2CircleDef;
	import com.Box2D.Dynamics.b2Body;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.display.BitmapData;
	import flash.geom.*;
	import flash.text.AntiAliasType;
	import flash.text.engine.BreakOpportunity;
	
	import flash.display.Sprite;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;	
	import flash.text.TextFormatAlign;
	
	import flash.events.Event;
	
	import com.Box2D.Collision.*;
	import com.Box2D.Collision.Shapes.*;
	import com.Box2D.Common.Math.*;
	import com.Box2D.Dynamics.*;
	
	import com.reddengine.ReddObject;
	import com.reddengine.ReddEngine;
	
	public class Particle extends ReddObject {				
		
		public var valueText:TextField;		
		
		public function Particle(x:Number, y:Number, r:Number) {				
			super(); //density = 0.7								
			
			this.x = x;
			this.y = y;
			this.width = r*2;
			this.height = r * 2;
			
			value = Math.random() * 8 -1;
			initText();
			
			Density = 2;
			Friction = 10;
			isRound = true;			
			InitializePhysics();
			addEventListener(Event.ENTER_FRAME, Update);
			ReddEngine.matterObjects.push(this);
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
			CircleDef.radius = (this.width / 2 ) / ReddEngine.WORLD_CONSTANT;
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
			valueText.y = this.y -valueText.textHeight/2;
			
			
			if (debugEnabled)
				debug();
												
					
			
			if (this.Delete)
				Destroy();
						
		}		
		
		public function checkCollisions(robj:ReddObject):void {
			//camera detection				
				
				if (robj is ShotParticle)
				{					
					trace("shot collided with matter");
					// sum the values
					var total = value + robj.value;
					// if 0, explode
					if (total == 0) {
						//this.explode();
						robj.Destroy();
						//ReddEngine.antiMatterObjects[i].explode();
						trace("CALL EXPLOSIONS");
					}
					else
					{		
						value = total;
						//convert ShotParticle into Particle/Antiparticle
					}						
				}					
				else if (robj is Antiparticle)
				{
					trace("matter collided with antimatter");
					// sum the values
					var total = value + robj.value;
					// if 0, explode
					if (total == 0) {
						//this.explode();
						robj.Destroy();
						//ReddEngine.antiMatterObjects[i].explode();
						trace("CALL EXPLOSIONS");
					}
					else
					{		
						value = total;
						robj.value = total;
						//convert ShotParticle into Particle/Antiparticle
					}											
				}
				else if (robj is Particle)
				{
					trace("combining");
					var tempP:Particle;
					if (value > robj.value)
					{						
						width += 10;
						height = width;							
						robj.Delete = true;
					}
					else	
					{
						robj.width += 10;
						robj.height = robj.width;						
						this.Delete = true;
					}	
					
				}
						
		}
		
		override public function Destroy() : void {
			super.Destroy();	
			ReddEngine.getInstance().stage.removeChild(valueText);
			ReddEngine.matterObjects.splice(ReddEngine.matterObjects.indexOf(this), 1);
		}
		
		override public function debug() : void {
			label.appendText("\nCol posy : " + this.y);
		}								
		
	}
 }