# godot-plugin-rtmidi
Godot GDNative Plugin Wrapper for RTMidi

STATUS: Unstable and in Development

Did you use my code and and it worked without problems? You could ...<br>
<a href='https://ko-fi.com/T6T31O7TS' target='_blank'><img height='36' style='border:0px;height:36px;' src='https://cdn.ko-fi.com/cdn/kofi1.png?v=2' border='0' alt='Buy Me a Coffee at ko-fi.com' /></a>

### Intro

Creates GDNative based on the rtmidi library
https://www.music.mcgill.ca/~gary/rtmidi/index.html

### Config for OSX
- used online docs for 
- Replaced to SConstruct Line 48 - 57 with

```
if env['platform'] == "osx":
    env['target_path'] += 'osx/'
    cpp_library += '.osx'
    if env['target'] in ('debug', 'd'):
        env.Append(CCFLAGS=['-g', '-O2', '-arch', 'x86_64', '-std=c++17', '-D__MACOSX_CORE__'])
        env.Append(LINKFLAGS=['-arch', 'x86_64', '-framework', 'CoreMIDI', '-framework', 'CoreAudio', '-framework', 'CoreFoundation'])
    else:
        env.Append(CCFLAGS=['-g', '-O3', '-arch', 'x86_64', '-std=c++17', '-D__MACOSX_CORE__'])
        env.Append(LINKFLAGS=['-arch', 'x86_64', '-framework', 'CoreMIDI', '-framework', 'CoreAudio', '-framework', 'CoreFoundation'])
```