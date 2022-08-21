/// @description Dash Alarm
state = is_grounded() ? handle_grounded : handle_airborne;
dashing = false;