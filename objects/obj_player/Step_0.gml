//vertical collission
var foundground = false;
airborne = !place_meeting(x, y + vspeed + 1, obj_block);

if !place_meeting(x, y + vspeed + 1, obj_block) {
   gravity = 1.25;
} else if vspeed > 0 {
	gravity = 0;
	vspeed = 0;
   foundground = false;
	for(var iy = 0; !foundground; iy++) {
      if place_meeting(x, y + iy, obj_block) {
			y = y + iy - 1;
			foundground = true;
		}
   }
}

if place_meeting(x, y + vspeed - 1, obj_block) and vspeed < 0 {
	vspeed = 0;
	var iy = 0;
	foundground = false;
   for(var iy = 0; !foundground; iy++) {
      if place_meeting(x, y-iy, obj_block) {
			y = y - iy + 1;
			foundground = true;
			jump = false;
		}
   }
}

leftwall = place_meeting(x + hspeed - 6, y, obj_block);
rightwall = place_meeting(x + hspeed + 6, y, obj_block);
var foundwall = false;

//horizontal collission
if leftwall and hspeed < 0 {
	hspeed = 0;
   foundwall = false;
   for(var ix = 0; !foundwall; ix++) {
      if place_meeting(x - ix, y, obj_block) {
			x = x - ix + 5;
			foundwall = true;
		}
   }
}

if rightwall and hspeed > 0 {
   hspeed = 0;
   foundwall = false;
   for(var ix = 0; !foundwall; ix++) {
      if place_meeting(x + ix, y, obj_block) {
   		x = x + ix - 5;
   		foundwall = true;
   	}
   }
}

//jump
if !airborne and keyboard_check_pressed(vk_space) {
	vspeed = -3;
	jump = true;
}

if airborne and leftwall and keyboard_check_pressed(vk_space) {
	vspeed = -20;
	hspeed = 20;
}

if airborne and rightwall and keyboard_check_pressed(vk_space) {
	vspeed = -20;
	hspeed = -20;
}

if keyboard_check_released(vk_space) {
	jump = false;
	jump_height_modifier = 1;
}

if jump and keyboard_check(vk_space) and jump_height_modifier < 30 {
	vspeed = vspeed - (7 / jump_height_modifier);
	++jump_height_modifier;
}

//movement left / right
// extra speed when moving in the opposite direction to speed?
if keyboard_check(vk_left) and !leftwall and hspeed > -10{
	hspeed = hspeed-_acceleration;
}

if keyboard_check(vk_right) and !rightwall and hspeed < 10{
   hspeed = hspeed+_acceleration;
}

if !keyboard_check(vk_left) and !keyboard_check(vk_right){
	if hspeed > 0 {
		hspeed = hspeed - _friction;
		hspeed = hspeed - _friction < 0 ? 0 : hspeed - _friction;
	}
	if hspeed < 0 {
		hspeed = hspeed + _friction;
		hspeed = hspeed + _friction > 0 ? 0 : hspeed + _friction;
	}
}