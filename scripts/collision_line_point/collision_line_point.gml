//https://yal.cc/gamemaker-collision-line-point/
//var r = collision_line_point(x, y, mouse_x, mouse_y, obj_some, true, true);
//draw_line(x, y, r[1], r[2]);
//if (r[0] != noone) {
//    // r[0] holds the nearest (hit) instance.
//}
function collision_line_point(_x1, _y1, _x2, _y2, _obj, _prec, _notme) {
   var x1 = _x1;
   var y1 = _y1;
   var x2 = _x2;
   var y2 = _y2;
   var qi = _obj;
   var qp = _prec;
   var qn = _notme;
   var rr, rx, ry;
   rr = collision_line(x1, y1, x2, y2, qi, qp, qn);
   rx = x2;
   ry = y2;
   if (rr != noone) {
       var p0 = 0;
       var p1 = 1;
       repeat (ceil(log2(point_distance(x1, y1, x2, y2))) + 1) {
           var np = p0 + (p1 - p0) * 0.5;
           var nx = x1 + (x2 - x1) * np;
           var ny = y1 + (y2 - y1) * np;
           var px = x1 + (x2 - x1) * p0;
           var py = y1 + (y2 - y1) * p0;
           var nr = collision_line(px, py, nx, ny, qi, qp, qn);
           if (nr != noone) {
               rr = nr;
               rx = nx;
               ry = ny;
               p1 = np;
           } else p0 = np;
       }
   }
   var r;
   r[0] = rr;
   r[1] = rx;
   r[2] = ry;
   return r;
}