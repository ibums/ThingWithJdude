/// @description
event_inherited();
// Begin Step Event

// Keys we want to record
_input[eKey.LeftPressed]   = xIntent() == -1;
_input[eKey.RightPressed]  = xIntent() == 1;
_input[eKey.UpPressed]     = yIntent() == -1;
_input[eKey.DownPressed]   = yIntent() == 1;
_input[eKey.JumpPressed] = jumpIntent() == 1;
_input[eKey.JumpHold] = jumpIntent() == 2;
_input[eKey.GrapplePressed] =grappleIntent() == 1;
_input[eKey.DashPressed] = dashIntent() == 1;
_input[eKey.AttackPressed] = meleeIntent() == 1;

_input[eKey.LeftReleased]  = xIntentReleased() == -1;
_input[eKey.RightReleased] = xIntentReleased() == 1;
_input[eKey.UpReleased]    = yIntentReleased() == -1;
_input[eKey.DownReleased]  = yIntentReleased() == 1;
_input[eKey.JumpReleased]  = jumpIntentReleased() == 1;
_input[eKey.GrappleReleased]  = grappleIntentReleased() == 1;
_input[eKey.AttackReleased]  = meleeIntentReleased() == 1;

// Keys we don't want to record
_kRecord = keyboard_check_pressed(ord("Q"));
_kPlay   = keyboard_check_pressed(ord("P"));