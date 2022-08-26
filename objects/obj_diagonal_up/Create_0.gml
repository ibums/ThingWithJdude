function is_floor(x_point,y_point) {
   return (round(y_point - y) == round(x - x_point - 1)) or
           (round(y_point - y - 1) == round(x - x_point - 1));
}

function is_wall(x,y){
   return round(x) == bbox_right;
}

function is_ceiling(x,y){
   return round(y) == bbox_bottom;
}