function check_downward_slope() {
   var bbox_height = bbox_bottom - bbox_top;
            
   var stickyness = 31;
   //this controls how fast we can go before flying off a slope, keep this number below 32 - ibums
   var bbox_dir_side = hspeed > 0 ? bbox_left : bbox_right;
   
   var line_cur_pos = collision_line_point(bbox_dir_side, y,
   bbox_dir_side, bbox_bottom + stickyness, obj_standable, true, true);
         
   var line_next_pos = collision_line_point(bbox_dir_side + hspeed, y,
   bbox_dir_side + hspeed, bbox_bottom + stickyness, obj_standable, true, true);
   
   //Need to round due to float imprecision
   var next_pos_line_len = round(line_next_pos[2] - y);
   
   //Check if our next position is lower than our current position AND 
   //the next position has ground < stickyness distance away
   if (line_cur_pos[2] < line_next_pos[2] && next_pos_line_len < stickyness + 1) {
      y = round(line_next_pos[2] - bbox_height/2);
      //these need to be round or floor or else when half on a block 
      //your y will be a weird decimal - ibums
   }
}
   
function check_collision_vertical() { 
   var bbox_height = bbox_bottom - bbox_top;
   var bbox_y = vspeed > 0 ? (bbox_bottom - 0.25) : bbox_top;
   
   var line_left = collision_line_point(bbox_left, bbox_y, bbox_left, bbox_y + vspeed,
   obj_collision, true, true);
   
   var line_right = collision_line_point(bbox_right - 1, bbox_y, bbox_right - 1, bbox_y + vspeed,
   obj_collision, true, true);

   if (line_left[0] != noone or line_right[0] != noone) {
      if (vspeed > 0) {
         y = round(min(line_left[2], line_right[2])) - bbox_height/2;
      } else {
         y = round(max(line_left[2], line_right[2])) + bbox_height/2;
      }
      update_v_speed_and_gravity();
      return;
   }
}

function reduce_precision(num) {
   return floor(num * 10) / 10;
}

function check_is_floor(lin) {
   return lin[0].is_floor(lin[1], lin[2]);
}

function check_is_wall(lin) {
   return lin[0].is_wall(lin[1], lin[2]);
}

function check_is_ceiling(lin) {
   return lin[0].is_ceiling(lin[1], lin[2]);
}

function check_collision_horizontal() {
   var bbox_width = bbox_right - bbox_left;
   var bbox_height = bbox_bottom - bbox_top;
   var bbox_x = hspeed > 0 ? bbox_right - 1 : bbox_left;
   
   var line_top = collision_line_point(bbox_x, bbox_top, bbox_x + hspeed, bbox_top,
   obj_collision, true, true);
   
   var line_bottom = collision_line_point(x, bbox_bottom - 0.25, bbox_x + hspeed, bbox_bottom - 0.25,
   obj_collision, true, true);
   
   var line_bottom2 = collision_line_point(x, bbox_bottom - 1, bbox_x + hspeed, bbox_bottom - 1,
   obj_collision, true, true);
      
   if (line_top[0] == noone and (line_bottom[0] == noone and line_bottom2[0] == noone)) {
      check_downward_slope();
      return;
   } else {
      var lin = line_bottom[0] != noone ? line_bottom : line_bottom2;
      if (lin[0] != noone and lin[0].is_floor(lin[1], lin[2])) {
         var anglecos = reduce_precision(cos(pi/4));
         var anglesin = reduce_precision(sin(pi/4));
         x += (hspeed * anglecos - hspeed);

         var line_final_position = collision_line_point(bbox_x + hspeed * anglecos, bbox_top - abs(hspeed) * anglesin,
         bbox_x + hspeed * anglecos, bbox_bottom - abs(hspeed) * anglesin, obj_collision, true, true); 

         y = floor(line_final_position[2]-bbox_height/2);
         return;
      }

      if (hspeed > 0) {
        x = round(min(line_top[1], line_bottom[1])) - bbox_width/2;
      } else if (hspeed < 0) {
        x = round(max(line_top[1], line_bottom[1])) + bbox_width/2;
      }
      hspeed = 0;
   }
}

function update_player_parameters_horizontal() {
   update_v_speed_and_gravity();
   check_collision_horizontal();
}

function update_v_speed_and_gravity() {
   if(vspeed > 0) {
      gravity = 0;
      state = handle_grounded;
   }
   vspeed = 0;
}

function snap_to_horizontal_surface_special(line_in, bbox_height) {
   //Verify raycast hits something
   if(line_in[0] == noone) {
      print("ERROR horizontal snap special failed line_in: ", line_in[0]);
      return;
   }
   
   //Snap to surface
   var bbox_offset = sign(vspeed)*bbox_height/2;
   
   if (vspeed > 0) {
      y = line_in[0].bbox_top - bbox_offset;
   } else if (vspeed < 0) {
      y = line_in[0].bbox_bottom - bbox_offset;
   }
   
   //update player parameters to relfect horizontal collision
   update_player_parameters_horizontal();
}

function snap_to_horizontal_surface(line_in1, line_in2, bbox_height) {
   //Verify at least one raycast hits a surface
   if(line_in1[0] == noone and line_in2[0] == noone) {
      print("ERROR horizontal snap failed line_in1: ", line_in1[0]," line_in2: ", line_in2[0]);
      return;
   }
   
   //Snap to surface
   var bbox_offset = sign(vspeed)*bbox_height/2;

   //Use line that is not noone
   var used_line = line_in1[0] == noone ? line_in2 : line_in1;
   if (line_in1[0] == noone or line_in2[0] == noone) {
      if (vspeed < 0) {
         y = ceil(used_line[2]) - bbox_offset;
      } else {
         y = floor(used_line[2]) - bbox_offset;
      }
   } else {
      if (vspeed < 0) {
        y = max(ceil(line_in1[2]), ceil(line_in2[2])) - bbox_offset;
      } else {
        y = min(floor(line_in1[2]), floor(line_in2[2])) - bbox_offset;
      }
   }
   
   //update player parameters to relfect horizontal collision
   update_player_parameters_horizontal();
}

function snap_to_vertical_surface(line_in1, line_in2, bbox_width) {
 //Verify at least one raycast hits a surface
   if (line_in1[0] == noone and line_in2[0] == noone) {
      print("ERROR vertical snap failed line_in1: ",line_in1[0]," line_in2: ", line_in2[0]);
      return;
   }
  
   //Snap to surface
   var bbox_offset = sign(hspeed)*bbox_width/2;
   
   if (line_in1[0] == noone) {
      if (hspeed > 0) {
         x = ceil(line_in2[1]) - bbox_offset;
      } else {
         x = floor(line_in2[1]) - bbox_offset;
      }
   } else if (line_in2[0] == noone) {  
      if(hspeed > 0) {
         x = ceil(line_in1[1]) - bbox_offset;
      } else {
         x = floor(line_in1[1]) - bbox_offset;
      }
   } else {
      if (hspeed < 0) {
         x = max(ceil(line_in1[1]), ceil(line_in2[1])) - bbox_offset;
      } else {
         x = min(floor(line_in1[1]), floor(line_in2[1])) - bbox_offset;
      }
   }
   
   //Set horizontal speed to 0
   hspeed = 0;
   
   //Check Collision Vertical
   check_collision_vertical();
}

function snap_to_vertical_surface_special(line_in, bbox_width) {
   //Verify raycast hits something
   if (line_in[0] == noone) {
      print("ERROR vertical snap special failed line_in: ", line_in[0]);
      return;
   }
   
   //Snap to surface
   var bbox_offset = sign(hspeed)*bbox_width/2;
   
   if (hspeed > 0) {
      x = line_in[0].bbox_left - bbox_offset;
   } else if (vspeed < 0) {
      x = line_in[0].bbox_right - bbox_offset;
   }
   
   //Set vertical speed to 0
   hspeed = 0;
   
   //Check collision horizontal
   check_collision_vertical();
}

function check_collision_diagonal(main_line, other_line_x, other_line_y) { 
   var bbox_height = bbox_bottom - bbox_top;
   var bbox_width = bbox_right - bbox_left;

   if (main_line[0] = noone and other_line_x[0] = noone and other_line_y[0] = noone) {
      //No collision
   } else if (main_line[0] != noone and other_line_x[0] != noone) {
      snap_to_horizontal_surface(main_line, other_line_x, bbox_height);
   } else if (other_line_y[0] != noone and other_line_x[0] != noone) {
      snap_to_horizontal_surface(main_line, other_line_x, bbox_height);
   } else if (main_line[0] != noone and other_line_y[0] != noone) {
      snap_to_vertical_surface(main_line, other_line_y, bbox_width);
   } else if (main_line[0] = noone and other_line_x[0] = noone and other_line_y[0] != noone) {
      //Determine if collision is floor, ceiling, or wall
      var is_collision_floor = check_is_floor(other_line_y);
      var is_collision_ceiling = check_is_ceiling(other_line_y);
      var is_collision_wall = check_is_wall(other_line_y);
   
      if (is_collision_wall) {
         snap_to_vertical_surface(main_line, other_line_y, bbox_width);
      } else if ((is_collision_floor or is_collision_ceiling) and vspeed > 0) {
         snap_to_vertical_surface_special(other_line_y, bbox_width);
      } else {
         print("ERROR: collision found something that is not a wall, ceiling, or floor");
      }
   } else if (main_line[0] = noone and other_line_x[0] != noone and other_line_y[0] = noone) {
      //Determine if collision is floor, ceiling, or wall
      var is_collision_floor = check_is_floor(other_line_x);
      var is_collision_ceiling = check_is_ceiling(other_line_x);
      var is_collision_wall = check_is_wall(other_line_x);

      if(is_collision_floor or is_collision_ceiling) {
         snap_to_horizontal_surface(main_line, other_line_x, bbox_height);
      } else if (is_collision_wall) {
         snap_to_horizontal_surface_special(other_line_x, bbox_height);
      } else {
         print("ERROR: collision found something that is not a wall, ceiling, or floor");
      }
   } else if (main_line[0] != noone and other_line_x[0] = noone and other_line_y[0] = noone) {
      //Determine if collision is floor, ceiling, or wall
      var is_collision_floor = check_is_floor(main_line);
      var is_collision_ceiling = check_is_ceiling(main_line);
      var is_collision_wall = check_is_wall(main_line);
      
      if (is_collision_floor or is_collision_ceiling) {
         snap_to_horizontal_surface(main_line, other_line_x, bbox_height);
      } else if (is_collision_wall) {
         snap_to_vertical_surface(main_line, other_line_y, bbox_width);
      } else {
         print("ERROR: collision found something that is not a wall, ceiling, or floor");
      }
   }
}

function check_collision() {
   //if not moving
   if (hspeed == 0 and vspeed == 0) {
     return;
   }

   //moving straight up or down
   if (hspeed == 0) {
      check_collision_vertical();
      return;
   }  

   //moving straight left or right
   if (vspeed == 0) {
      check_collision_horizontal();
      return;
   }

   var line_top_left, line_top_right, line_bottom_left, line_bottom_right;

   if (hspeed < 0 or vspeed < 0) {
      line_top_left = collision_line_point(bbox_left, bbox_top, bbox_left + hspeed, bbox_top + vspeed,
      obj_collision, true, true);  
   }

   if (hspeed > 0 or vspeed < 0) {
      line_top_right = collision_line_point(bbox_right - 1, bbox_top, bbox_right - 1 + hspeed, bbox_top + vspeed,
      obj_collision, true, true);
   }

   if (hspeed < 0 or vspeed > 0) {
      line_bottom_left = collision_line_point(bbox_left, bbox_bottom - 1, bbox_left + hspeed, bbox_bottom - 1 + vspeed,
      obj_collision, true, true);
   }

   if (hspeed > 0 or vspeed > 0) {  
      line_bottom_right = collision_line_point(bbox_right - 1, bbox_bottom - 1, bbox_right - 1 + hspeed, bbox_bottom - 1 + vspeed,
      obj_collision, true, true);
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
