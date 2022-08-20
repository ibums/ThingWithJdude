function check_for_walls(){
   
leftwall = place_meeting(x - abs(hspeed) - 1, y, obj_block);
rightwall = place_meeting(x + abs(hspeed) + 1, y, obj_block);

}
