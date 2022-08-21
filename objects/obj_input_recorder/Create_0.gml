// Create Event
//https://developer.amazon.com/blogs/appstore/post/3bb65890-7230-431f-836e-35455ae996bf/easy-input-replay-system-in-gamemaker-studio-2
// Only one copy of this should be running
MakeUnique();

// Keys Enum
enum eKey
{
    LeftPressed = 0,
    RightPressed,
    UpPressed,
    DownPressed,
    JumpPressed,
    JumpHold,
    GrapplePressed,
    DashPressed,
    AttackPressed,
    
    LeftReleased,
    RightReleased,
    UpReleased,
    DownReleased,
    JumpReleased,
    GrappleReleased,
    DashReleased,
    AttackReleased,
    NUM_KEYS
}

// Variables
_fileName = "Recording_" + string(room_get_name(room)) + ".txt";

// Check if currently recording or playing
_isRecording = false;
_isPlaying   = false;

// Variables to keep track of the frames
_frame = 0;
_index = 0;

// Arrays to store the keys to record, and the recorded values and frames
_input         = array_create(eKey.NUM_KEYS, false);
_inputSequence = [0, 0];

// Hotkeys to start/stop recording and playback
_kRecord = 0;
_kPlay   = 0;