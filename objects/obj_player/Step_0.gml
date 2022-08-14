//vertical collission

if !place_meeting(x, y+vspeed+1, obj_block)
{
    gravity = 1.25;
}
else
{
	if vspeed>0 {
		gravity = 0;
		vspeed  = 0;
	
		var iy = 0;
		var foundground = false;
		while foundground = false{
			++iy;
			if (place_meeting(x, y+iy, obj_block) = true){
				y = y+iy-1;
				foundground = true;
			}
		}
	}
}

if place_meeting(x, y+vspeed-1, obj_block)
{
	if vspeed<0{
		vspeed  = 0;
		var iy = 0;
		var foundground = false;
		while foundground = false{
			++iy;
			if (place_meeting(x, y-iy, obj_block) = true){
				y = y-iy+1;
				foundground = true;
				jump = false;
				}
		}
	}
}

//horizontal collission
if place_meeting(x+hspeed-6, y, obj_block)
{
	if hspeed<0{
		leftwall = true;
		hspeed = 0;
		var ix = 0;
		var foundwall = false;
		while foundwall = false{
			++ix;
			if (place_meeting(x-ix, y, obj_block) = true){
				x = x-ix+5;
				foundwall = true;
				}
		}
	}
}
else leftwall = false;

if place_meeting(x+hspeed+6, y, obj_block)
{
	if hspeed>0{
		rightwall = true;
		hspeed = 0;
		var ix = 0;
		var foundwall = false;
		while foundwall = false{
			++ix;
			if (place_meeting(x+ix, y, obj_block) = true){
				x = x+ix-5;
				foundwall = true;
				}
		}
	}
}
else rightwall = false;

//jump
if place_meeting(x, y+1, obj_block)
{
	if keyboard_check_pressed(vk_space){

		vspeed = -3;
		jump = true;
	}
}

if keyboard_check_released(vk_space){
	jump = false;
	i = 1;
}

if jump == true{
	if keyboard_check(vk_space){
		if i<30{
			vspeed = vspeed-7/i;
			++i;
		}
	}
}

//movement left / right

if keyboard_check(vk_left) and leftwall = false{
	if hspeed > -10{ 
		hspeed = hspeed-_acceleration;
		}
}

if keyboard_check(vk_right) and rightwall = false{
	if hspeed < 10{ 
		hspeed = hspeed+_acceleration;
		}
}

if !keyboard_check(vk_left) and !keyboard_check(vk_right){
	if hspeed > 0{
		hspeed = hspeed-_friction;
		hspeed = hspeed-_friction<0 ? 0 : hspeed-_friction;
	}
	if hspeed < 0{
		hspeed = hspeed+_friction;
		hspeed = hspeed+_friction>0 ? 0 : hspeed+_friction;
	}
}