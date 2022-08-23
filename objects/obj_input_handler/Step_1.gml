/// @description
//https://developer.amazon.com/blogs/appstore/post/3bb65890-7230-431f-836e-35455ae996bf/easy-input-replay-system-in-gamemaker-studio-2
event_inherited();
var recorder = instance_find(obj_input_recorder, 0);
if (recorder != noone and !recorder._isPlaying)
{
   _kLeft = xIntent() == -1;
   _kRight = xIntent() == 1;
   _kUp = yIntent() == -1;
   _kDown = yIntent() == 1;
   _kJump = jumpIntent() == 1;
   _kJumpHold = jumpIntent() == 2;
   _kGrapple = grappleIntent() == 1;
   _kDash = dashIntent() == 1;
   _kAttack = meleeIntent() == 1;
}