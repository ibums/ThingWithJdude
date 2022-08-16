#region collision
var movingPlatform = instance_place(x, y + vspeed + max(1, vspeed), obj_moving_platform);
if (movingPlatform && bbox_bottom <= movingPlatform.bbox_top+1) {
   if(vspeed > 0) {
      while(!place_meeting(x, y + sign(vspeed), obj_moving_platform)) {
         y += sign(vspeed);
      }
      y = round(y);
      gravity = 0;
      vspeed = 0;
   }
   state = handle_grounded;
   x+= movingPlatform.moveX;
   y+= movingPlatform.moveY;
}

//Check if we should be falling
else if !place_meeting(x, y + max(0, vspeed) + 1, obj_block) {
   gravity = 1.25;
} 
//If not falling, snap ourselves to ground
else if vspeed > 0 {
	gravity = 0;
	vspeed = 0;
   foundground = false;
	for(var iy = 0; !foundground; iy++) {
      if place_meeting(x, y + iy, obj_collision) {
			y = y + iy - 1;
			foundground = true;
         state = handle_grounded;
		}
   }
}

//moving platforms we want to be able to jump through the bottom
if place_meeting(x, y + vspeed + 1, obj_block) and vspeed < 0 {
	vspeed = 0;
	var iy = 0;
	foundCeiling = false;
   for(var iy = 0; !foundCeiling; iy++) {
      if place_meeting(x, y - iy, obj_block) {
			y = y - iy + 1;
			foundCeiling = true;
		}
   }
}

check_for_walls();
 
var foundwall = false;

//horizontal collission
if leftwall and hspeed <= 0 {
	hspeed = 0;
   foundwall = false;
   for(var ix = 0; !foundwall; ix++) {
      if place_meeting(x - ix, y, obj_block) {
			x = x - ix + 1;
			foundwall = true;
		}
   }
}

if rightwall and hspeed >= 0 {
   hspeed = 0;
   foundwall = false;
   for(var ix = 0; !foundwall; ix++) {
      if place_meeting(x + ix, y, obj_block) {
   		x = x + ix - 1;
   		foundwall = true;
   	}
   }
}
//sloped block vertical collision

var _slopeid = instance_place(x + hspeed, y + vspeed + 1, obj_diagonal_up)
if _slopeid != noone print(y, , _slopeid.bbox_top);

//treating as normal ground at top

if place_meeting(x+hspeed, y + vspeed + 1, _slopeid) and x+hspeed > _slopeid.bbox_right and vspeed >= 0 {
   gravity = 0;
   vspeed = 0;
   var foundground = false;
   for(var iy = 0; !foundground; iy++) {
      if place_meeting(x+hspeed, y + iy, _slopeid) {
   		y = y + iy-1;
   		foundground = true;
         state = handle_grounded;
      }
   }
}

   //taking into account the slope
else if (hspeed >= 0) and _slopeid != noone and x + hspeed>_slopeid.bbox_left and vspeed >= 0 {
   
   //use this ratio to adjust velocity?
   var slope_ratio = _slopeid.sprite_width/_slopeid.sprite_height;
	//find point of collission on triangle
   
	var y_top_slope=(round(
		((x + hspeed-_slopeid.bbox_left)/(_slopeid.bbox_right-_slopeid.bbox_left))
		*(_slopeid.bbox_top-_slopeid.bbox_bottom)+_slopeid.bbox_bottom
		));
   if (y+vspeed>=y_top_slope-(sprite_height/2)-1)
      {
         
   		y = max(y_top_slope-sprite_height/2-1, _slopeid.bbox_top-sprite_height/2-1);
         vspeed = 0;
   		gravity=0;
   		state = handle_grounded;

		}
	}

#endregion collision

#region movement
function handle_moving_ground() {
   //Update if we want to have air movement different from ground movement
   if xIntent() == -1 and !leftwall and hspeed > -10 {
   	hspeed = hspeed - _acceleration;
   }

   if xIntent() == 1 and !rightwall and hspeed < 10 {
      hspeed = hspeed + _acceleration;
   }

   if xIntent() == 0 {
   	if hspeed > 0 {
   		hspeed = hspeed - _friction;
   		hspeed = hspeed - _friction < 0 ? 0 : hspeed - _friction;
   	}
      
   	if hspeed < 0 {
   		hspeed = hspeed + _friction;
   		hspeed = hspeed + _friction > 0 ? 0 : hspeed + _friction;
   	}
   }
}

function handle_moving_air() {
   //Update if we want to have air movement different from ground movement
   if xIntent() == -1 and !leftwall and hspeed > -10 {
   	hspeed = hspeed - _acceleration;
   }

   if xIntent() == 1 and !rightwall and hspeed < 10 {
      hspeed = hspeed + _acceleration;
   }

   if xIntent() == 0 {
   	if hspeed > 0 {
   		hspeed = hspeed - _friction;
   		hspeed = hspeed - _friction < 0 ? 0 : hspeed - _friction;
   	}
      
   	if hspeed < 0 {
   		hspeed = hspeed + _friction;
   		hspeed = hspeed + _friction > 0 ? 0 : hspeed + _friction;
   	}
   }
}
#endregion movement

#region stateHandlers
handle_idle = function() {
   //DO IDLE STUFF
   handle_grounded();
}

handle_wallGrabIdle = function() {
   //TODO: implement if needed
}

handle_airborne = function () {
   jump_height_modifier = 1;
   if (rightwall xor leftwall) and jumpIntent() == 1 {
   	vspeed = -20;
   	hspeed = rightwall ? -20 : 20;
   } else if (rightwall and leftwall) and jumpIntent() == 1{
      vspeed = -25;
   } else if(grappleIntent() == 1) {
      //When grappling in the air, we want to skip handling air movement and instead,
      //use the grapple movement
      state = handle_grapple;
      return;
   }

   handle_moving_air();
}

handle_grounded = function() {
   if(jumpIntent() == 1) {
      jump_height_modifier = 1;
      vspeed = -3;
	   state = handle_jumping;
   }
   
   if(grappleIntent() == 1) {
      //When grappling on the ground, we want to skip handling ground movement and instead,
      //use the grapple movement
      state = handle_grapple;
      return;
   }

   handle_moving_ground();
}


handle_jumping = function () {
   if jumpIntent() == 2 and jump_height_modifier < 30 {
   	vspeed = vspeed - (7 / jump_height_modifier);
   	++jump_height_modifier;
   } else if jumpIntent() == 0 {
      state = handle_airborne;
   	jump_height_modifier = 1;
   }
   
   handle_moving_air();
}

handle_grapple = function() {
   aimX = mouse_x;
   aimY = mouse_y;
   if(tongueInst == noone) {
      if(make_tongue() == noone) {
         //TODO save previous state and use it here
         state = handle_grounded;
         return;
      }
   }
   
   if(!tongueInst.reachedDestination) {
      //Pull ourselves to the destination
     // handle_moving_air();
   } else {
     //Reached enemy, start pulling ourselves to enemy 
      var tongue_found = collision_circle(x, y, grappleEndRadius, tongueInst, true, true);
      if(tongue_found == noone) {
         print("NOONE");
         move_towards_point(tongueInst.destinationX, tongueInst.destinationY, 30);
      } else {      
         print("DESTROY");
        instance_destroy(tongueInst);
        tongueInst = noone;
        state = handle_airborne;
      }
   }
}
#endregion stateHandlers

#region inputIntents
function jumpIntent() {
   if (keyboard_check_pressed(vk_space)) {
      return 1;
   }
   else if (keyboard_check(vk_space)) {
      return 2;
   }
   else return 0;
}

function xIntent() {
   if(keyboard_check(vk_right)) return 1;
   if(keyboard_check(vk_left)) return -1;
   return 0;
}

function grappleIntent() {
   if(mouse_check_button_pressed(mb_left)) return 1;
   else return 0;
}
#endregion inputIntents

#region helperFunctions
function make_tongue() {
   var ret = collision_line_point(x, y,  other.aimX, other.aimY, obj_collision, true, true);
   
   //Dont shoot tongue if missed
   if(ret[0] == noone) {
      return noone; //Do nothing
   }
   tongueInst = instance_create_layer(x, y, "Instances", obj_tongue);
   with (tongueInst) {    
       owner_instance = other.id;
       destinationX = ret[1];
       destinationY = ret[2];
   }
}

if(state == pointer_null) {
   state = handle_idle;
}
#endregion
state();