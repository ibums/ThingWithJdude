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

//Uncomment to see collision between mouse and slope
//var test = collision_line_point(x, y,mouse_x,mouse_y,obj_diagonal_up, true, true)
//if(test[0] != noone)
//draw_line(x, y, test[1], test[2]);