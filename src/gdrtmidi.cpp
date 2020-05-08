#include "gdrtmidi.h"
#include <iostream>
#include <cstdlib>

using namespace godot;

void GDRTMidi::_register_methods() {
    register_method("_process", &GDRTMidi::_process);
	
    register_method("getVersion", &GDRTMidi::getVersion);
    register_method("getPortCount", &GDRTMidi::getPortCount);
    register_method("getPortName", &GDRTMidi::getPortName);
	
    register_method("sendMessage", &GDRTMidi::sendMessage);
    register_signal<GDRTMidi>((char *)"error", "node", GODOT_VARIANT_TYPE_OBJECT, "value", GODOT_VARIANT_TYPE_INT);
	register_signal<GDRTMidi>((char *)"log", "node", GODOT_VARIANT_TYPE_OBJECT, "value", GODOT_VARIANT_TYPE_INT); 
	
}

GDRTMidi::GDRTMidi() {
	midiin = 0;
	midiout = 0;
}

GDRTMidi::~GDRTMidi() {
    // add your cleanup here
	if (midiin != 0) {
	    delete midiin;
	}
	if (midiout != 0) {
	    delete midiout;
	}
}

void GDRTMidi::_init() {
    try {
      midiin = new RtMidiIn();
    }
    catch ( RtMidiError &error ) {
      //error.printMessage();
	  emit_signal("error", this, 21);
      exit( EXIT_FAILURE );
    }
	
	 try {
      midiout = new RtMidiOut();
    }
    catch ( RtMidiError &error ) {
    	  emit_signal("error", this, 31);
    }	
}

godot::String GDRTMidi::getVersion() {
	return godot::String(RtMidi::getVersion().c_str());
}

int GDRTMidi::getPortCount() {
	// Check inputs.
    unsigned int nPorts = midiin->getPortCount();
	
	return (int) nPorts;
}

godot::String GDRTMidi::getPortName(int i) {
	std::string portName;
    try {
      portName = midiin->getPortName(i);
    }
    catch ( RtMidiError &error ) {
	      godot::String(error.getMessage().c_str());
    }
	return godot::String(portName.c_str());
}



void GDRTMidi::sendMessage(int a, int b, int c) {
  // RtMidiOut constructor
    std::vector<unsigned char> message;
	message.push_back(0);
	message.push_back(0);
	message.push_back(0);

      
   // Open first available port.
   midiout->openPort( 0 );
         
  // Note On: 144, 64, 90
    message[0] = (unsigned char) a;
    message[1] = (unsigned char) b;
    message[2] = (unsigned char) c;
	
	emit_signal("log", this, (int)message[0]);
	emit_signal("log", this, (int)message[1]);
	emit_signal("log", this, (int)message[2]);
	/*
    message[0] = 90;
    message[1] = 2;
    message[2] = 0x7F;
	*/

    midiout->sendMessage( &message );
    delete midiout;

}

void GDRTMidi::_process(float delta) {
}