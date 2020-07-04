## About

mdl is a simple script to download music from Youtube, SoundCloud and other websites, in one command.

It allows you to:
 - store the music in a structured folder hierarchy 
 - add a cover image
 - integrate album, artist, genre and year
 - remove unwanted expressions from titles
 - extract artist from music title

## Install

1. Clone or download the repository
2. Open a terminal, go to the downloaded folder and run `sudo ./install.sh`
3. Open a new terminal and check the installation with `mdl -h`

To uninstall the program, execute `sudo ./uninstall.sh`. 

*Note: youtube-dl, ffmpeg and mid3v2 are required. So if they are not installed, the script will install them using **apt** or **pacman**. They can be removed with the uninstall script.*


## Use case
1. Choose a playlist or a music on one of the [websites managed by youtube-dl](https://github.com/ytdl-org/youtube-dl/tree/master/youtube_dl/extractor)
2. Open a teminal and launch the script with the options and arguments wanted
3. Check the result with your favorite music player

## Examples

*Note: Almost every options are compatible, but in these examples I chose to limit the number of options for a better understanding.*

- **Minimal**

`mdl URL`
```
.
└── Inconnu
    └── Inconnu
        └── music_title.mp3
        └── ...       
```

- **Cover image**

To add a previously downloaded image as cover:

`mdl -i /absolute/path/image URL`

To extract the cover from the website:

`mdl -I URL`


- **Album and artist**

`mdl -A "The Best of Brassens" -a "Georges Brassens" URL`
```
.
└── Georges Brassens
    └── The Best of Brassens
        └── music_title.mp3
        └── ...       
```

- **Destination folder**

`mdl -d "/home/user/Music" URL`
```
Music
└── Inconnu
    └── Inconnu
        └── music_title.mp3
        └── ...       
```
- **Integrate information to the mp3**

`mdl -a "Georges Brassens" -A "The Best of Brassens" -g "French Music" -y 2019 URL`

*Note: By default, the artist, album and genre are* "Inconnu" *and the year is* 0000.

- **Remove expressions from titles**

`mdl -r "(audio)/lyrics/live" URL`

This will remove the expressions *"(audio)"*, *"lyrics"* and *"live"*, with unsensitive case.

*Note: By default, only the expression* " - " *is removed (generally used to separate the artist from the music name).*

- **Extract artist from titles**

`mdl -e URL`

This option is useful when the music titles have the pattern "artist - title". In this case, the program will remove "artist" from the title, integrate it to the mp3 and place the file in the artist directory.
