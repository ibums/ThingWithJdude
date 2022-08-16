function check_for_walls(){
leftwall = place_meeting(x - abs(hspeed) - 1, y, obj_block) and !place_meeting(x , y, obj_diagonal_up);
rightwall = place_meeting(x + abs(hspeed) + 1, bbox_top, obj_block) and place_meeting(x , y, obj_diagonal_up)
   or place_meeting(x + abs(hspeed) + 1, y, obj_block) and !place_meeting(x , y, obj_diagonal_up);
}