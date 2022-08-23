// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
//https://developer.amazon.com/blogs/appstore/post/3bb65890-7230-431f-836e-35455ae996bf/easy-input-replay-system-in-gamemaker-studio-2
function WriteInputRecording(_outfile) {
// WriteInputRecording Script
   var file = file_text_open_write(_outfile);
   
   if(array_length(_inputSequence) == 2) {
      _inputSequence = 0;
      file_text_close(file);
      return;
   }
   
   for (var i = 0; i < array_length(_inputSequence); ++i) {
       file_text_write_real(file, _inputSequence[i, 0]);
       file_text_write_real(file, _inputSequence[i, 1]);
       file_text_writeln(file);
   }

   _inputSequence = 0;

   file_text_close(file);
}