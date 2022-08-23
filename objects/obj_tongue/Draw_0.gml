if (owner_instance = noone) {
   instance_destroy(id);
   owner_instance = noone;
   return;
}

if (owner_instance != noone) {
   draw_line_width_colour(owner_instance.x, owner_instance.y, x, y, 4, c_red, c_fuchsia);
}