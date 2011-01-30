package com.reddengine
{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import com.SoundAssets.*;
	/**
	 * ...
	 * @author ...
	 */
	public class SoundEngine
	{
		//URL Requests for all sound effects
		
		static var absorb:Sound = new AbsorbCollision();
		static var bgAmbience:Sound = new BGAmbience();
		static var bhHum:Sound = new BHHum();
		static var bhAbsorb:Sound = new BHAbsorb();
		static var collision1:Sound = new Collision1();
		static var collision2:Sound = new Collision2();
		static var destroy:Sound = new Destroy();
		static var explosion:Sound = new Explosion();
		static var gameOver:Sound = new GameOver();
		static var shoot:Sound = new Shoot();
		
		static var bgmPlaying:Boolean = false;
		static var bhHumPlaying:Boolean = false;
		
		static var channel:SoundChannel;
		static var bgmChannel:SoundChannel;
		static var bhChannel:SoundChannel;
		
		
		public function SoundEngine() 
		{
			//possibly add all of these into an array for stopping
		}
		
		public static function playBGM() {				
			if (!bgmPlaying)
			{
				//trace("switchingBGM for frame " + ReddEngine.getInstance().currentFrame);
				bgmPlaying = true;
				bgmChannel = bgAmbience.play(0, 9999);				
			}
		}
		
		public static function stopBGM() {
			//trace("stoppingBGM");			
			if (bgmPlaying )
			{
				bgmChannel.stop();
				bgmPlaying = false;
			}			
		}
		
		public static function playAbsorb() {
			absorb.play(0, 0);
		}
		
		public static function playBHAbsorb() {
			bhAbsorb.play(0, 0);
		}
		
		public static function playBHHum() {				
			if (!bhHumPlaying)
			{
				//trace("switchingBGM for frame " + ReddEngine.getInstance().currentFrame);
				bhHumPlaying = true;
				bhChannel = bhHum.play(0, 9999);				
			}
		}
		
		public static function stopBHHum() {
			//trace("stoppingBGM");			
			if (bhHumPlaying )
			{
				bhChannel.stop();
				bhHumPlaying = false;
			}			
		}
		
		public static function playCollision1() {
			collision1.play(0, 0);
		}
		
		public static function playCollision2() {
			collision2.play(0, 0);
		}
		
		public static function playDestroy() {
			destroy.play(0, 0);
		}
		
		public static function playExplosion() {
			explosion.play(0, 0);			
		}
		
		public static function playGameOver() {
			gameOver.play(0, 0);
		}
		
		public static function playShoot() {
			shoot.play(0, 0);
		}
		
	}

}