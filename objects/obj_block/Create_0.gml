function is_floor(x,y){
   return round(y) == bbox_top
}

function is_wall(x,y){
   return round(x) == bbox_left or round(x) == bbox_right;
}

function is_ceiling(x,y){
   return round(y) == bbox_bottom;
}