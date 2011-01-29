package com.reddengine
{
	/**
	 * ...
	 * @author ...
	 */
	
	import flash.events.Event;
	public class PathNode extends Waypoint
	{
		
		var links:Array;
		var linkedActor:ScriptedObject;
		
		public function PathNode() 
		{
			super();					
			links = new Array();
			trace("Pathnode created");
			
			addEventListener(Event.ENTER_FRAME, notify);
			
		}
		
		
		public function notify(e:Event) {						
			for each(var l:WaypointLinker in links)
			{			
				l.actor = linkedActor;
			}
		}
	}

}