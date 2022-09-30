global.camera_object_id = id;

camera_id = view_camera[0];

camera_width = camera_get_view_width(camera_id);
camera_height = camera_get_view_height(camera_id);

player_position_x = 0;
player_position_y = 0;

initial_x = 0;
target_x = 0;
initial_y = 0;
target_y = 0;

horizontal = 0;
vertical = 1;

push_position_x = (camera_width*(35/100));
//the portion of the screen width from the edge where left_push and right_push are
switch_position_x = (camera_width*(10/100));
//the portion of the screen width from the edge where left_switch and right_switch are
push_position_y = (camera_height*(40/100));
//the portion of the screen height from the edge where up_push and down_push are
switch_position_y = (camera_height*(15/100));
//the portion of the screen height from the edge where up_switch and down_switch are

transition_time = 60;
//the number of frames it takes to switch between left/right or up/down camera modes
transition_frame = 0;

hspeed_array_size = 29;
vspeed_array_size = 14;

var incremented_value = hspeed_array_size;

while (incremented_value>=0){
	hspeed_array[incremented_value--] = 0;
}
//initialize the hspeed_array

var incremented_value = vspeed_array_size;

while (incremented_value>=0){
	vspeed_array[incremented_value--] = 0;
}
//initialize the vspeed_array

average_hspeed = 0;
average_vspeed = 0;

hspeed_frame_counter = 0;
vspeed_frame_counter = 0;

player_position_x_prediction = 0;
player_position_y_prediction = 0;

//camera states
camera_right_mode = function(){
	
	camera_direction = horizontal;
	
	if (player_position_x_prediction > right_push){
		camera_set_view_pos(camera_id, player_position_x_prediction - push_position_x,
		camera_get_view_y(camera_id));
		}

	else if (player_position_x_prediction < left_switch) {
		camera_set_view_pos(camera_id, player_position_x_prediction - switch_position_x,
		camera_get_view_y(camera_id));
	
		transition_frame = 0;
	
		state = transition_camera_left_mode;
	}
}

camera_left_mode = function(){
	
	camera_direction = horizontal;

	if (player_position_x_prediction < left_push){
		camera_set_view_pos(camera_id, player_position_x_prediction - (camera_width-push_position_x),
		camera_get_view_y(camera_id));
		}

	else if (player_position_x_prediction > right_switch) {
		camera_set_view_pos(camera_id, player_position_x_prediction - (camera_width-switch_position_x),
		camera_get_view_y(camera_id));
	
		transition_frame = 0;
	
		state = transition_camera_right_mode;
	}
}

transition_camera_left_mode = function(){
		
	camera_direction = horizontal;

	++transition_frame;

	camera_set_view_pos(camera_id,
	player_position_x_prediction - smootherstep(switch_position_x, camera_width - push_position_x, (transition_frame/transition_time)),
	camera_get_view_y(camera_id));

	if (transition_frame >= transition_time){

		transition_frame = 0;
		state = camera_left_mode;
	}
}

transition_camera_right_mode = function(){
		
	camera_direction = horizontal;

	++transition_frame;

	camera_set_view_pos(camera_id,
	player_position_x_prediction - smootherstep(camera_width - switch_position_x, push_position_x, (transition_frame/transition_time)),
	camera_get_view_y(camera_id));

	if (transition_frame >= transition_time){

		transition_frame = 0;
		state = camera_right_mode;
	}
}

camera_down_mode = function(){
	
	camera_direction = vertical;

	if (player_position_y_prediction > down_push){
		camera_set_view_pos(camera_id, camera_get_view_x(camera_id),
		player_position_y_prediction - push_position_y
		);
		}

	else if (player_position_y_prediction < up_switch) {
		camera_set_view_pos(camera_id, camera_get_view_x(camera_id),
		player_position_y_prediction - switch_position_y,);
	
		transition_frame = 0;
	
		state = transition_camera_up_mode;
	}
}

camera_up_mode = function(){
	
	camera_direction = vertical;

	if (player_position_y_prediction < up_push){
		camera_set_view_pos(camera_id, camera_get_view_x(camera_id),
		player_position_y_prediction - (camera_height-push_position_y));
		}

	else if (player_position_y_prediction > down_switch) {
		camera_set_view_pos(camera_id, camera_get_view_x(camera_id),
		player_position_y_prediction - (camera_height-switch_position_y));
	
		transition_frame = 0;
	
		state = transition_camera_down_mode;
	}
}

transition_camera_up_mode = function(){
	
	camera_direction = vertical;

	++transition_frame;

	camera_set_view_pos(camera_id, camera_get_view_x(camera_id),
	player_position_y_prediction - smootherstep(switch_position_y, camera_height - push_position_y, (transition_frame/transition_time)));

	if (transition_frame >= transition_time){

		transition_frame = 0;
		state = camera_up_mode;
	}
}

transition_camera_down_mode = function(){
	
	camera_direction = vertical;

	++transition_frame;

	camera_set_view_pos(camera_id, camera_get_view_x(camera_id),
	player_position_y_prediction - smootherstep(camera_height - switch_position_y, push_position_y, (transition_frame/transition_time)));

	if (transition_frame >= transition_time){

		transition_frame = 0;
		state = camera_down_mode;
	}
}

//Horizontal / Vertical transition states

transition_camera_horizontal_to_vertical = function(){
	
	camera_direction = vertical;

	++transition_frame;

	camera_set_view_pos(camera_id,
	smootherstep(initial_x,target_x, (transition_frame/transition_time)),
	camera_get_view_y(camera_id));
	
	if (transition_frame >= transition_time){

		if (global.player_id.y > camera_get_view_y(camera_id) + camera_height/2){
		
			state = camera_up_mode;
		}
		else{
			
			state = camera_down_mode;
		}

		transition_frame = 0;
	}
}

transition_camera_vertical_to_horizontal = function(){
	
	camera_direction = horizontal;

	++transition_frame;

	camera_set_view_pos(camera_id, camera_get_view_x(camera_id),
	smootherstep(initial_y,target_y, (transition_frame/transition_time)));
	
	if (transition_frame >= transition_time){

		if (global.player_id.x > camera_get_view_x(camera_id) + camera_width/2){
		
			state = camera_left_mode;
		}
		else{
			
			state = camera_right_mode;
		}

		transition_frame = 0;
	}
}

state = 0;