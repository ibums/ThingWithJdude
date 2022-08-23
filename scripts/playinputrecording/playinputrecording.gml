// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
//https://developer.amazon.com/blogs/appstore/post/3bb65890-7230-431f-836e-35455ae996bf/easy-input-replay-system-in-gamemaker-studio-2
function PlayInputRecording() {
// PlayInputRecording Script
   var inputHandler = instance_find(obj_input_handler, 0);

   if (inputHandler != noone) {
       inputHandler._kDash = false;
       inputHandler._kAttack = false;
       inputHandler._kGrapple = false;
       inputHandler._kJump = false;
       while (_index < array_height_2d(_inputSequence) and _inputSequence[_index, 0] == _frame) {
           switch (_inputSequence[_index, 1]) {
               case eKey.LeftPressed:     inputHandler._kLeft     = true; break;
               case eKey.RightPressed:    inputHandler._kRight    = true; break;
               case eKey.UpPressed:       inputHandler._kUp       = true; break;
               case eKey.DownPressed:     inputHandler._kDown     = true; break;
               case eKey.JumpPressed:     inputHandler._kJump     = true; break;
               case eKey.JumpHold:        inputHandler._kJumpHold = true; break;
               case eKey.GrapplePressed:  inputHandler._kGrapple  = true; break;
               case eKey.DashPressed:     inputHandler._kDash     = true; break;
               case eKey.AttackPressed:   inputHandler._kAttack   = true; break;
                                          
               case eKey.LeftReleased:    inputHandler._kLeft    = false; break;
               case eKey.RightReleased:   inputHandler._kRight   = false; break;
               case eKey.UpReleased:      inputHandler._kUp      = false; break;
               case eKey.DownReleased:    inputHandler._kDown    = false; break;
               case eKey.JumpReleased:    inputHandler._kJump    = false; inputHandler._kJumpHold = false; break;
               case eKey.GrappleReleased: inputHandler._kGrapple = false; break;
               case eKey.DashReleased:    inputHandler._kDash    = false; break;
               case eKey.AttackReleased:  inputHandler._kAttack  = false; break;
           }
           ++_index;
       }
       ++_frame;
   }
}