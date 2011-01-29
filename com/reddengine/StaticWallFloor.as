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
	
	public class StaticWallFloor extends ReddObject {
		
		private var idLoc:String;					
		
		public function StaticWallFloor() {				
			super(); //density = 0.7	
			InitializePhysics();
			addEventListener(Event.ENTER_FRAME, Update);
		}
		
		override public function InitializePhysics():void {			
			var BodyDef = new b2BodyDef();			
			BodyDef.position.Set((this.x)/ReddEngine.WORLD_CONSTANT, (this.y)/ReddEngine.WORLD_CONSTANT);			
									
			var BoxDef:b2PolygonDef = new b2PolygonDef();
			BoxDef.SetAsBox(width / ReddEngine.WORLD_CONSTANT /2, height / ReddEngine.WORLD_CONSTANT/2);
			Body = ReddEngine.getInstance().World.CreateBody(BodyDef);
			BoxDef.friction = 0.4;
			BoxDef.density = 0;
			Body.CreateShape(BoxDef);									
			
			Body.SetMassFromShapes();				
		}
		
		override public function Update(e:Event) :void  {					
			super.Update(e);
			//this.x -= 1;												
			if (debugEnabled)
				debug();				
			checkCollisions();		
			
		}
		
		override public function debug() : void {
			label.appendText("\nCol posy : " + this.y);
		}
		
		public function checkCollisions():void {		
		}
			
		override public function toString():String {
			return(idLoc);
		}
		
		
		
	}
 }