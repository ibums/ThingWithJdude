
function check_collision(){ 

var bbox_height = bbox_bottom - bbox_top;
var bbox_width = bbox_right - bbox_left;
   
function check_collision_vertical(){
   
   var bbox_height = bbox_bottom - bbox_top;
   
   if vspeed > 0 var bbox_y = bbox_bottom;
   else var bbox_y = bbox_top;
   
   var line_left = collision_line_point(bbox_left, bbox_y, bbox_left, bbox_y + vspeed,
   obj_collision, false, true);
   
   var line_right = collision_line_point(bbox_right-1, bbox_y, bbox_right-1, bbox_y + vspeed,
   obj_collision, false, true);

   if line_left[0] != noone or line_right[0] != noone {
   
      if vspeed > 0{
         gravity = 0;
         y = round(min(line_left[2], line_right[2]))-bbox_height/2;
         state = handle_grounded;
      }

      else  y = round(max(line_left[2], line_right[2]))+bbox_height/2;
         
      
      vspeed = 0;
      exit
   }

}
   
function check_collision_horizontal(){
   
   var bbox_width = bbox_right - bbox_left;
   
   if hspeed > 0 var bbox_x = bbox_right;
   else var bbox_x = bbox_left;
   
   var line_top = collision_line_point(bbox_x, bbox_top, bbox_x + hspeed, bbox_top+1,
   obj_collision, false, true);
   
   var line_bottom = collision_line_point(bbox_x, bbox_bottom-1, bbox_x + hspeed, bbox_bottom-1,
   obj_collision, false, true);

   if line_top[0] != noone or line_bottom[0] != noone {
   
      if hspeed > 0{
         x = round(min(line_top[1], line_bottom[1]))-bbox_width/2;
      }

      else  x = round(max(line_top[1], line_bottom[1]))+bbox_width/2;
      
      hspeed = 0;
      exit
   }
}
   
//if not moving
if hspeed=0 and vspeed=0 {exit}

//moving straight up or down
if hspeed=0 {check_collision_vertical()}

//moving straight left or right
if vspeed=0 {check_collision_horizontal()}


var line_top_left, line_top_right, line_bottom_left, line_bottom_right;

if hspeed < 0 or vspeed < 0{
   line_top_left = collision_line_point(bbox_left, bbox_top, bbox_left + hspeed, bbox_top + vspeed,
   obj_collision, false, true);  
}

if hspeed > 0 or vspeed < 0{
line_top_right = collision_line_point(bbox_right-1, bbox_top, bbox_right-1 + hspeed, bbox_top + vspeed,
obj_collision, false, true);
}

if hspeed < 0 or vspeed > 0{
line_bottom_left = collision_line_point(bbox_left, bbox_bottom-1, bbox_left + hspeed, bbox_bottom-1 + vspeed,
obj_collision, false, true);
}

if hspeed > 0 or vspeed > 0{  
line_bottom_right = collision_line_point(bbox_right-1, bbox_bottom-1, bbox_right-1 + hspeed, bbox_bottom-1 + vspeed,
obj_collision, false, true);
}

if hspeed < 0 and vspeed < 0{
   
   var main_line = line_top_left;
   var other_line_x = line_top_right;
   var other_line_y = line_bottom_left;
   
   if (main_line[0] = noone and other_line_x[0] = noone and other_line_y[0] = noone){exit}
   
   if (main_line[0] != noone and other_line_x[0] != noone and other_line_y[0] != noone){
   
      if (round(main_line[1]) = round(other_line_y[1])){

         x = round(main_line[1])-sign(hspeed)*bbox_width/2;
         hspeed = 0;
         check_collision_horizontal()
      }
      
      if (round(main_line[2]) = round(other_line_x[2])){
   
         y = round(main_line[2])-sign(vspeed)*bbox_height/2;
         vspeed = 0;
         check_collision_vertical()
      }
      

   }
   if (main_line[0] != noone and other_line_x[0] != noone and other_line_y[0] = noone){
      
         y = max(round(main_line[2]), round(other_line_x[2]))-sign(vspeed)*bbox_height/2;
         vspeed = 0;
         check_collision_vertical()
      }


   if (main_line[0] != noone and other_line_x[0] = noone and other_line_y[0] != noone){
      
         x = max(round(main_line[1]), round(other_line_y[1]))-sign(hspeed)*bbox_width/2;;
         hspeed = 0;
         check_collision_horizontal()
      }
}

if hspeed > 0 and vspeed < 0{
   
   var main_line = line_top_right;
   var other_line_x = line_top_left;
   var other_line_y = line_bottom_right;
   
   if (main_line[0] = noone and other_line_x[0] = noone and other_line_y[0] = noone){exit}
   
   if (main_line[0] != noone and other_line_x[0] != noone and other_line_y[0] != noone){
   
      if (round(main_line[1]) = round(other_line_y[1])){

         x = round(main_line[1])-sign(hspeed)*bbox_width/2;
         hspeed = 0;
         check_collision_horizontal()
      }
      
      if (round(main_line[2]) = round(other_line_x[2])){
   
         y = round(main_line[2])-sign(vspeed)*bbox_height/2;
         vspeed = 0;
         check_collision_vertical()
      }
      

   }
   if (main_line[0] != noone and other_line_x[0] != noone and other_line_y[0] = noone){
      
         y = max(round(main_line[2]), round(other_line_x[2]))-sign(vspeed)*bbox_height/2;
         vspeed = 0;
         check_collision_vertical()
      }


   if (main_line[0] != noone and other_line_x[0] = noone and other_line_y[0] != noone){
      
         x = min(round(main_line[1]), round(other_line_y[1]))-sign(hspeed)*bbox_width/2;;
         hspeed = 0;
         check_collision_horizontal()
      }
}

if hspeed < 0 and vspeed > 0{
   
   var main_line = line_bottom_left;
   var other_line_x = line_bottom_right;
   var other_line_y = line_top_left;
   
   if (main_line[0] = noone and other_line_x[0] = noone and other_line_y[0] = noone){exit}
   
   if (main_line[0] != noone and other_line_x[0] != noone and other_line_y[0] != noone){
   
      if (round(main_line[1]) = round(other_line_y[1])){

         x = round(main_line[1])-sign(hspeed)*bbox_width/2;
         hspeed = 0;
         check_collision_horizontal()
      }
      
      if (round(main_line[2]) = round(other_line_x[2])){
   
         y = round(main_line[2])-sign(vspeed)*bbox_height/2;
         vspeed = 0;
         check_collision_vertical()
      }
      

   }
   if (main_line[0] != noone and other_line_x[0] != noone and other_line_y[0] = noone){
      
         y =min(round(main_line[2]), round(other_line_x[2]))-sign(vspeed)*bbox_height/2;
         vspeed = 0;
         check_collision_vertical()
      }


   if (main_line[0] != noone and other_line_x[0] = noone and other_line_y[0] != noone){
      
         x = max(round(main_line[1]), round(other_line_y[1]))-sign(hspeed)*bbox_width/2;;
         hspeed = 0;
         check_collision_horizontal()
      }
}

if hspeed > 0 and vspeed > 0{
   
   var main_line = line_bottom_right;
   var other_line_x = line_bottom_left;
   var other_line_y = line_top_right;
   
   if (main_line[0] = noone and other_line_x[0] = noone and other_line_y[0] = noone){exit}
   
   if (main_line[0] != noone and other_line_x[0] != noone and other_line_y[0] != noone){
   
      if (round(main_line[1]) = round(other_line_y[1])){

         x = round(main_line[1])-sign(hspeed)*bbox_width/2;
         hspeed = 0;
         check_collision_horizontal()
      }
      
      if (round(main_line[2]) = round(other_line_x[2])){
   
         y = round(main_line[2])-sign(vspeed)*bbox_height/2;
         vspeed = 0;
         check_collision_vertical()
      }
      

   }
   if (main_line[0] != noone and other_line_x[0] != noone and other_line_y[0] = noone){
      
         y =min(round(main_line[2]), round(other_line_x[2]))-sign(vspeed)*bbox_height/2;
         vspeed = 0;
         check_collision_vertical()
      }


   if (main_line[0] != noone and other_line_x[0] = noone and other_line_y[0] != noone){
      
         x = min(round(main_line[1]), round(other_line_y[1]))-sign(hspeed)*bbox_width/2;;
         hspeed = 0;
         check_collision_horizontal()
      }
}

}