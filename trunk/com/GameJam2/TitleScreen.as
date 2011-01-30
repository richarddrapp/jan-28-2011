package com.GameJam2
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	
	import com.reddengine.ReddEngine;
	import com.reddengine.ReddObject;
	/**
	 * ...
	 * @author ...
	 */
	public class TitleScreen extends MovieClip
	{
		
		public function TitleScreen() 
		{
			trace("title screen");											
			addEventListener(Event.ENTER_FRAME, start);
			Mouse.hide();
			
		}
		
		public function start(e:Event):void
		{
			for each(var robj:ReddObject in ReddEngine.reddObjects)
			{
				if (Start.hitTestObject(robj))
				{
					this.parent.removeChild(this);
					this.removeEventListener(Event.ENTER_FRAME, start);
					robj.Explode();
					ReddEngine.getInstance().gotoAndStop(3);
				}
			}
			
		}
				
		
	}

}