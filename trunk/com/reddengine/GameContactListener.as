package  com.reddengine
{
	
	import com.Box2D.Collision.*;	
	import com.Box2D.Collision.Shapes.*;
	import com.Box2D.Common.Math.*;
	import com.Box2D.Dynamics.*;
	import com.Box2D.Dynamics.Contacts.*;
	import com.GameJam2.Antiparticle;
	import com.GameJam2.BlackHoleParticle;
	import com.GameJam2.Particle;
	import com.GameJam2.ShotParticle;
	
	public class GameContactListener extends b2ContactListener
	{              
        /// Called when a contact point is added. This includes the geometry
        /// and the forces.
        public override function Add(point:b2ContactPoint) : void
        {
                var obj1:ReddObject = point.shape1.GetBody().GetUserData() as ReddObject;
                var obj2:ReddObject = point.shape2.GetBody().GetUserData() as ReddObject;               									
					
				
				
					if (obj1 is BlackHoleParticle)
						(obj1 as BlackHoleParticle).checkCollisions(obj2);
					else if (obj2 is BlackHoleParticle)
						(obj2 as BlackHoleParticle).checkCollisions(obj2);
					else if (obj1 is Particle)
						(obj1 as Particle).checkCollisions(obj2);
					else if (obj1 is Antiparticle)
						(obj1 as Antiparticle).checkCollisions(obj2);								
					else if (obj2 is Particle)
						(obj2 as Particle).checkCollisions(obj1);
					else if (obj2 is Antiparticle)
						(obj2 as Antiparticle).checkCollisions(obj1);												
        }
}

}