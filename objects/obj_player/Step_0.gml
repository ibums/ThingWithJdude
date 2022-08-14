//vertical collission

airborne = !place_meeting(x, y + vspeed + 1, obj_block);

if !place_meeting(x, y + vspeed + 1, obj_block) {
   gravity = 1.25;
} else if vspeed > 0 {
	gravity = 0;
	vspeed = 0;
   var foundground = false;
	for(var iy = 0; !foundground; iy++) {
      if place_meeting(x, y + iy, obj_block) {
			y = y + iy - 1;
			foundground = true;
         state = state_type.grounded;
		}
   }
}

if place_meeting(x, y + vspeed + 1, obj_block) and vspeed < 0 {
	vspeed = 0;
	var iy = 0;
	var foundCeiling = false;
   for(var iy = 0; !foundCeiling; iy++) {
      if place_meeting(x, y - iy, obj_block) {
			y = y - iy + 1;
			foundCeiling = true;
         state = state_type.airborne;
		}
   }
}

leftwall = place_meeting(x - abs(hspeed) - 1, y, obj_block);
rightwall = place_meeting(x + abs(hspeed) + 1, y, obj_block);
var foundwall = false;

//horizontal collission
if leftwall and hspeed < 0 {
	hspeed = 0;
   foundwall = false;
   for(var ix = 0; !foundwall; ix++) {
      if place_meeting(x - ix, y, obj_block) {
			x = x - ix + 1;
			foundwall = true;
		}
   }
}

if rightwall and hspeed > 0 {
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
      print("GROUNDED => JUMPING");
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
      print("JUMP RELEASED");
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
