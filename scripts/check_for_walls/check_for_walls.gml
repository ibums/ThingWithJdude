function check_for_walls(){
   var slope_collision = instance_place(x , y, obj_diagonal_up);
   if slope_collision != noone {
      var block_after_slope = instance_place(slope_collision.x+32, slope_collision.y-32, obj_block)
   }
leftwall = place_meeting(x - abs(hspeed) - 1, y, obj_block) and !place_meeting(x , y, obj_diagonal_up);
rightwall = place_meeting(x , y, obj_diagonal_up) and block_after_slope != noone
   and place_meeting(x + abs(hspeed) + 1, y, block_after_slope)
   or place_meeting(x + abs(hspeed) + 1, y, obj_block) and !place_meeting(x , y, obj_diagonal_up);
}