/// @description Vertical to Horizontal Camera Transition

if camera_direction = vertical{

initial_y = camera_get_view_y(camera_id);

camera_direction = horizontal;

state = transition_camera_vertical_to_horizontal;

}