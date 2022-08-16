event_inherited();
jump = false;
jump_height_modifier = 1;
_friction = 0.5;
_acceleration = 0.15;
airborne = false;

//colision vars
check_for_walls();
horzBuffer = 1;

//various ability vars
maxGrappleLen = 30;
curGrappleLen = 0;
tongueInst = noone;

aimX = 0;
aimY = 0;
grappleEndRadius = 16;

state = pointer_null;