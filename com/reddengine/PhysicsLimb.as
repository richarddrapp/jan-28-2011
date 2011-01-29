package com.reddengine
{
	/**
	 * ...
	 * @author ...
	 * 
	 * 
	 */
	
	import com.Box2D.Collision.*;
	import com.Box2D.Collision.Shapes.*;
	import com.Box2D.Common.Math.*;
	import com.Box2D.Dynamics.*;
	import com.Box2D.Dynamics.Contacts.*;
	import com.Box2D.Dynamics.Joints.*;
	
	import flash.events.Event;
	
	public class PhysicsLimb extends ReddObject
	{		
		
		public function PhysicsLimb(x:Number, y:Number, w:Number, h:Number) 
		{			
			this.x = x;
			this.y = y;
			this.width = w;
			this.height = h;
			super();
			addEventListener(Event.ENTER_FRAME, Update);
		}
		
		override public function Update(e:Event):void {
			if(Body != null)
				super.Update(e);
		}
		
	}

}