
function check_collision() { 
   
   function check_downward_slope() {
         
         var bbox_height = bbox_bottom - bbox_top;
            
         var stickyness = 31;
         //this controls how fast we can go before flying off a slope, keep this number below 32 - ibums
            
         var line_slope_check_left = collision_line_point(bbox_left + hspeed, y,
         bbox_left + hspeed, bbox_bottom + stickyness, obj_standable, true, true)
         
         var line_slope_check_right = collision_line_point(bbox_right-1 + hspeed, y,
         bbox_right-1 + hspeed, bbox_bottom + stickyness, obj_standable, true, true)
            
         if hspeed > 0 and line_slope_check_right[2] > line_slope_check_left[2] {
            
            y = round(line_slope_check_left[2] - bbox_height/2);
         }
         
         if hspeed < 0 and line_slope_check_left[2] > line_slope_check_right[2] {
            
            y = round(line_slope_check_right[2] - bbox_height/2);
            //these need to be round or floor or else when half on a block 
            //your y will be a weird decimal - ibums
      }
   }
   
   function check_collision_vertical() {
   
      var bbox_height = bbox_bottom - bbox_top;
      
      var bbox_y = 0;
      
      if (vspeed > 0) {
         bbox_y = bbox_bottom-0.25;
      } else {
         bbox_y = bbox_top;
      }
   
      var line_left = collision_line_point(bbox_left, bbox_y, bbox_left, bbox_y + vspeed,
      obj_collision, true, true);
   
      var line_right = collision_line_point(bbox_right-1, bbox_y, bbox_right-1, bbox_y + vspeed,
      obj_collision, true, true);

      if (line_left[0] != noone or line_right[0] != noone) {
         if (vspeed > 0) {
            gravity = 0;
            y = round(min(line_left[2], line_right[2]))-bbox_height/2;
            state = handle_grounded;
         } else {
            y = round(max(line_left[2], line_right[2]))+bbox_height/2;
         }

         vspeed = 0;
         return;
      }
   }

   function reduce_precision(num) {
      return floor(num * 10) / 10;
   }

   function check_collision_horizontal() {
   
      var bbox_width = bbox_right - bbox_left;
      var bbox_height = bbox_bottom - bbox_top;
   
      if hspeed > 0 var bbox_x = bbox_right-1;
      else var bbox_x = bbox_left;
   
      var line_top = collision_line_point(bbox_x, bbox_top, bbox_x + hspeed, bbox_top,
      obj_collision, true, true);
   
      var line_bottom = collision_line_point(x, bbox_bottom - 0.25, bbox_x + hspeed, bbox_bottom - 0.25,
      obj_collision, true, true);
   
      var line_bottom2 = collision_line_point(x, bbox_bottom - 1, bbox_x + hspeed, bbox_bottom - 1,
      obj_collision, true, true);
      
      if line_top[0] = noone and (line_bottom[0] = noone and line_bottom2[0] = noone) {
      
         check_downward_slope();
         return;
      }
   
      else {
      
         var lin = line_bottom[0] != noone  ? line_bottom : line_bottom2;
         if (lin[0] != noone and lin[0].is_floor(lin[1], lin[2])) {
                  var anglecos = reduce_precision(cos(pi/4));
                  var anglesin = reduce_precision(sin(pi/4));
                  
                  x = x + hspeed * anglecos - hspeed;
                  
                  var line_final_position = collision_line_point(bbox_x + hspeed * anglecos, bbox_top - abs(hspeed) * anglesin,
                  bbox_x + hspeed * anglecos, bbox_bottom - abs(hspeed) * anglesin, obj_collision, true, true); 

                  y = floor(line_final_position[2]-bbox_height/2);
                  //y = y - abs(hspeed) * anglesin;
                  return;
            }
            
         if(hspeed > 0) {x = round(min(line_top[1], line_bottom[1]))-bbox_width/2}
         
         else if (hspeed < 0) {x = round(max(line_top[1], line_bottom[1]))+bbox_width/2}
         
         hspeed = 0;
         return;
      }
   }
   
   //if not moving
   if (hspeed == 0 and vspeed == 0) {
     return;
   }

   //moving straight up or down
   if (hspeed == 0) {
      check_collision_vertical()
      return;
   }
   

   //moving straight left or right
   if (vspeed == 0) {
      check_collision_horizontal()
      return;
   }


   var line_top_left, line_top_right, line_bottom_left, line_bottom_right;

   if (hspeed < 0 or vspeed < 0) {
      line_top_left = collision_line_point(bbox_left, bbox_top, bbox_left + hspeed, bbox_top + vspeed,
      obj_collision, true, true);  
   }

   if (hspeed > 0 or vspeed < 0) {
      line_top_right = collision_line_point(bbox_right-1, bbox_top, bbox_right-1 + hspeed, bbox_top + vspeed,
      obj_collision, true, true);
   }

   if (hspeed < 0 or vspeed > 0) {
      line_bottom_left = collision_line_point(bbox_left, bbox_bottom-1, bbox_left + hspeed, bbox_bottom-1 + vspeed,
      obj_collision, true, true);
   }

   if (hspeed > 0 or vspeed > 0) {  
      line_bottom_right = collision_line_point(bbox_right-1, bbox_bottom-1, bbox_right-1 + hspeed, bbox_bottom-1 + vspeed,
      obj_collision, true, true);
   }

   function check_collision_diagonal(main_line, other_line_x, other_line_y) {
   
   var bbox_height = bbox_bottom - bbox_top;
   var bbox_width = bbox_right - bbox_left;

      if (main_line[0] = noone and other_line_x[0] = noone and other_line_y[0] = noone) {
         return;
      }
   
      if (main_line[0] != noone and other_line_x[0] != noone){
         if (vspeed < 0) {
            y = max(ceil(main_line[2]), ceil(other_line_x[2]))-sign(vspeed)*bbox_height/2;
         } else {
            y = min(floor(main_line[2]), floor(other_line_x[2]))-sign(vspeed)*bbox_height/2;
            gravity = 0;
            state = handle_grounded;
         }
         vspeed = 0;
         check_collision_horizontal();
         return;
      }


      if (main_line[0] != noone and other_line_y[0] != noone) {
         if (hspeed < 0) {
            x = max(ceil(main_line[1]), ceil(other_line_y[1]))-sign(hspeed)*bbox_width/2;
         } else {
            x = min(floor(main_line[1]), floor(other_line_y[1]))-sign(hspeed)*bbox_width/2;
         }
         hspeed = 0;
         check_collision_vertical();
         return;
     }
  
      if (main_line[0] = noone and other_line_x[0] = noone and other_line_y[0] != noone) {
         if (other_line_y[0].is_wall(other_line_y[1], other_line_y[2])) {
            if (hspeed > 0){
            x = ceil(other_line_y[1])-sign(hspeed)*bbox_width/2;
            } else {
               x = floor(other_line_y[1])-sign(hspeed)*bbox_width/2;
            }
            hspeed = 0;
            check_collision_vertical();
            return;
         }
         
         else if ((other_line_y[0].is_floor(other_line_y[1], other_line_y[2]) or
         (other_line_y[0].is_ceiling(other_line_y[1], other_line_y[2]))) and vspeed > 0) {
            if (hspeed > 0){
               x = other_line_y[0].bbox_left-sign(hspeed)*bbox_width/2;
            } else if (hspeed < 0) {
               x = other_line_y[0].bbox_right-sign(hspeed)*bbox_width/2;
            }
            hspeed = 0;
            print("rare corner case, hopefully nothing breaks when this prints");
            check_collision_vertical();
            return;
         }
      }
   
      if (main_line[0] = noone and other_line_x[0] != noone and other_line_y[0] = noone) {
         if (other_line_x[0].is_floor(other_line_x[1], other_line_x[2]) and vspeed > 0) {
            y = round(other_line_x[2])-sign(vspeed)*bbox_height/2;
            vspeed = 0;
            gravity = 0;
            state = handle_grounded;
            check_collision_horizontal();
            return;
         }
      
         if (other_line_x[0].is_ceiling(other_line_x[1], other_line_x[2]) and vspeed < 0) {
         
            y = round(other_line_x[2])-sign(vspeed)*bbox_height/2;
            vspeed = 0;
            check_collision_horizontal();
            return;
         }
         
         if (other_line_x[0].is_wall(other_line_x[1], other_line_x[2])) {
            if (vspeed > 0) {
               y = other_line_x[0].bbox_top-sign(vspeed)*bbox_height/2;
               vspeed = 0;
               gravity = 0;
               state = handle_grounded;
               print("rare corner case, hopefully nothing breaks when this prints");
               check_collision_horizontal();
               return;
            } else if (vspeed < 0) {
               y = other_line_x[0].bbox_bottom-sign(vspeed)*bbox_height/2;
               vspeed = 0;
               print("rare corner case, hopefully nothing breaks when this prints");
               check_collision_horizontal();
               return;
            }
         }     
      }

      if (main_line[0] != noone and other_line_x[0] = noone and other_line_y[0] = noone) {
         if (main_line[0].is_floor(main_line[1], main_line[2]) and vspeed > 0) {
            y = round(main_line[2])-sign(vspeed)*bbox_height/2;
            vspeed = 0;
            gravity = 0;
            state = handle_grounded;
            check_collision_horizontal();     
            return;
         }
      
         if (main_line[0].is_ceiling(main_line[1], main_line[2]) and vspeed < 0) {
            y = round(main_line[2])-sign(vspeed)*bbox_height/2;
            vspeed = 0;
            check_collision_horizontal(); 
            return;
         }
      
         if main_line[0].is_wall(main_line[1], main_line[2]) {
            if (hspeed > 0) {
               x = main_line[0].bbox_left-sign(hspeed)*bbox_width/2;
               hspeed = 0;
               check_collision_vertical();
               return;
            } else if (hspeed < 0) {
               x = main_line[0].bbox_right-sign(hspeed)*bbox_width/2;
               hspeed = 0;
               check_collision_vertical();       
               return;
            }
         }
      }
   }

   if (hspeed < 0 and vspeed < 0) {
      check_collision_diagonal(line_top_left, line_top_right, line_bottom_left);
   }

   if (hspeed > 0 and vspeed < 0) {
      check_collision_diagonal(line_top_right, line_top_left, line_bottom_right);
   }

   if (hspeed < 0 and vspeed > 0) {
      check_collision_diagonal(line_bottom_left, line_bottom_right, line_top_left);
   }
   
   if (hspeed > 0 and vspeed > 0) {
      check_collision_diagonal(line_bottom_right, line_bottom_left, line_top_right);
   }
}