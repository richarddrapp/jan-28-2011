package com.reddengine
{
	import flash.display.MovieClip;
	import flash.events.Event;
	/**
	 * ...
	 * @author ...
	 */
	
	 import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
	
	public class Checkpoint extends MovieClip
	{
		public var floatup:int = 0;
		public var label:TextField;
		public var check:Boolean = false;
		public function Checkpoint() 
		{
			label = new TextField();  
			var format:TextFormat = new TextFormat();
            format.font = "Verdana";
            format.color = 0xFFCC00;
            format.size = 12;
            format.underline = false;		
			label.width = 100;
			label.height = 20;
			label.defaultTextFormat = format;
			label.x = this.x -30;
			label.y = this.y -20;
			label.text = "Checkpoint!";
			addEventListener(Event.ENTER_FRAME, checkCollision);
		}
		
		public function checkCollision(e:Event):void {	
			if (!check)
			{
				if (ReddEngine.playerObject != null)
				{
					if (this.hitTestObject(ReddEngine.playerObject))
					{
						//trace("Checkpoint reached");					
						ReddEngine.playerObject.lastCheckpoint = this;			
						check = true;
					}
				}
				if (ReddEngine.stealthPlayer != null)
				{
					if (this.hitTestObject(ReddEngine.stealthPlayer))
					{
						//trace("Checkpoint reached");
						ReddEngine.stealthPlayer.lastCheckpoint = this;
						check = true;						
					}
				}
			}
			else
			{
				ReddEngine.getInstance().addChild(label);
				if (floatup < 90)
				{
					floatup += 3;
					label.y -= 3;
				}
				else
				{
					removeEventListener(Event.ENTER_FRAME, checkCollision);
					ReddEngine.getInstance().removeChild(label);
				}
			}
		}
	}

}