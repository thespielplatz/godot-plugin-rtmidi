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
    void _process(float delta);
	
	godot::String getVersion();
	
	int getInputPortCount();
	godot::String getInputPortName(int i);
	void openInputPort(int i);
	void closeInputPort();
	bool isInputPortOpen();
	//void midiInCallback( double deltatime, std::vector< unsigned char > *message, void *userData );

	int getOutputPortCount();
	godot::String getOutputPortName(int i);
	void openOutputPort(int i);
	void closeOutputPort();
	bool isOutputPortOpen();
	
	void sendMessage(int a, int b, int c);

};

}

#endif