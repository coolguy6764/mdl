# mp3-dl


The script *mp3-dl* downloads one ore more musics from Youtube, SoundCloud or other websites, in mp3 format, and place them in a certain folder arborescence.

Optionnaly, it allows adding a cover image to those musics, that will be displayed by your mp3 player.

Moreover, it is possible to integrate some informations like album and artist names (used for the folder arborescence), genre and year.

*mp3-dl.sh* automatically sets the music title as the mp3 title, but sometimes it can contain useless expressions, that can be removed with an option.

We can also choose to directly extract the artist name from the music title when its pattern is *"artist - music title"*.

### Install

**The execution of scripts must be done in a bash shell**

Open a **bash** terminal, go to the downloaded folder and install *mp3-dl* with:
```bash
sudo ./install.sh
```
*mp3-dl* uses *youtube-dl*, *ffmpeg* et *mid3v2*, so if they are not installed, the installation script will manage it. 

To uninstall the program, execute:
```bash
sudo ./uninstall.sh
```
*youtube-dl*, *ffmpeg* et *mid3v2* can also be uninstalled.

To verify the installation, display the help message with:
```bash
mp3-dl -h
```

### Steps
1. Choose a playlist or a music on one of the [websites managed by youtube-dl](https://github.com/ytdl-org/youtube-dl/tree/master/youtube_dl/extractor)
2. Download a cover image, if needed
3. Open a **bash** teminal
4. Lauch the script with option choosen in function of the music titles
5. Check the result with your favorite music player

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

- **Indicate expressions to remove from titles**

`mp3-dl -u URL -r "(audio)/lyrics/live"`

This will remove the expressions *"(audio)"*, *"lyrics"* and *"live"*, **with unsensitive case**.

*Note: By default, only the expression* " - " *is removed (generally used to separate the artist from the music name).*


### Contact
To report a bug or a comment, you can join me at:
- Mastodon: rafutek@mamot.fr
- Mail: raphaelroy@tutanota.com
