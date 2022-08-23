/// @description
event_inherited();
// Step Event Part 1

// Turn recording on if not currently on playback
if (_kRecord and !_isPlaying) {
    // Save the recording
    if (_isRecording) {
        WriteInputRecording(_fileName);
    }

    _isRecording = !_isRecording;
}

// Step Event Part 2

// Fill out array while the game is recording
if (_isRecording) {
    // Iterate through each key and store the input and frame. Accepts multiple inputs at once.
    for (var i = 0; i < eKey.NUM_KEYS; ++i) {
        if (_input[i]) {
            _inputSequence[_index, 0] = _frame;
            _inputSequence[_index, 1] = i;
            ++_index;
        }
    }
    ++_frame;
}

// Step Event Part 3

// If the play hotkey is pressed and we are not recording, start playing
if (_kPlay and !_isRecording) {
    _isPlaying = !_isPlaying;
    
    // Load up all the recording sequence from the file into memory
    if (_isPlaying) {
        ReadInputRecording(_fileName);
    }
}

// Step Event Part 4

// Runs every frame to play the sequence when needed
if (_isPlaying) {
    PlayInputRecording();
}