package com.reddengine
{
	import flash.display.MovieClip;
	import flash.display.Stage;
	/**
	 * ...
	 * @author J Cramer
	 */
	import flash.events.Event;
	 
	public class ScriptedObject extends ReddObject
	{
		public var myWaypoints:Array;
			
		public var linked:Boolean = false;
		public function ScriptedObject() 
		{			
			myWaypoints = new Array();	
			//stageRef = ReddEngine.getInstance().stage;
			//trace("New scripted object created");
			addEventListener(Event.ENTER_FRAME, Update); //executes on every redraw
			//stageRef.addChild(this);
		}
		
		public override function Update(e:Event):void {
			Navigate();
		}
		
		public function Navigate() {
			
		}
		
	}

}