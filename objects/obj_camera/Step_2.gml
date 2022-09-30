if hspeed_frame_counter > hspeed_array_size-1 {hspeed_frame_counter = 0}
if vspeed_frame_counter > vspeed_array_size-1 {vspeed_frame_counter = 0}

if instance_exists(global.player_id){	
	hspeed_array[hspeed_frame_counter++] = global.player_id.hspeed;
	vspeed_array[vspeed_frame_counter++] = global.player_id.vspeed;
	
	player_position_x = global.player_id.x;
	player_position_y = global.player_id.y;
	//if player exists, update player position,
	//if player no longer exists keep using the last known position of the player
	//add global.player_id.hspeed to make the camera look further at higher speeds
	}
else{
	hspeed_array[hspeed_frame_counter++] = 0;
	vspeed_array[vspeed_frame_counter++] = 0;
}

average_hspeed = sum_array(hspeed_array, hspeed_array_size)/(hspeed_array_size);
average_vspeed = sum_array(vspeed_array, vspeed_array_size)/(vspeed_array_size);

player_position_x_prediction = player_position_x + 10*average_hspeed;
player_position_y_prediction = player_position_y + 5*average_vspeed;

left_push = camera_get_view_x(camera_id) + (camera_width-push_position_x);
//the point where the player pushes the camera left in left mode
right_push = camera_get_view_x(camera_id) + push_position_x;
//the point where the player pushes the camera right in right mode
left_switch = camera_get_view_x(camera_id) + switch_position_x;
//the point where the player changes the camera mode to left mode
right_switch = camera_get_view_x(camera_id) + (camera_width-switch_position_x);
//the point where the player changes the camera mode to right mode

up_push = camera_get_view_y(camera_id) + (camera_height-push_position_y);
//the point where the player pushes the camera up in up mode
down_push = camera_get_view_y(camera_id) + push_position_y;
//the point where the player pushes the camera down in down mode
up_switch = camera_get_view_y(camera_id) + switch_position_y;
//the point where the player changes the camera mode to up mode
down_switch = camera_get_view_y(camera_id) + (camera_height-switch_position_y);
//the point where the player changes the camera mode to down mode

state();
print(camera_get_view_border_x(camera_id), ", ", camera_get_view_border_y(camera_id));