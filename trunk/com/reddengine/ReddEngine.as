package com.reddengine{
	
	
	/*
	 * Current Bug List:
	 * 
	 * 1.) Platforming: Something gets weird when you die. Collision on walls is off?
	 * 2.) You can walk through walls if you slide down a wall to the ground
	 * 
	 * 
	 */
	
	import adobe.utils.CustomActions;	
	import com.GameJam2.Antiparticle;
	import flash.display.DisplayObject;
	import com.senocular.utils.KeyObject; //not part of Flash Std. API
	import flash.display.GradientType;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;		
	import flash.events.TimerEvent;
	import flash.display.Sprite;
	import com.Box2D.Dynamics.*;
	import com.Box2D.Collision.*;
	import com.Box2D.Collision.Shapes.*;
	import com.Box2D.Common.Math.*;
	import flash.utils.Timer;
		
	public class ReddEngine extends MovieClip
	{

		public static var instance:ReddEngine = null;
		private static var allowCreation:Boolean = true;						
 								
		public static var Collision:GameContactListener = new GameContactListener();
		
		public var World:b2World;
		var time_count:Timer = new Timer(1000);
		public static var WORLD_CONSTANT:Number = 30;
		
		public static var COMBINE_V:Number = 4;
		
		
		public static var playerObject:Platformer;		
		
		//arrays to keep track of objects added to the stage
		public static var reddObjects:Array = new Array();
		public static var wallfloors:Array = new Array();
		public static var waypoints:Array = new Array();
		public static var links:Array = new Array();
		public static var scriptedActors:Array = new Array();	
		public static var matterObjects:Array = new Array();
		public static var antiMatterObjects:Array = new Array();
		public static var projectileObjects:Array = new Array();
		public static var blackHoleObjects:Array = new Array();
		
		//used to fix a few issues with the camera zooming
		public static var zooming1:Boolean = false;
		public static var zooming2:Boolean = false;				
		public static var maxScroll:int = 0;//used to control how far the camera can scroll
											//up and down
		public static var zoom:Number = 1;//how far in/out the camera is zoomed
		public static var offset:Number = 300;//translational correct for camera zoom
														
		public var key:KeyObject;
		//camera controls
		public static var keyW:uint = 87;
		public static var keyS:uint = 83;
		public static var key1:uint = 49;
		public static var key2:uint = 50;		
		
		
		public var keyR:uint = 82;//respawn
		public var keyEnter:uint = 13; //skip dialogue
		
		public var keyLeft:uint = 37;
		public var keyDown:uint = 40;
		public var keyRight:uint = 39;
		public var keyUp:uint = 38;
		
				
		public static var camera:CameraDetection; //detects when objects are on screen		
		var needLoad:Boolean = true;
		
		
		public function ReddEngine()
		{		 				
			if (!allowCreation)
				throw new Error( "Invalid Singleton access. Please use ReddEngine.getInstance() instead." );
			else
			{
				instance = this;
				addEventListener(Event.ADDED_TO_STAGE, initialize);
			}								
			
		}		

		public function initialize(e:Event) {				
				trace("Creating new ReddEngine");																		
				allowCreation = false;				
															
				stage.addChild(new FPSCounter(stage.width - 80, 5));													
				
				camera = new CameraDetection();
				
				camera.x = stage.x;
				camera.y = stage.y;
				camera.width = 800;
				camera.height = 600;
				
				stage.addChild(camera);																							
								
				
				/*bg = new Background();						
				stage.addChild(bg);
				stage.setChildIndex(bg, 0);
				bg.gotoAndStop(1);*/
						
				key = new KeyObject(this.stage);															
				removeEventListener(Event.ADDED_TO_STAGE, initialize);
				
				//MAEK FIZZIX
				
				// Define the gravity vector
				CreateWorld();				
				addEventListener(Event.ENTER_FRAME, main);
				
				
				
				
				
		}
		
		public function CreateWorld():void {				
			var environment:b2AABB = new b2AABB();
			environment.lowerBound.Set(-1000.0, -1000.0);
			environment.upperBound.Set(1000.0, 1000.0);
			
			var gravity:b2Vec2=new b2Vec2(0.0,0.0);
			World = new b2World(environment, gravity, true);
			
			World.m_contactListener = Collision;
			
			var debug_draw:b2DebugDraw = new b2DebugDraw();
			var debug_sprite:Sprite = new Sprite();			
			addChild(debug_sprite);
			
			debug_draw.m_sprite=debug_sprite;
			debug_draw.m_drawScale=30;
			debug_draw.m_fillAlpha=0.5;
			debug_draw.m_lineThickness=1;
			debug_draw.m_drawFlags = b2DebugDraw.e_shapeBit + b2DebugDraw.e_jointBit;				
			World.SetDebugDraw(debug_draw);										
			
		}		

    	public static function getInstance():ReddEngine {			
			if (instance == null)
			{								
				instance = new ReddEngine();
				allowCreation = false;
			}
			
			return instance;
			
			 
		}
		
		public function addElements(obj:MovieClip)
		{
			
			
			for (var i:Number = 0; i < obj.numChildren; i++)			
			{				
				if (obj.getChildAt(i) == null || !obj.getChildAt(i) is DisplayObject)
				{
					//trace("Object being removed" + obj.name);
					obj.removeChildAt(i);
				}
				else
				{
					newChildHandler(obj.getChildAt(i));		
					//obj.removeChildAt(i);
				}
			}
		}
		
		public function newChildHandler(newThing:DisplayObject)
		{											
			if (newThing is ReddObject) {					
				//trace("new child! : " + newThing);
				var y:int;
				for (var x:int = 0; x < reddObjects.length; x++)
				{
					y = x+1;
					if (newThing == reddObjects[x])
					{						
						break;
					}
				}
				if(y == reddObjects.length)
					reddObjects.push(newThing as ReddObject);		
				else
					newThing = null;
			}			
			if (newThing is Collidable) {				
				wallfloors.push(newThing as Collidable);				
			}		
			else if (newThing is Platformer) {				
				playerObject = (newThing as Platformer);
			}
		}
		
 
 		public function main(e:Event):void
		{								
			scrollWithPlayer();
			World.Step(1 / 30, 10);									
		}
		
		public function scrollWithPlayer():void {					
			if (playerObject != null)
			{											
					if (!playerObject.deadified)
					{						
						this.x = ( -playerObject.x*zoom + offset*zoom);
						this.y = ( -playerObject.y*zoom + offset*zoom) + maxScroll;
					}
					
					if ((key.isDown(keyW) || key.isDown(keyUp)) && playerObject.grounded)	
					{				
						if (maxScroll < 200)
						{
							maxScroll += 5;						
						}
						
					}
					else if((key.isDown(keyS) || key.isDown(keyDown)) && playerObject.grounded)
					{
						if (maxScroll > -200)
						{
							maxScroll -= 5;						
						}
					}		
					
					
					
				}									
					
				if ((key.isDown(key1))|| zooming1)
				{
					zooming1 = true
					if (zoom < 0.99)
					{						
						zoom *= 1.01;
						this.height *= 1.01;
						this.width *= 1.01;						
						offset /=1.01
					}						
					else
					{												
						zooming1 = false;
						zoom = 1;
						offset = 300;
					}
					
				}
				else if ((key.isDown(key2))|| zooming2)				
				{
					zooming2 = true;
					if (zoom > 0.66)
					{
						zoom /= 1.01;
						this.height /= 1.01;
						this.width /= 1.01;
						offset *= 1.01;
					}				
					else
					{
						zoom = 0.66;												
						zooming2 = false;	
						offset = 450;
					}
				}														
			}		
			
		public function DetectCollision(obj1:ReddObject, obj2:ReddObject):Boolean {
			return CollisionDetection.isColliding(obj1, obj2, this, true, 1);
		}
	}
}