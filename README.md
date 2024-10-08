ODAS 
====

ODAS stands for Open embeddeD Audition System. This is a library dedicated to perform sound source localization, tracking, separation and post-filtering. ODAS is coded entirely in C, for more portability, and is optimized to run easily on low-cost embedded hardware. ODAS is free and open source.

The [ODAS wiki](https://github.com/introlab/odas/wiki) describes how to build and run the software.

---
# Hexapod build - Raspberry Pi 4 Bookworm

```
sudo apt-get install libfftw3-dev libconfig-dev libasound2-dev libgconf-2-4

---
Dependency issue for uuid-dev
---

wget http://ftp.de.debian.org/debian/pool/main/u/util-linux/uuid-dev_2.38.1-5+deb12u1_armhf.deb
sudo dpkg -i uuid-dev_2.38.1-5+deb12u1_armhf.deb
dpkg -l | grep uuid-dev

hexapod@hexapod:~ $ dpkg -l | grep uuid-dev
ii  libossp-uuid-dev:armhf               1.6.2-1.5+b11                    armhf        OSSP uuid ISO-C and C++ - headers and static libraries
ii  uuid-dev:armhf                       2.38.1-5+deb12u1                 armhf        Universally Unique ID library - headers and static libraries

sudo apt-get install libpulse-dev

sudo apt-get install cmake
git clone https://github.com/introlab/odas.git
mkdir odas/build
cd odas/build
cmake ..
make
```
---

ROS: Please visite the [odas_ros project](https://github.com/introlab/odas_ros).

[![ODAS Demonstration](https://img.youtube.com/vi/n7y2rLAnd5I/0.jpg)](https://youtu.be/n7y2rLAnd5I)

# License

ODAS is provided with the [MIT](LICENSE) license.

# Graphical User Interface (GUI) for Data Visualization

Please have a look at the [odas_web](https://github.com/introlab/odas_web) project.
![GUI](https://github.com/introlab/odas_web/blob/master/screenshots/live_data.png)


# Open Source Hardware from IntRoLab

* [8SoundsUSB](https://sourceforge.net/projects/eightsoundsusb/), 8 inputs, USB powered, configurable microphone array.
* [16SoundsUSB](https://github.com/introlab/16SoundsUSB), 16 inputs, USB powered, configurable microphone array.

# Papers

You can find more information about the methods implemented in ODAS in these papers:

* F. Grondin, D. Létourneau, C. Godin, J.-S. Lauzon, J. Vincent, S. Michaud, S. Faucher, F. Michaud, [ODAS: Open embeddeD Audition System](https://www.frontiersin.org/article/10.3389/frobt.2022.854444), Frontiers in Robotics and AI, Volume 9, 2022 

* F. Grondin and F. Michaud, [Lightweight and Optimized Sound Source Localization and Tracking Methods for Opened and Closed Microphone Array Configurations](https://arxiv.org/pdf/1812.00115), Robotics and Autonomous Systems, 2019 
