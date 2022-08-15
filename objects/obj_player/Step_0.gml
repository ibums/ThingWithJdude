//vertical collission

airborne = !place_meeting(x, y + vspeed + 1, obj_block);

//Check for moving platform below character
var movingPlatform = instance_place(x, y + max(1, vspeed), obj_moving_platform);
if (movingPlatform && bbox_bottom <= movingPlatform.bbox_top+1) {
   if(vspeed > 0) {
      while(!place_meeting(x, y + sign(vspeed), obj_moving_platform)) {
         y += sign(vspeed);
      }
      y = round(y);
      gravity = 0;
      vspeed = 0;
   }
   state = state_type.grounded;
   x+= movingPlatform.moveX;
   y+= movingPlatform.moveY;
}

//Check if we should be falling
else if !place_meeting(x, y + max(1, vspeed) + 1, obj_block) {
   gravity = 1.25;
} 
//If not falling, snap ourselves to ground
else if vspeed > 0 {
	gravity = 0;
	vspeed = 0;
   var foundground = false;
	for(var iy = 0; !foundground; iy++) {
      if place_meeting(x, y + iy, obj_collision) {
			y = y + iy - 1;
			foundground = true;
         state = state_type.grounded;
		}
   }
}

//moving platforms we want to be able to jump through the bottom
if place_meeting(x, y + vspeed + 1, obj_block) and vspeed < 0 {
	vspeed = 0;
	var iy = 0;
	var foundCeiling = false;
   for(var iy = 0; !foundCeiling; iy++) {
      if place_meeting(x, y - iy, obj_block) {
			y = y - iy + 1;
			foundCeiling = true;
		}
   }
}

leftwall = place_meeting(x - abs(hspeed) - 1, y, obj_block);
rightwall = place_meeting(x + abs(hspeed) + 1, y, obj_block);
var foundwall = false;

//horizontal collission
if leftwall and hspeed < 0 and instance_place(x, y, obj_diagonal_up) = noone {
	hspeed = 0;
   foundwall = false;
   for(var ix = 0; !foundwall; ix++) {
      if place_meeting(x - ix, y, obj_block) {
			x = x - ix + 1;
			foundwall = true;
		}
   }
}

if rightwall and hspeed > 0 and instance_place(x, y, obj_diagonal_up) = noone {
   hspeed = 0;
   foundwall = false;
   for(var ix = 0; !foundwall; ix++) {
      if place_meeting(x + ix, y, obj_block) {
   		x = x + ix - 1;
   		foundwall = true;
   	}
   }
}


function handle_idle() {
   //DO IDLE STUFF
   handle_grounded();
}

function handle_wallGrabIdle() {
   //TODO: implement if needed
}

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

function handle_airborne() {
   jump_height_modifier = 1;
   if (rightwall or leftwall) and jumpIntent() {
   	vspeed = -20;
   	hspeed = rightwall ? -20 : 20;
   }
   handle_moving_air();
}

function handle_grounded() {
   if(jumpIntent() == 1) {
      vspeed = -3;
	   state = state_type.jumping;
   }
   
   handle_moving_ground();
}


function handle_jumping() {
   if jumpIntent() == 1 and jump_height_modifier < 30 {
   	vspeed = vspeed - (7 / jump_height_modifier);
   	++jump_height_modifier;
   } else {
      state = state_type.airborne;
   	jump_height_modifier = 1;
   }
   handle_moving_air();
}

function jumpIntent() {
   return keyboard_check(vk_space) ? 1 : 0;
}

function xIntent() {
   if(keyboard_check(vk_right)) return 1;
   if(keyboard_check(vk_left)) return -1;
   return 0;
}

switch(state) {
   case state_type.idle:
      handle_idle();
      break;
   case state_type.jumping:
      handle_jumping();
      break;
   case state_type.airborne:
      handle_airborne();
      break;
   case state_type.grounded:
      handle_grounded();
      break;
   case state_type.wallGrabIdle:
      handle_wallGrabIdle();
      break;
}

//taking out the buffer temporarily from the
//rightslope line in case we don't need it
var _slopeid = instance_place(x + hspeed, y, obj_diagonal_up)
if (hspeed >= 0) and _slopeid != noone and x + hspeed>_slopeid.bbox_left and vspeed >= 0 {

//find point of collission on triangle (_xcollission, _ycollission)
var _y=(
	((x + hspeed-_slopeid.bbox_left)/(_slopeid.bbox_right-_slopeid.bbox_left))
	*(_slopeid.bbox_top-_slopeid.bbox_bottom)+_slopeid.bbox_bottom
	);
y = _y-16;
gravity=0;
state = state_type.grounded;
}
//!!! ibums read this !!!
// make a new jump for when you have leftwall and rightwall
//that just jumps you straight up or maybe slides you up?
