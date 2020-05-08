#include "gdrtmidi.h"
#include <iostream>
#include <cstdlib>

using namespace godot;

void GDRTMidi::_register_methods() {
    register_method("_process", &GDRTMidi::_process);
	
    register_signal<GDRTMidi>((char *)"error", "part", GODOT_VARIANT_TYPE_STRING, "message", GODOT_VARIANT_TYPE_STRING); 
	register_signal<GDRTMidi>((char *)"log", "part", GODOT_VARIANT_TYPE_STRING, "message", GODOT_VARIANT_TYPE_STRING); 

    register_method("getVersion", &GDRTMidi::getVersion);

    register_method("getInputPortCount", &GDRTMidi::getInputPortCount);
    register_method("getInputPortName", &GDRTMidi::getInputPortName);
    register_method("openInputPort", &GDRTMidi::openInputPort);
    register_method("closeInputPort", &GDRTMidi::closeInputPort);
    register_method("isInputPortOpen", &GDRTMidi::isInputPortOpen);
	
    register_signal<GDRTMidi>((char *)"midi_in_callback", "deltatime", GODOT_VARIANT_TYPE_QUAT, "message1", GODOT_VARIANT_TYPE_INT, "message2", GODOT_VARIANT_TYPE_INT, "message3", GODOT_VARIANT_TYPE_INT); 

    register_method("getOutputPortName", &GDRTMidi::getOutputPortName);
    register_method("getOutputPortCount", &GDRTMidi::getOutputPortCount);
    register_method("openOutputPort", &GDRTMidi::openOutputPort);
    register_method("closeOutputPort", &GDRTMidi::closeOutputPort);
    register_method("isOutputPortOpen", &GDRTMidi::isOutputPortOpen);
	

    register_method("sendMessage", &GDRTMidi::sendMessage);
	
	
}

void rtmidiErrorCallback(RtMidiError::Type type, const std::string &errorText, void *userData);
void midiInCallback( double deltatime, std::vector< unsigned char > *message, void *userData );
	
GDRTMidi::GDRTMidi() {
	midiin = 0;
	midiout = 0;
}

GDRTMidi::~GDRTMidi() {
    // add your cleanup here
	if (midiin != 0) {
	    delete midiin;
		midiin = 0;
	}
	if (midiout != 0) {
	    delete midiout;
		midiout = 0;
	}
}

void GDRTMidi::_init() {
	try {
		midiin = new RtMidiIn();
		midiin->setErrorCallback( &rtmidiErrorCallback, this);
	} catch ( RtMidiError &error ) {
		//emit_signal("error", godot::String("checkMidiIn"), godot::String(error.getMessage().c_str()));
   	}	

	try {
		midiout = new RtMidiOut();
		midiout->setErrorCallback( &rtmidiErrorCallback, this);
	} catch ( RtMidiError &error ) {
		//emit_signal("error", godot::String("checkMidiOut"), godot::String(error.getMessage().c_str()));
	}	
}

void GDRTMidi::_process(float delta) {
}

void rtmidiErrorCallback(RtMidiError::Type type, const std::string &errorText, void *userData) {
	((GDRTMidi*)userData)->emit_signal("error", godot::String("RTMidi Error"), godot::String(errorText.c_str()));
}


godot::String GDRTMidi::getVersion() {
	if (midiin == 0 && midiout == 0) {
		return godot::String("Error Creating MidiIn and MidiOut");
	}
	if (midiin == 0) {
		return godot::String("Error Creating MidiIn");
	}
	if (midiout == 0) {
		return godot::String("Error Creating MidiOut");
	}
	return godot::String(RtMidi::getVersion().c_str());
}

// --------------------- --------------------- Input Port Handling  --------------------- ---------------------

int GDRTMidi::getInputPortCount() {
    return (int) midiin->getPortCount();
}

godot::String GDRTMidi::getInputPortName(int i) {
	std::string portName;
    try {
      portName = midiin->getPortName(i);
    }
    catch ( RtMidiError &error ) {
		emit_signal("error", godot::String("getInputPortName"), godot::String(error.getMessage().c_str()));
	    return godot::String(error.getMessage().c_str());
    }
	return godot::String(portName.c_str());
}

void GDRTMidi::openInputPort(int i) {
	midiin->openPort(i);
	midiin->setCallback( &midiInCallback, this);
}

void GDRTMidi::closeInputPort() {
	midiin->closePort();
	midiin->cancelCallback();
}

bool GDRTMidi::isInputPortOpen() {
	return midiin->isPortOpen();
}

void midiInCallback( double deltatime, std::vector< unsigned char > *message, void *userData ) {
	((GDRTMidi*)userData)->emit_signal("midi_in_callback", (float)deltatime, (int)message->at(0), (int)message->at(1), (int)message->at(2));
}

// --------------------- --------------------- Output Port Handling  --------------------- ---------------------

int GDRTMidi::getOutputPortCount() {
    return (int) midiout->getPortCount();
}

godot::String GDRTMidi::getOutputPortName(int i) {
	std::string portName;
    try {
      portName = midiout->getPortName(i);
    }
    catch ( RtMidiError &error ) {
		emit_signal("error", godot::String("getOutputPortName"), godot::String(error.getMessage().c_str()));
	    return godot::String(error.getMessage().c_str());
    }
	return godot::String(portName.c_str());
}

void GDRTMidi::openOutputPort(int i) {
	midiout->openPort(i);
}

void GDRTMidi::closeOutputPort() {
	midiout->closePort();
}

bool GDRTMidi::isOutputPortOpen() {
	return midiout->isPortOpen();
}

void GDRTMidi::sendMessage(int a, int b, int c) {
	std::vector<unsigned char> message;
	message.push_back((unsigned char) a);
	message.push_back((unsigned char) b);
	if (c >= 0) message.push_back((unsigned char) c);

    midiout->sendMessage( &message );
}