# mp3-dl

Simple script to download music from Youtube, SoundCloud and other websites, in one command.

This little program allows you to:
 - store the music in a structured folder hierarchy 
 - add a cover image
 - integrate album, artist, genre and year
 - remove unwanted expressions from titles
 - extract artist from music title

### Install

- Clone or download the repo
- Open a terminal, go to the downloaded folder and install *mp3-dl* with:

`sudo ./install.sh`

*mp3-dl* uses *youtube-dl*, *ffmpeg* et *mid3v2*, so if they are not installed, the script will install them using **apt** or **pacman**.

- Check the installation with:

`mp3-dl -h`

- To uninstall the program, execute:

`sudo ./uninstall.sh`

*youtube-dl*, *ffmpeg* et *mid3v2* can also be uninstalled.


### Steps
1. Choose a playlist or a music on one of the [websites managed by youtube-dl](https://github.com/ytdl-org/youtube-dl/tree/master/youtube_dl/extractor)
2. Open a teminal and lauch the script with the options and arguments wanted
3. Check the result with your favorite music player

### Examples

- **Minimal**

`mp3-dl -u URL`
```
.
└── Inconnu
    └── Inconnu
        └── music_title.mp3
        └── ...       
```

- **Image**

To add a previously downloaded image as cover:

`mp3-dl -u URL -i /absolute/path/image `

To extract the image from the website:

`mp3-dl -u URL -I `


- **Artist and Album**

`mp3-dl -u URL -a "Georges Brassens" -A "The Best of Brassens" `
```
.
└── Georges Brassens
    └── The Best of Brassens
        └── music_title.mp3
        └── ...       
```

- **Download folder**

`mp3-dl -u URL -d "/home/user/Music"`
```
Music
└── Inconnu
    └── Inconnu
        └── music_title.mp3
        └── ...       
```
- **Integrate information to the mp3**

`mp3-dl -u URL -a "Georges Brassens" -A "The Best of Brassens" -g "French Music" -y 2019`

*Note: By default, the artist, album and genre are* "Inconnu" *and the year is* 0000.

- **Remove expressions from titles**

`mp3-dl -u URL -r "(audio)/lyrics/live"`

This will remove the expressions *"(audio)"*, *"lyrics"* and *"live"*, with unsensitive case.

*Note: By default, only the expression* " - " *is removed (generally used to separate the artist from the music name).*

- **Extract artist from titles**

`mp3-dl -u URL -e`

This option is useful when the music titles have the pattern "artist - title". In this case, the program will remove "artist" from the title, integrate it to the mp3 and place the file in the artist directory.


### Contact
To report a bug or a comment, you can join me at:
- Mastodon: rafutek@mamot.fr
- Mail: raphaelroy@tutanota.com
