//Handle corner case (literally) when colliding with the corner of a block
if (x > other.x and y > other.y) {
   var escapedWall = false;  
   for(var ix = 0; !escapedWall; ix++) {
      if !place_meeting(x + ix, y + ix, obj_block) {
			x += ix;
         y += ix
			escapedWall = true;
		}
   }
}

else if (x < other.x and y > other.y) {
   var escapedWall = false;
   for(var ix = 0; !escapedWall; ix++) {
      if !place_meeting(x - ix, y + ix, obj_block) {
   		x -= ix;
         y += ix;
   		escapedWall = true;
   	}
   }
}

else if (x > other.x and y < other.y) {
   var escapedFloor = false;
   for(var iy = 0; !escapedFloor; iy++) {
      if !place_meeting(x + iy, y - iy, obj_block) {
         x += iy;
			y -= iy;
			escapedFloor = true;
         state = handle_grounded;
		}
   }
} 
else if (x < other.x and y < other.y) and place_meeting(x, y, obj_diagonal_up) = false {
   var escapedCeiling = false;
   for(var iy = 0; !escapedCeiling; iy++) {
      if !place_meeting(x - iy, y - iy, obj_block) {
         x -= iy;
   		y -= iy;
   		escapedCeiling = true;
         state = handle_airborne;
   	}
   }
}