if other.image_index = 0 and other.button_buffer = false{
other.button_buffer = true;
other.alarm[0] = 10;
other.image_index = 1;
global.button = true;
}

if other.image_index = 1 and other.button_buffer = false{
other.button_buffer = true;
other.alarm[0] = 10;
other.image_index = 0;
global.button = false;
}