# Overview
This project is part of the CPEN311 course at the University of British Columbia. The objective of this lab is to design and implement a simple iPod using Finite State Machines (FSMs), Flash Memory, and a keyboard interface. The project mimics the functionality of an iPod, where sound samples stored in Flash memory are read and played through an audio device, and user interactions are managed through a keyboard interface.

# Project Structure
**FSM Design:** The core of this project involves designing FSMs to handle reading sound samples from Flash memory and sending them to the audio D/A converter for playback. The FSMs also manage user inputs from a keyboard to control the playback of the music (e.g., play, stop, rewind, fast-forward).

**Flash Memory Programming:** The sound samples used in this project are pre-programmed into the on-board Flash memory of the FPGA. The project includes steps for programming the Flash memory with these samples.

**Keyboard Interface:** The keyboard interface is used to control the music playback. Keys are mapped to specific actions (e.g., play, pause, stop, rewind, fast-forward).

# How It Works
**Flash Memory Programming:** The sound samples are stored in Flash memory. The provided tools and scripts allow programming the memory with the desired sound samples.

**FSM Implementation:** The FSM reads 16-bit audio samples from Flash memory at a sampling rate of 22kHz. These samples are then sent to the audio D/A converter for playback. The FSMs also handle user inputs from the keyboard to control playback functions such as play, pause, rewind, and fast-forward.

**Keyboard Controls:**
- Play (Key 'E'): Starts or resumes playback
- Pause (Key 'D'): Pauses playback
- Rewind (Key 'B'): Plays the song in reverse
- Fast-Forward (Key 'F'): Plays the song forward
- Restart (Key 'R'): Restarts the song

**Speed Control:**
- Increase Speed (KEY0): Increases the playback speed
- Decrease Speed (KEY1): Decreases the playback speed
- Reset Speed (KEY2): Resets the playback speed to normal

# Conclusion
This project provides hands-on experience with FPGA-based system design, focusing on interfacing with external components like Flash memory and implementing control logic using FSMs.
