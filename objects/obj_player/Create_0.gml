event_inherited();
jump = false;
jump_height_modifier = 1;
_friction = 0.5;
_acceleration = 0.15;
airborne = false;
grapple_charge = 0;
//colision vars
check_for_walls();
horzBuffer = 1;

//various ability vars
maxGrappleLen = 30;
curGrappleLen = 0;
grappleSpeed = 15;
tongueInst = noone;
attackInst = noone;

facing = 1;
meleeOffsetX = sprite_width / 2+sprite_get_width(spr_melee_hitbox);
meleeOffsetY = sprite_height / 2;

aimX = 0;
aimY = 0;
grappleEndRadius = sprite_width;

state = pointer_null;