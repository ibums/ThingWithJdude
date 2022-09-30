/// @description Horizontal to Vertical Camera Transition

if camera_direction = horizontal{

initial_x = camera_get_view_x(camera_id);

camera_direction = vertical;

state = transition_camera_horizontal_to_vertical;

}