#region collision
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
         if place_meeting(x + ix, y, obj_collision) {
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
         if place_meeting(x - ix, y, obj_collision) {
   			x = x - ix + 1;
   			foundwall = true;
            print("snap to left");
   		}
      }
   }
}

function wall_jump_check() {
   
   var x_left = 999;
   
   var x_right = 999;
   
   var bbox_width = bbox_right - bbox_left;
   
   var bbox_height = bbox_bottom - bbox_top;
   
   var buffer = bbox_width/1.5;
      //this can be adjusted to taste.
   var no_jump_zone = bbox_height / 4;
   
   var line_top_right = collision_line_point(bbox_right - 1, bbox_top + no_jump_zone,
   bbox_right-1 + buffer, bbox_top + no_jump_zone, obj_collision, false, true);
   
   var line_bottom_right = collision_line_point(bbox_right - 1, bbox_bottom - 1 - no_jump_zone,
   bbox_right-1 + buffer, bbox_bottom-1 - no_jump_zone, obj_collision, false, true);
   
   var line_top_left = collision_line_point(bbox_left, bbox_top + no_jump_zone,
   bbox_left - buffer, bbox_top + no_jump_zone, obj_collision, false, true);
   
   var line_bottom_left = collision_line_point(bbox_left, bbox_bottom - 1 - no_jump_zone,
   bbox_left - buffer, bbox_bottom-1 - no_jump_zone, obj_collision, false, true);

   if (line_top_right[0] = noone and line_bottom_right[0] = noone and line_top_left[0] = noone and line_bottom_left[0] = noone) {
      return false;
   }

   if (line_top_right[0] != noone or line_bottom_right[0] != noone) {
      x_right = floor(min(line_top_right[1], line_bottom_right[1]));
   }
   
   if (line_top_left[0] != noone or line_bottom_left[0] != noone) {
      x_left = ceil(max(line_top_left[1], line_bottom_left[1]));
   }
   
   if (abs(x - x_right) < abs(x - x_left)) {
      x = x_right - bbox_width/2;
   } else {
      x = x_left + bbox_width/2;
   }
   
   hspeed = 0;
   vspeed = 0;
   return true;
}

#endregion collision

#region movement

function handle_moving_ground() {
   //Update if we want to have air movement different from ground movement
   if (handler._kLeft and !leftwall and hspeed > -maxMoveSpeed) {
   	hspeed = hspeed - _acceleration;
   }

   if (handler._kRight and !rightwall and hspeed < maxMoveSpeed) {
      hspeed = hspeed + _acceleration;
   }

   if (!(handler._kLeft or handler._kRight) or abs(hspeed) > maxMoveSpeed) {
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

//Update if we want to have air movement different from ground movement
function handle_moving_air() {
   if (handler._kLeft and !leftwall and hspeed > -maxMoveSpeed and !walljumping) {
   	hspeed = hspeed - _acceleration;
   }

   if (handler._kRight and !rightwall and hspeed < maxMoveSpeed and !walljumping) {
      hspeed = hspeed + _acceleration;
   }

   if (!(handler._kLeft or handler._kRight)) {
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
   if (handler._kAttack) {
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

handle_walljump = function() {
   if (alarm[1] == -1) {
      alarm[1] = wallJumpTime;
   }
   vspeed = 0;
   gravity = 0;
}

handle_airborne = function () {
   jump_height_modifier = 1;
   if ((rightwall xor leftwall) and handler._kJump) {
   	state = handle_walljump;
      walljumping = true;
   } else if ((rightwall and leftwall) and handler._kJump) {
      state = handle_walljump;
      walljumping = true;
   } else if (handler._kJump and jumpCharges > 0) {
      jumpCharges--;
      //Ensure if the player is trying to double jump the opposite direction they are moving
      //Set their horizontal velocity to 0
      if ((hspeed > 0 and handler._kLeft) or (hspeed < 0 and handler._kRight)) {
         var djumpdir = 1;
         
         if (handler._kLeft) {
            djumpdir = -1;
         } else if (handler._kRight) {
            djumpdir = 1;
         }
         
         hspeed = doubleJumpHorizontalSpeed * djumpdir;
      }
      jump(doubleJumpHeight);   
   } else if ((rightwall xor leftwall) and handler._kDash) {
   	state = handle_dash;
      dashing = true;
   } else if ((rightwall and leftwall) and handler._kDash) {
      state = handle_dash;
      dashing = true;
   }
   //Dash if dash button is used and you have dash charges. Downdash does not require a charge
   if (handler._kDash and (dashCharges > 0 or handler._kDown)) {
      if (!handler._kDown) {
         dashCharges = 0;
      }
      change_state_dash();
   } else if (handler._kGrapple) {
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
   dashCharges = maxDashCharges;
   jumpCharges = maxJumpCharges;
   grapple_charge = 1;
   if(tongueInst != noone) {
      state = handle_grapple;
   }
   if (handler._kJump) {
      jump(jumpHeight);
   }
   
   if (handler._kGrapple) {
      //When grappling on the ground, we want to skip handling ground movement and instead,
      //use the grapple movement
      state = handle_grapple;
   } else if (handler._kDash) {
      change_state_dash();
   } else {
      handle_moving_ground();
   }
}

handle_jumping = function () {
   if (handler._kJumpHold and jump_height_modifier < jumpHeightModifierMax) {
   	vspeed = vspeed - (7 / jump_height_modifier);
   	++jump_height_modifier;
   } else if (!handler._kJump) {
      state = handle_airborne;
   	jump_height_modifier = 1;
   }
   
   if (handler._kGrapple) {
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
   if (tongueInst == noone and make_tongue() == noone) {
      //TODO save previous state and use it here
      state = handle_grounded;
      return;
   }
   
   if (!tongueInst.reachedDestination) {
      //Pull ourselves to the destination
     // handle_moving_air();
   } else {
      //Reached enemy, start pulling ourselves to enemy 
      if (distance_to_point(tongueInst.x, tongueInst.y) > grappleEndRadius) {
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

handle_dash = function() {
   //Downdash
   if (handler._kDown) {
      vspeed = terminalVelocity;
      gravity = 0;
      hspeed = 0;
      alarm[0] = -1; //downdash is only one frame
      dashing = false;
      if (is_grounded()) {
         state = handle_grounded;
      } else {
         state = handle_airborne;
      }
   } else if ((leftwall or rightwall) and !is_grounded() and alarm[0] == dashTime - 1) {
      vspeed = 0;
      gravity = 0;
      facing = leftwall ? 1 : -1;
      hspeed = facing * dashSpeed;
   } else { //Side Dash
      vspeed = 0;
      gravity = 0;
      hspeed = facing * dashSpeed;
   }
   
   if (handler._kJump) {
      jump(jumpHeight);
      if (!is_grounded()) {
         jumpCharges = 0;   
      }
      alarm[0] = -1;
      dashing = false;
   }
}



#endregion stateHandlers

#region helperFunctions
function is_grounded() {
   //return place_meeting(x, y + max(0, vspeed) + 1, obj_collision);
   
   var line_left = collision_line_point(bbox_left, y, bbox_left, bbox_bottom+2,
   obj_collision, true, true);
   
   var line_right = collision_line_point(bbox_right-1, y, bbox_right-1, bbox_bottom+2,
   obj_collision, true, true);
   
   var line_left_semi = collision_line_point(bbox_left, bbox_bottom, bbox_left, bbox_bottom+2,
   obj_semisolid, true, true);
   
   var line_right_semi = collision_line_point(bbox_right-1, bbox_bottom, bbox_right-1, bbox_bottom+2,
   obj_semisolid, true, true);
  
   return (line_left[0] != noone or line_right[0] != noone and vspeed >= 0)
   or ((line_left_semi[0] != noone or line_right_semi[0] != noone)
   and line_left[0] = noone and line_right[0] = noone and vspeed >= 0
   and !handler._kDown);
}

function change_state_dash() {
   //Set alarm for dashing. Dash until alarm is over. Alarm handles state change
   if (alarm[0] == -1) {
      alarm[0] = dashTime;
   }
   dashing = true;
   state = handle_dash;
}
function make_tongue() {
   var theta = facing == 1 ? 0 : degtorad(180);
   maxXAim = maxGrappleLen * cos(theta) + x;
   maxYAim = maxGrappleLen * sin(theta) + y;   
   var ret = collision_line_point(x, y,  maxXAim, maxYAim, obj_enemy, true, true);
   
   //Dont shoot tongue if missed
   if (ret[0] == noone) {
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
   if ((handler._kLeft or handler._kRight) and !dashing) {
      facing = handler._kLeft ? -1 : 1;
   }
}

function set_grapple_boosted() {
   if (tongueInst != noone) {
      grappleboosted = true;
   }
}
#endregion

#region movingPlatform
var movingPlatform = instance_place(x, y + vspeed + max(1, vspeed), obj_moving_platform);
if (movingPlatform and bbox_bottom <= movingPlatform.bbox_top + 1) {
   try_snap_to_object_ground(obj_moving_platform);
   x+= movingPlatform.moveX;
   y+= movingPlatform.moveY;
} else if !is_grounded() {
   //Check if we should be falling
   gravity = grav;
   if ((!handler._kJump and !handler._kJumpHold) and !dashing and !walljumping) {
      state = handle_airborne;
   }
   
}

if (place_meeting(x, y + vspeed + 1, obj_collision))  {
   //moving platforms we want to be able to jump through the bottom
	try_snap_to_object_ceiling(obj_collision);
}

//Magnet to walls for wall jumps in the air
if ((handler._kDash or handler._kJump) and !is_grounded()) {
   wall_jump_check();
}

check_for_walls();
#endregion movingPlatform

// If for whatever reason state is null, just set the state to idle
if (state == pointer_null) {
   state = handle_idle;
}

if (grappleboosted) {
   //Set the grapple boost time alarm   
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

if (debugIntent()) {
   print("DEBUG");
}

check_semisolid_collision();

check_collision();