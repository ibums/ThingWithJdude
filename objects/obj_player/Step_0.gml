#region collision
check_collision();
function set_grounded() {
   gravity = 0;
   vspeed = 0;
   state = handle_grounded;
}

function try_snap_to_object_ground(object) {
   print("Snap to ground");
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
#endregion collision

#region movement

function handle_moving_ground() {
   //Update if we want to have air movement different from ground movement
   if xIntent() == -1 and !leftwall and hspeed > -maxMoveSpeed {
   	hspeed = hspeed - _acceleration;
   }

   if xIntent() == 1 and !rightwall and hspeed < maxMoveSpeed {
      hspeed = hspeed + _acceleration;
   }

   if xIntent() == 0 or abs(hspeed) > maxMoveSpeed{
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

//Update if we want to have air movement different from ground movement
function handle_moving_air() {
   if (xIntent() == -1 and !leftwall and hspeed > -maxMoveSpeed) {
   	hspeed = hspeed - _acceleration;
   }

   if (xIntent() == 1 and !rightwall and hspeed < maxMoveSpeed) {
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

function grapple_boost() { 
   hspeed += (grappleBoostAcceleration * cos(grappleDir));
   vspeed += (grappleBoostAcceleration * sin(grappleDir));
}

function jump(height) {
   jump_height_modifier = 1;
   vspeed = height;
   state = handle_jumping;
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
   	vspeed = -2 * wallJumpSpeed;
   	hspeed = rightwall ? -wallJumpSpeed : wallJumpSpeed;
   } else if (rightwall and leftwall) and jumpIntent() == 1 {
      vspeed = -2 * wallJumpSpeed + wallJumpSpeed / 2;
   } else if(jumpIntent() == 1 && jumpCharges > 0) {
      jumpCharges--;
      //Ensure if the player is trying to double jump the opposite direction they are moving
      //Set their horizontal velocity to 0
      if((hspeed > 0 && xIntent() == -1) || (hspeed < 0 && xIntent() == 1)) {
         hspeed = doubleJumpHorizontalSpeed * xIntent();
      }

      jump(doubleJumpHeight);   
   }
   
   if(grappleIntent() == 1) {
      //Override double jump stuff
      handle_grapple();
      state = handle_grapple;
   }

   handle_moving_air();
   if(tongueInst != noone) {
      handle_grapple();
   }   
}



handle_grounded = function() {
   jumpCharges = maxJumpCharges;
   grapple_charge = 1;
   if(tongueInst != noone) {
      state = handle_grapple;
   }
   if(jumpIntent() == 1) {
      jump(jumpHeight);
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
   if jumpIntent() == 2 and jump_height_modifier < jumpHeightModifierMax {
   	vspeed = vspeed - (7 / jump_height_modifier);
   	++jump_height_modifier;
   } else if jumpIntent() == 0 {
      state = handle_airborne;
   	jump_height_modifier = 1;
   }
   
   if(grappleIntent() == 1) {
      //Override double jump stuff
      handle_grapple();
      state = handle_grapple;
   }
   handle_moving_air();
}

handle_grapple = function() {
   aimX = mouse_x;
   aimY = mouse_y;
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
   var _list = ds_list_create();
   var _num = collision_circle_list(x, y, meleeOffset, obj_enemy, false, true, _list, false);
   if (_num > 0) {
       for (var i = 0; i < _num; ++i) {
          attackInst = instance_create_layer(_list[| i].x, _list[| i].y, "Instances", obj_melee_hitbox);
          with (attackInst) {    
             player_inst = other.id;
          }
       }
   }
   ds_list_destroy(_list);
}

#endregion stateHandlers

#region helperFunctions
function make_tongue() {
   print("GRAPPLE");
   var theta = facing == 1 ? 0 : degtorad(180);
   maxXAim = maxGrappleLen * cos(theta) + x;
   maxYAim = maxGrappleLen * sin(theta) + y;   
   var ret = collision_line_point(x, y,  maxXAim, maxYAim, obj_enemy, true, true);
   
   //Dont shoot tongue if missed
   if(ret[0] == noone) {
      print("NOTHING");
      return noone; //Do nothing
   }
   grappleDir = theta;
   tongueInst = instance_create_layer(x, y, "Instances", obj_tongue);
   with (tongueInst) {    
       owner_instance = other.id;
       destinationX = ret[0].x;
       destinationY = ret[0].y;
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
   y-camera_get_view_height(current_view)/2);
}

function update_facing() {
   if(xIntent() != 0) {
      facing = xIntent();
   }
}

function set_grapple_boosted() {
   if(tongueInst != noone) {
      grappleboosted = true;
   }
}
#endregion

#region movingPlatform
var movingPlatform = instance_place(x, y + vspeed + max(1, vspeed), obj_moving_platform);
if (movingPlatform && bbox_bottom <= movingPlatform.bbox_top + 1) {
   try_snap_to_object_ground(obj_moving_platform);
   x+= movingPlatform.moveX;
   y+= movingPlatform.moveY;
}

else if !place_meeting(x + hspeed, y + max(0, vspeed) + 1, obj_block) {
   //Check if we should be falling
   gravity = .75;
   if(jumpIntent() == 0) {
      state = handle_airborne;
   }
   
}

if place_meeting(x, y + vspeed + 1, obj_block)  {
   //moving platforms we want to be able to jump through the bottom
	try_snap_to_object_ceiling(obj_block);
}

check_for_walls();
#endregion movingPlatform

// If for whatever reason state is null, just set the state to idle
if(state == pointer_null) {
   state = handle_idle;
}

if(grappleboosted) {
   //Set the grapple boost time alarm
   if(alarm[0] == -1) {
      alarm[0] = grappleBoostTime;
   }
   state = handle_grapple;
   grapple_boost();
}

// Update the player facing variable before updating state
update_facing();
state();
grappleSpeed = speed > baseGrappleSpeed ? speed : baseGrappleSpeed;
// Attacking currently isnt a state because we want to be able to do it while in all other
// states
update_attack_input();

// Update camera to follow player
update_camera();