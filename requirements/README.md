
### Klipper dependencies:
------------------------
#### Use v19.07 `distfeeds.conf`

* Python2 - install with `opkg install python`
* Python2-pip - install with `opkg install python-pip`
* Python2 packages:
  | package | instructions |
  |-|-|
  | cffi==1.12.2 | install with `opkg install python-cffi`|
  | pyserial==3.4 | install with `opkg install python-pyserial`|
  | greenlet==0.4.15 | To build and install it on the box you need `gcc` and `python-dev`. Install it with pip 2 not 3 `pip install greenlet==0.4.15` Otherwise use the *ipk file I crossbuilt.
  | Jinja2==2.10.1 | Install it with pip 2 not 3: `pip install jinja2`|
  | python-can==3.3.4 | Install with pip 2 not 3: `pip install python-can==3.3.4`|

### Moonraker dependencies:
------------------------
#### Use original `distfeeds.conf`

* Python3 - install with `opkg install python3 --force-overwrite`
* Python3-pip - install with `opkg install python3-pip`
* Python3 packages:  
  | package | instructions |
  |-|-|
  | pyserial==3.4 | install with `opkg install python3-pyserial --force-overwrite`|
  | pillow==8.0.1 | install with `opkg install python3-pillow`|
  | tornado==6.1.0 | install with `opkg install python3-tornado`|
  | distro==1.5.0 | install with `opkg install python3-distro`|
  | inotify-simple==1.3.5 | install with `pip3 install inotify-simple` - if you get a `_distutils_hack` error update python3-setuptools to ver>=56.2. OpenWrt repo might not have the latest version so you'd probably have to download it from [github](https://github.com/pypa/setuptools) and manually install it: Clone setuptools [repo](https://github.com/pypa/setuptools.git) `cd` to root fodler then `python3 setup.py install`|
  | lmdb==1.1.1 | I had issues with it - I provided a cross-compiled package inside [`Packages`](https://github.com/ihrapsa/KlipperWrt/tree/main/packages). If you don't manage to install it or moonraker still errors on it switch to an [older](https://github.com/Arksine/moonraker/archive/eb37ce767d73b064b0260432e4a3323cf8e8d758.zip) release of moonraker where this package is not a requirement |
  | streaming-form-data==1.8.1 | I had issues with it - I provided a cross-compiled package inside [`Packages`](https://github.com/ihrapsa/KlipperWrt/tree/main/packages) |
  | python-jose[cryptography]==3.2.0 |  Install with `pip3 install python-jose` - if you get errors with this install it manually: Clone the python-jose [repo](https://github.com/mpdavis/python-jose.git) `cd` into it then `python3 setup.py install` | 
  | libnacl==1.7.2 |  Install with `pip3 install libnacl`|  
* nginx - install with `opkg install nginx-ssl`

### Duet-Web-Control dependencies:
------------------------
#### Use original `distfeeds.conf`

* Python3 - install with `opkg install python3 --force-overwrite`
* Python3-pip - install with `opkg install python3-pip`
* Python3 packages:
  | package | instructions |
  |-|-|
  | tornado==6.1.0 | install with `opkg install python3-tornado`|

___________________________

* If you can't install python3 packages with opkg or pip and can't finde them inside menuconfig either you can build them by selecting `[*] Advanced configuration options (for developers)`. After that a _`python3-packages`_ option will appear inside _`Languages`_ --> `Python` --> `python3-packages` -> select it with `<M>` -> type pacakge names space delimited inside --> `() List of python3 pacakges to install on target` 
* `lmdb` and `streaming-form-data` were cross-compiled that way. A single `*ipk` file installs both python packages.
