 package com.reddengine{
	
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.display.BitmapData;
	import flash.geom.*;
	import flash.text.engine.BreakOpportunity;
	
	import flash.display.Sprite;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;	
	
	import com.Box2D.Collision.*;
	import com.Box2D.Collision.Shapes.*;
	import com.Box2D.Common.Math.*;
	import com.Box2D.Dynamics.*;
	
	import flash.events.Event;
	
	public class Collidable extends ReddObject {
		
		private var idLoc:String;					
		
		public function Collidable() {				
			super();
			Friction = 0.3;
			Density = 0.7;
			InitializePhysics();
			addEventListener(Event.ENTER_FRAME, Update);
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
			
			
			Body.SetMassFromShapes();				
		}
		
		override public function Update(e:Event) :void  {					
			super.Update(e);
			//this.x -= 1;												
			if (debugEnabled)
				debug();										
		}
		
		override public function debug() : void {
			label.appendText("\nCol posy : " + this.y);
		}
				
			
		override public function toString():String {
			return(idLoc);
		}
		
		
		
	}
 }