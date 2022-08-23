function is_floor(x_point,y_point) {
   return round(y - y_point) == round(x - x_point);
}

function is_wall(x,y) {
   return round(x) == bbox_left;
}

function is_ceiling(x,y) {
   return round(y) == bbox_bottom;
}