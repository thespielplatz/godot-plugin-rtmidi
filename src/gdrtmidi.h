#ifndef GDRTMIDI_H
#define GDRTMIDI_H

#include <Godot.hpp>
#include <Node.hpp>
#include "RtMidi.h"
 
namespace godot {

class GDRTMidi : public Node {
    GODOT_CLASS(GDRTMidi, Node)

private:
	RtMidiIn *midiin;
	RtMidiOut *midiout;

public:
    static void _register_methods();

    GDRTMidi();
    ~GDRTMidi();

    void _init(); // our initializer called by Godot

	godot::String getVersion();
	int getPortCount();
	godot::String getPortName(int i);
	
	void sendMessage(int a, int b, int c);
	
	
    void _process(float delta);
};

}

#endif