room_restart();

//Reset replay vars
var rec = instance_find(obj_input_recorder, 0);
rec._frame = 0;
rec._index = 0;
