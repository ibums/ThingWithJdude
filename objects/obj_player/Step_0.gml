//vertical collission

if !place_meeting(x, y + 5, obj_block)
{
    gravity = 1.25;
}
else
{
    gravity = 0;
	vspeed  = 0;

}

if place_meeting(x, y, obj_block)
{
    y = y-1;
}

//horizontal collission
if place_meeting(x+1, y, obj_block)
{
	hspeed = 0;
}

if place_meeting(x-1, y, obj_block)
{
	hspeed = 0;
}

//jump
if place_meeting(x, y + 10, obj_block)
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

if jump = true{
	if keyboard_check(vk_space){
		if i<30{
			vspeed = vspeed-7/i;
			++i;
		}
	}
}

//movement left / right

if keyboard_check(vk_left){
	if hspeed > -10{ 
		hspeed = hspeed-0.25;
		}
}

if !keyboard_check(vk_left){
	if hspeed < 0{ 
		hspeed = hspeed+0.3;
		}
}

if keyboard_check(vk_right){
	if hspeed < 10{ 
		hspeed = hspeed+0.25;
		}
}

if !keyboard_check(vk_right){
	if hspeed > 0{ 
		hspeed = hspeed-0.3;
		}
}
 