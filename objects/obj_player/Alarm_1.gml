/// @description Wall Jump Time
if (rightwall xor leftwall) {
   	vspeed = -wallJumpSpeed;
   	hspeed = rightwall ? -wallJumpSpeed : wallJumpSpeed;
   } else if (rightwall and leftwall) {
      vspeed = -wallJumpSpeed + wallJumpSpeed / 2;
}
state = handle_airborne;
walljumping = false;
gravity = grav;