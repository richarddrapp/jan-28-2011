package com.reddengine
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.display.BitmapData;
	import flash.geom.*;
	
	import flash.display.Sprite;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;

	
	/**
	 * ...
	 * @author J Cramer
	 */
	public class Waypoint extends MovieClip
	{
				
		//public var pointName:String;
		//public var stageRef:Stage;
		
		public function Waypoint() 
		{			
			//addEventListener(Event.FRAME_CONSTRUCTED, initialize); //executes on every redraw						
			//trace("Waypoint created" + this.x + this.y);
			//trace("adding waypoint to array...");
			ReddEngine.waypoints.push(this);
			//ReddEngine.getInstance().stage.addChild(this);
		}		
		
		
		
	}

}