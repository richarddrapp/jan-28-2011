//www.robkeplin.com/blog

package com.reddengine {
	
	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.Event;
	
	public class Preloader extends MovieClip {
		
		private var outerBar:Sprite;
		private var progressBar:Sprite;
		private var percentTxt:TextField;
		private var format:TextFormat;
		private var loader:Loader;		
		private var game:MovieClip;
		
		public function Preloader() {
			setupGUI();
			
			trace("Loading...!");
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, updateDisplay);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, showStartButton);
			loader.load(new URLRequest("GameJam2.swf"))	
			
			Start.visible = false;				
										
		}
		
		
		
		
		private function updateDisplay(e:ProgressEvent):void {
			var percent:int = Math.round((e.bytesLoaded / e.bytesTotal) * 100);
			setPercentTxt(percent);
			setProgressBar(percent);
		}
		
		private function showStartButton(e:Event) {
			trace("ready to go");
			removeChild(outerBar);
			removeChild(progressBar);
			removeChild(percentTxt);
						
			
			game = loader.content as MovieClip;
			game.x = loader.content.x;
			game.y = loader.content.y;
			game.width = loader.content.width;
			game.height = loader.content.height;
			game.stop();			
			outerBar = null;
			progressBar = null;
			percentTxt = null;			
			
			
			Start.x = stage.stageWidth / 2;
			Start.y = stage.stageHeight / 2;
			Start.visible = true;																			
			
			Start.addEventListener(MouseEvent.CLICK, showSwf);						
		}
		
		private function showSwf(e:Event):void {
			Start.removeEventListener(MouseEvent.CLICK, showSwf)
			removeChild(Start);	
			removeChild(BG);
			trace("Showing swf");
			
			game.gotoAndStop(1);
			addChild(game);
		}
		
		private function setupGUI():void {
			format = new TextFormat();
			format.color = 0x35FF11;
			format.font = "Verdana";
			format.size = 10;
			
			percentTxt = new TextField();
			percentTxt.x = stage.stageWidth/2 - 20;
			percentTxt.y = stage.stageHeight/2 + 25;
			setPercentTxt(0);
			
			outerBar = new Sprite();
			outerBar.graphics.lineStyle(1, 0x35FF11);
			outerBar.graphics.beginFill(0xFFFFFF);
			outerBar.graphics.drawRect(stage.stageWidth/2 - 60, stage.stageHeight/2, 100, 10);
			outerBar.graphics.endFill();
			
			progressBar = new Sprite();
			setProgressBar(0);
			
			addChild(outerBar);
			addChild(progressBar);
			addChild(percentTxt);
		}
		
		private function setPercentTxt(perc:int):void {
			percentTxt.text = perc + "%";
			percentTxt.setTextFormat(format);
		}
		
		private function setProgressBar(perc:int):void {
			progressBar.graphics.beginFill(0x35FF11);
			progressBar.graphics.drawRect(stage.stageWidth/2 - 60, stage.stageHeight/2, perc, 10);
			progressBar.graphics.endFill();
		}
	}
}
