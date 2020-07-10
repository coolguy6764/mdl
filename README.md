## About

mdl is a script using youtube-dl to download music in the flac format and metaflac to add metadata to it.

It allows you to:
 - store the music in a structured folder hierarchy 
 - integrate cover image, album, artist, genre and year
 - remove unwanted expressions from titles
 - extract artist from music titles

## Install

1. Clone or download the repository
2. Open a terminal, go to the downloaded folder and run `sudo ./install.sh`
3. Run `mdl -h` to check the installation

To uninstall the program, execute `sudo ./uninstall.sh`. 

*Note: youtube-dl and flac packages are required. So if they are not installed, the script will install them using **apt** or **pacman**. They can be removed with the uninstall script.*


## Use case
1. Choose a playlist or a music on one of the [websites managed by youtube-dl](https://github.com/ytdl-org/youtube-dl/tree/master/youtube_dl/extractor)
2. Open a teminal and launch the script with the wanted options
3. Check the result with your favorite music player

## Examples

*Note: Almost all options are compatible, but in these examples options are showed separatly for a better understanding.*

- **Minimal**

`mdl URL`
```
.
└── Inconnu
    └── Inconnu
        └── music_title.flac
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
        └── music_title.flac
        └── ...       
```

- **Destination folder**

`mdl -d "/home/user/Music" URL`
```
Music
└── Inconnu
    └── Inconnu
        └── music_title.flac
        └── ...       
```
- **Integrate information to the flac**

`mdl -a "Georges Brassens" -A "The Best of Brassens" -g "French Music" -y 2019 URL`

*Note: By default, the artist, album and genre are* "Inconnu" *and the year is* 0000.

- **Remove expressions from titles**

`mdl -r "(audio)/lyrics/live" URL`

This will remove the expressions *"(audio)"*, *"lyrics"* and *"live"*, with unsensitive case.

*Note: By default, only the expression* " - " *is removed (generally used to separate the artist from the music name).*

- **Extract artist from titles**

`mdl -e URL`

With this option you don't need to give the artist name to the program, it will extract it from the titles.
Indeed, if the titles are like "artist - title", you can use this option. And if some titles don't have the artist name,
you can also give it to the script with the option -a, it will extract only those that have that have the separator ' - '.