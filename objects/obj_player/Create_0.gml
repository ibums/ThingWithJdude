event_inherited();
jump = false;
jump_height_modifier = 1;
_friction = 0.5;
_acceleration = 0.75;
airborne = false;
grapple_charge = 0;
grav = .75
terminalVelocity = 10;
walljumping = false;

//colision vars
check_for_walls();
horzBuffer = 1;

//various ability vars
attackInst = noone;
maxMoveSpeed = 7;

//Grapple Vars
grappleBoostAcceleration = .5;
grappleDir = 0;
grappling = false;
maxGrappleLen = 500;
curGrappleLen = 0;
baseGrappleSpeed = 12;//these two need to be the same
grappleSpeed = 12;//these two need to be the same
tongueInst = noone;
grappleboosted = false;
grappleBoostTime = 15;
maxXAim = 0;
maxYAim = 0;
grappling = false;

//Jummp Vars
doubleJumpHeight = -3;
jumpCharges = 1;
maxJumpCharges = 1;
jumpHeight = -1;
jumpHeightModifierMax = 4;
doubleJumpHorizontalSpeed = 2;

//Wall jump vars
wallJumpSpeed = 13;
wallJumpTime = 4;

//Dash vars
maxDashCharges = 1;
dashCharges = 1;
dashTime = 7;
dashing = false;
dashSpeed = 15;

facing = 1;
meleeOffset = sprite_get_width(spr_melee_hitbox)*2;

aimX = 0;
aimY = 0;
grappleEndRadius = sprite_width;

state = pointer_null;