package com.GameJam2
{
	import com.GameJam2.Particle;
	
	/**
	 * ...
	 * @author Anthony Ghavami
	 * This class is a hack intended for pieces of matter 
	 * that are created out of a matter conversion (antimatter -> matter).
	 * 
	 * It would take too much work to do this properly.
	 */
	public class ExistingParticle extends Particle 
	{
		
		public function ExistingParticle(x:Number, y:Number, r:Number) 
		{
			super(x,y,r);
		}
		
		public function SetValue(val:int ):void {
			this.value = val;
		}
		
	}

}