function jumpIntent() {
   if (keyboard_check_pressed(vk_space)) {
      return 1;
   }
   else if (keyboard_check(vk_space)) {
      return 2;
   }
   else return 0;
}

function xIntent() {
   if(keyboard_check(vk_right) or keyboard_check(ord("D"))) return 1;
   if(keyboard_check(vk_left) or keyboard_check(ord("A"))) return -1;
   return 0;
}

function grappleIntent() {
   if(mouse_check_button_pressed(mb_left)) return 1;
   else return 0;
}

function meleeIntent() {
   if(mouse_check_button_pressed(mb_right)) return 1;
   else return 0;
}