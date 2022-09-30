image_speed = 0;
global.checkpoint = 0;
if ( image_index == global.checkpoint) {
   global.player_id = instance_create_layer(x,y,"Instances", obj_player);
   with(obj_camera) event_user(0);
}


