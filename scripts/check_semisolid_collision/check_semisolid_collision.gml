function check_semisolid_collision(){

   if vspeed >= 0 and !handler._kDown{
   
      var bbox_height = bbox_bottom - bbox_top;
      
      var line_left = collision_line_point(bbox_left, bbox_bottom-0.25,
      bbox_left + hspeed, bbox_bottom-0.25 + vspeed, obj_semisolid, true, true);
   
      var line_right = collision_line_point(bbox_right-1, bbox_bottom-0.25,
      bbox_right-1 + hspeed, bbox_bottom-0.25 + vspeed, obj_semisolid, true, true);

      if (line_left[0] != noone or line_right[0] != noone) {
         gravity = 0;
         y = round(min(line_left[2], line_right[2]))-bbox_height/2;
         vspeed = 0;
         state = handle_grounded;
         return;
      }
   
   }
}