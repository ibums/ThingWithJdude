draw_self();
draw_set_colour(c_white);
draw_circle(mouse_x, mouse_y, 10, true);

draw_set_colour(c_green);
draw_circle(x, y, grappleEndRadius, true);


draw_set_colour(c_green);
draw_circle(maxXAim, maxYAim, grappleEndRadius, true);


draw_set_colour(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(x, y - sprite_height,string(vspeed) +" "+string(hspeed));

draw_text(x, y - sprite_height - 15,"X: "+string(x) +" Y: "+string(y));
/* Collision debugging
var test1 = collision_line_point(bbox_left + hspeed, y,
bbox_left + hspeed, bbox_bottom + 31, obj_standable, true, true)
         
var test2 = collision_line_point(bbox_right-1 + hspeed, y,
bbox_right-1 + hspeed, bbox_bottom + 31, obj_standable, true, true)
draw_set_colour(c_aqua);
if hspeed >= 0 var bbox_x = bbox_right-1;
else var bbox_x = bbox_left;
var line_final_position = collision_line_point(bbox_x, bbox_top - abs(hspeed) * .7,
               bbox_x, bbox_bottom+1, obj_collision, true, true); 
var line_final_position2 = collision_line_point(bbox_x+.5, bbox_top - abs(hspeed) * .7,
               bbox_x+.5, bbox_bottom+1, obj_collision, true, true);                

//if(test1[0] != noone)
 //draw_line(bbox_left + hspeed, y, bbox_left + hspeed, bbox_bottom + 31);

//if(test2[0] != noone)
 //draw_line(bbox_right-1 + hspeed, y, bbox_right-1 + hspeed, bbox_bottom + 31);
var bbox_width = bbox_right - bbox_left;
var quarterWidth = bbox_width/4;

var line_final_position2 = collision_line_point(x - quarterWidth, bbox_top - abs(hspeed) * .7,
x - quarterWidth, bbox_bottom, obj_collision, true, true); 

var line_final_position3 = collision_line_point(x + quarterWidth, bbox_top - abs(hspeed) * .7,
x + quarterWidth, bbox_bottom, obj_collision, true, true); 

 draw_set_colour(c_aqua);
 var distfrombboxright = abs(bbox_right - (bbox_right - quarterWidth));

if(line_final_position2[0] != noone){
 draw_line(x - quarterWidth,bbox_top - abs(hspeed) * .7, x - quarterWidth, bbox_bottom+(distfrombboxright));
 }
 
draw_set_colour(c_lime);

if(line_final_position3[0] != noone) {
distfrombboxright = abs(bbox_right - (bbox_left - quarterWidth));
 draw_line(x + quarterWidth,bbox_top - abs(hspeed) * .7, x + quarterWidth, bbox_bottom+(distfrombboxright));
}*/
//Uncomment to see collision between mouse and slope
//var test = collision_line_point(x, y,mouse_x,mouse_y,obj_diagonal_up, true, true)
//if(test[0] != noone)
//draw_line(x, y, test[1], test[2]);