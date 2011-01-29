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
	import com.reddengine.ReddEngine;
	
	/**
	 * ...
	 * @author J Cramer
	 */
	public class WaypointLinker extends MovieClip
	{
		var linkerwaypoints:Array;
		var pathNodes:Array;
		var actor:ScriptedObject;		
		
		var linked:int = 0;
		var synced:Boolean = false;
		var duplicate:Boolean = false;
		/*posx:int, posy:int, xwidth:int, yheight:int*/
		public function WaypointLinker() 
		{		
			//super();
			//trace("Linker created");
			
			linkerwaypoints = new Array();
			pathNodes = new Array();
			ReddEngine.links.push(this);			
			//trace("Linker adding listener...");			
			addEventListener(Event.ENTER_FRAME, Update); //executes on every redraw			
		}
		
		public function Update(e:Event):void {			
			//for each wp in waypoints
				//if colliding
					//waypoint = wp
			//for each scrobj in scriptedobjects
				//if colliding
					//actor = scrobj
									
				////trace("check check");
				if(!synced)
				{
					//ReddEngine.getInstance();
					//trace("Num actors: " + ReddEngine.scriptedActors.length);
					//trace("Num Waypoints: " + ReddEngine.waypoints.length);
					//trace("Syncing...");
					////trace("checking for links");				
					for each(var wp:Waypoint in ReddEngine.waypoints)
					{
						
						////trace("Linker parent: " + this.parent);
						////trace("Waypoint Parent: " + wp.parent);
						
						if (ReddEngine.getInstance().checkObjectCollision(this,wp))
						{							
							//trace("PixelPerfect! WP");
							if (wp is PathNode)
							{
								//trace("I have a pathnode!");
								pathNodes.push(wp);												
							}

								linkerwaypoints.push(wp);									
								linked++;						

						}
					}				
					for each(var sa:ScriptedObject in com.reddengine.ReddEngine.scriptedActors)
					{
						
						
						////trace("Actor name: " + sa.name);

						
						if (ReddEngine.getInstance().checkObjectCollision(this,sa))
						{
							//trace("PixelPerfect! SA");
							actor = sa;
							linked++;
							break;
						}
					}
				}
					
				if (linked >= 2 && !synced) //they're linked
				{
					//trace("linked actor to waypoint");					
					for each(var pn:PathNode in pathNodes)
					{
						pn.links.push(this);						
							
						if(actor != null)
							pn.linkedActor = actor;						
						else
							actor = pn.linkedActor;						
					}						
					for each(var wp2:Waypoint in linkerwaypoints)
					{
						
						if (actor.myWaypoints != null)
						{
						
							for each(var wp3:Waypoint in actor.myWaypoints)
							{	
								if (wp2 == wp3)
								{
									duplicate = true;
								}
							}
						}
						
						if (!duplicate)	
						{
							actor.myWaypoints.push(wp2);							
							wp2.visible = false;
						}
						////trace("debug4");
						duplicate = false;
					}
					
					synced = true;						
					actor.linked = true;
					removeEventListener(Event.ENTER_FRAME, Update);
					this.visible = false;										
				}
				else
					linked = 0;
					
									
			}		
		
		
	}
}