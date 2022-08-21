// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
//https://developer.amazon.com/blogs/appstore/post/3bb65890-7230-431f-836e-35455ae996bf/easy-input-replay-system-in-gamemaker-studio-2
function MakeUnique(){
   if (instance_number(object_index) > 1)
       instance_destroy();
}