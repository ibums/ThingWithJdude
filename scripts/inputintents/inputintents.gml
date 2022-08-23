

function jumpIntent() {
   if (keyboard_check_pressed(vk_space) or keyboard_check_pressed(vk_numpad0)) {
      return 1;
   }
   else if (keyboard_check(vk_space) or keyboard_check(vk_numpad0)) {
      return 2;
   }
   else return 0;
}

function jumpIntentReleased() {
   if (keyboard_check_released(vk_space) or keyboard_check_released(vk_numpad0)) {
      return 1;
   }
   else return 0;
}

function xIntent() {
   if(keyboard_check(vk_right) or keyboard_check(ord("D"))) return 1;
   if(keyboard_check(vk_left) or keyboard_check(ord("A"))) return -1;
   return 0;
}

function xIntentReleased() {
   if(keyboard_check_released(vk_right) or keyboard_check_released(ord("D"))) return 1;
   if(keyboard_check_released(vk_left) or keyboard_check_released(ord("A"))) return -1;
   return 0;
}

function yIntent() {
   if(keyboard_check(vk_up)) return -1;
   if(keyboard_check(vk_down) or keyboard_check(ord("S"))) return 1;
   return 0;
}

function yIntentReleased() {
   if(keyboard_check_released(vk_up)) return -1;
   if(keyboard_check_released(vk_down) or keyboard_check_released(ord("S"))) return 1;
   return 0;
}

function grappleIntent() {
   if(mouse_check_button_pressed(mb_left) or keyboard_check_pressed(vk_numpad5)) return 1;
   else return 0;
}

function grappleIntentReleased() {
   if(mouse_check_button_released(mb_left) or keyboard_check_released(vk_numpad5)) return 1;
   else return 0;
}

function meleeIntent() {
   if(mouse_check_button_pressed(mb_right) or keyboard_check_pressed(vk_numpad5)) return 1;
   else return 0;
}

function meleeIntentReleased() {
   if(mouse_check_button_released(mb_right) or keyboard_check_released(vk_numpad5)) return 1;
   else return 0;
}

function dashIntent() {
   if(keyboard_check_pressed(vk_shift) or keyboard_check_pressed(vk_numpad4)) return 1;
   else return 0;
}

function dashIntentReleased() {
   if(keyboard_check_released(vk_shift) or keyboard_check_released(vk_numpad4)) return 1;
   else return 0;
}

function debugIntent() {
    if(keyboard_check_pressed(vk_numpad7)) return 1;
   else return 0;
}
