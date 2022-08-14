jump = false;
jump_height_modifier = 1;
_friction = 0.5;
_acceleration = 1.5;
airborne = false;

//colision vars
leftwall = false;
rightwall = false;
horzBuffer = 1;

enum state_type {
   idle,
   grounded,
   jumping,
   moving,
   airborne,
   dead,
   wallGrabIdle
};

state = state_type.idle;