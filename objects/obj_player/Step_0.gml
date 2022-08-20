#region collision
check_collision();
function set_grounded() {
   gravity = 0;
   vspeed = 0;
   state = handle_grounded;
}

function try_snap_to_object_ground(object) {
   if(vspeed > 0) {
      while(!place_meeting(x, y + 1, object)) {
         y++;
      }
      y = round(y);
      set_grounded();
   }
}

function try_snap_to_object_ceiling(object) {
   if (vspeed < 0) {
   	vspeed = 0;
   	var iy = 0;
   	foundCeiling = false;
      for(var iy = 0; !foundCeiling; iy++) {
         if place_meeting(x, y - iy, object) {
   			y = y - iy + 1;
   			foundCeiling = true;
   		}
      }
   }
}

function try_snap_to_object_right_wall(object) {
   var foundwall = false;
   if (hspeed >= 0) {
      hspeed = 0;
      foundwall = false;
      for(var ix = 0; !foundwall; ix++) {
         if place_meeting(x + ix, y, obj_block) {
      		x = x + ix - 1;
      		foundwall = true;
            print("snap to right");
      	}
      }
   }
}

function try_snap_to_object_left_wall(object) {
   var foundwall = false;
   if (hspeed <= 0) {
   	hspeed = 0;
      foundwall = false;
      for(var ix = 0; !foundwall; ix++) {
         if place_meeting(x - ix, y, obj_block) {
   			x = x - ix + 1;
   			foundwall = true;
            print("snap to left");
   		}
      }
   }
}

var movingPlatform = instance_place(x, y + vspeed + max(1, vspeed), obj_moving_platform);
if (movingPlatform && bbox_bottom <= movingPlatform.bbox_top + 1) {
   try_snap_to_object_ground(obj_moving_platform);
   x+= movingPlatform.moveX;
   y+= movingPlatform.moveY;
}

else if !place_meeting(x + hspeed, y + max(0, vspeed) + 1, obj_block) {
   //Check if we should be falling
   gravity = 1.25;
}

check_for_walls();

//horizontal collision



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
   if (xIntent() == -1 and !leftwall and hspeed > -10) {
   	hspeed = hspeed - _acceleration;
   }

   if (xIntent() == 1 and !rightwall and hspeed < 10) {
      hspeed = hspeed + _acceleration;
   }

   if (xIntent() == 0) {
   	if (hspeed > 0) {
   		hspeed = hspeed - _friction;
   		hspeed = hspeed - _friction < 0 ? 0 : hspeed - _friction;
   	}
      
   	if (hspeed < 0) {
   		hspeed = hspeed + _friction;
   		hspeed = hspeed + _friction > 0 ? 0 : hspeed + _friction;
   	}
   }
}

function update_attack_input() {
   if(meleeIntent()) {
      handle_attack();
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
      handle_moving_air();
   } else if (rightwall and leftwall) and jumpIntent() == 1 {
      vspeed = -25;
      handle_moving_air();
   } else if(grappleIntent() == 1) {
      //When grappling in the air, we want to skip handling air movement and instead,
      //use the grapple movement
      state = handle_grapple;
   }
   
   if(tongueInst != noone) {
      handle_grapple();
   }   
}

handle_grounded = function() {
   grapple_charge = 1;
   if(tongueInst != noone) {
      state = handle_grapple;
   }


   if(jumpIntent() == 1)
   {
      jump_height_modifier = 1;
      vspeed = -3;
	   state = handle_jumping;
   }
   //this solves clipping into blocks in 1 tile tall tunnels
   //however if a moving platform or other collission object
   //that we should be able to jump through is above us,
   //it will also stop us from jumping. Maybe we can give blocks
   //like that a seperate atribute that we can check for? - ibums
   
   //welp, this is broken now, we need to find a new way to check
   //for ceilings before jumping - ibums
   
   if(grappleIntent() == 1) {
      //When grappling on the ground, we want to skip handling ground movement and instead,
      //use the grapple movement
      state = handle_grapple;
   } else {
      handle_moving_ground();
   }
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
   print("GRAPPLE");
   grapple_charge = 0;
   if(tongueInst == noone && make_tongue() == noone) {
      //TODO save previous state and use it here
      state = handle_grounded;
      return;
   }
   
   if(!tongueInst.reachedDestination) {
      //Pull ourselves to the destination
     // handle_moving_air();
   } else {
      //Reached enemy, start pulling ourselves to enemy 
      if(distance_to_point(tongueInst.x, tongueInst.y) > grappleEndRadius) {
         facing = sign(tongueInst.destinationX - x);
         move_towards_point(tongueInst.destinationX, tongueInst.destinationY, grappleSpeed);
      } else {
        instance_destroy(tongueInst);
        tongueInst = noone;
        state = handle_airborne;
      }
   }
}

handle_attack = function() {
   attackInst = instance_create_layer(x + (facing * meleeOffsetX) + hspeed, y + vspeed - meleeOffsetY, "Instances", obj_melee_hitbox);
   with (attackInst) {    
       player_inst = other.id;
   }
}

#endregion stateHandlers

#region helperFunctions
function make_tongue() {
   var ret = collision_line_point(x, y,  other.aimX, other.aimY, obj_enemy, true, true);
   
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

function refresh_grapple() {
   grapple_charge = 1;
}

function update_camera() {
   var current_view = view_camera[0];
   camera_set_view_pos(
   current_view, 
   x-camera_get_view_width(current_view)/2, 
   y-camera_get_view_height(current_view));
}

function update_facing() {
   if(xIntent() != 0) {
      facing = xIntent();
   }
}
#endregion

// If for whatever reason state is null, just set the state to idle
if(state == pointer_null) {
   state = handle_idle;
}

// Update the player facing variable before updating state
update_facing();
state();

// Attacking currently isnt a state because we want to be able to do it while in all other
// states
update_attack_input();

// Update camera to follow player
update_camera();