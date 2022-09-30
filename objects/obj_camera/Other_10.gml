function initiate_camera(){

	if (x > global.player_id.x){
	
		camera_set_view_pos(camera_id,
		player_position_x - (push_position_x+switch_position_x)/2,
		camera_get_view_y(camera_id));
		state = camera_right_mode;
	}
	
	else{
	
		camera_set_view_pos(camera_id,
		player_position_x + (push_position_x+switch_position_x)/2,
		camera_get_view_y(camera_id));
		state = camera_left_mode;
	}
}

initiate_camera();

transition_frame = 0;