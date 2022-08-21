// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
//https://developer.amazon.com/blogs/appstore/post/3bb65890-7230-431f-836e-35455ae996bf/easy-input-replay-system-in-gamemaker-studio-2
function ReadInputRecording(_infile){
// ReadInputRecording
   var file = file_text_open_read(_infile);

   var i = 0;

   while (!file_text_eof(file))
   {
       _inputSequence[i, 0] = file_text_read_real(file);
       _inputSequence[i, 1] = file_text_read_real(file);
       file_text_readln(file);
       ++i;
   }

   file_text_close(file);
}