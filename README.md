![alt text](https://github.com/ricardorachaus/pingaudio/blob/master/Pingaudio/v3.png "Logo")

Pingaudio is an audio handling framework.

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
    - [Appending an audio](#appending-an-audio)
    - [Removing an interval](#removing-an-interval)
    - [Removing outside an interval](#removing-outside-an-interval)
- [Credits](#credits)
- [License](#license)


## Features

- [x] Append audios
- [x] Manipulate audio intervals
- [x] Merge multiple audios together
- [x] [Complete Documentation](https://github.com/ricardorachaus/pingaudio)


## Requirements
- Xcode 8.1+
- Swift 3.0+

## Installation
coming soon..

## Usage

> All public methods in Pingaudio work  _asynchronously_. Manipulating audio files do usually take some time to work, so methods have to be asynchronous, or else you would not be able to do decent programming with it.

### Appending an audio
All you need are the `URL`s of the audios you want to append.
```swift
import Pingaudio
let myAudio = PAAudio(path: *myAudioPath*)
myAudio.append(audio: *anotherAudioPath*) {
  // do stuff when appending is complete
}
```
The result audio automatically replace `myAudio` previous audio.


### Removing an interval

Removing an interval with Pingaudio involves handling the output audio in the closure.

```swift
  let myAudio = PAAudio(path: *myAudioPath*)
  myAudio.remove(intervalFrom: CMTime(seconds: 2.0, preferredTimescale: 1), to: CMTime(seconds: 4.0, preferredTimescale: 1)) {(output: PAAudio?) -> Void in
            if let result = output {
                print("success!")
            } else {
                print("fail :(")
            }
        }
    }
```

In the above example, the closure method will print "success" if `result` is a non-nil `URL` path to the output audio. If `output` is nil, it'll print "fail :("



### Removing outside an interval

Removing outside an interval (i.e. cropping the audio outside the specified interval) is similar to the above example, only difference is that the audio _inside_ the interval will remain instead.

```swift
  let myAudio = PAAudio(path: *myAudioPath*)
  myAudio.remove(outsideIntervalFrom: CMTime(seconds: 2.0, preferredTimescale: 1), to: CMTime(seconds: 4.0, preferredTimescale: 1)) {(output: PAAudio?) -> Void in
            if let result = output {
                print("success!")
            } else {
                print("fail :(")
            }
        }
    }
```

### Credits
[Miguel Nery](https://github.com/MiguelNery)

[Ricardo Rachaus](https://github.com/ricardorachaus)


### License
Pingaudio is released under the MIT license.
