# DownloadMusic

[Here](https://framagit.org/rafu/DownloadMusic/wikis/fr) is the french version of this README.

The script *downloadmp3.sh* downloads one ore more musics from Youtube, SoundCloud or other websites, in mp3 format, and place them in a certain folder arborescence.

Optionnaly, it allows adding a cover image to those musics, that will be displayed by your mp3 player.

Moreover, it is possible to integrate some informations like album and artist names (used for the folder arborescence), genre and year.

*downloadmp3.sh* automatically sets the music title as the mp3 title, but sometimes it can contain useless expressions, that can be removed with an option.

We can also choose to directly extract the artist name from the music title when its pattern is *"artist - music title"*.

### Install

**The execution of scripts must be done in a bash shell**

Open a **bash** terminal, go to the downloaded folder and install *downloadmp3* with:
```bash
sudo ./install.sh
```
*downloadmp3* uses *youtube-dl*, *ffmpeg* et *mid3v2*, so if they are not installed, the installation script will manage it. 

To uninstall the program, execute:
```bash
sudo ./uninstall.sh
```
*youtube-dl*, *ffmpeg* et *mid3v2* can also be uninstalled.

To verify the installation, display the help message with:
```bash
downloadmp3 -h
```

### Use

The script saves the musics downloaded as below:
```
folder
└── Artist
    └── Album
        └── title1.mp3
        └── ...       
```

- **Normal mode**

`downloadmp3 -i /absolute/path/image -u URL -d /absolute/path/folder -a "Artist" -A "Album" -g "Genre" -y year -r "expr1/expr2/.../exprN"`

- **Extract mode**

To be used if the music title has the pattern *"artist - music title"*

`downloadmp3 -i /absolute/path/image -u URL -d /absolute/path/folder -e -A "Album" -g "Genre" -y year -r "expr1/expr2/.../exprN"`

### Steps
1. Choose a playlist or a music on one of the [websites managed by youtube-dl](https://github.com/ytdl-org/youtube-dl/tree/master/youtube_dl/extractor)
2. Download a cover image if needed
3. Open a **bash** teminal
4. Lauch the script with option choosen in funciton of the music titles
5. Check the result with your favorite music player

### Examples

- **Minimal**

`downloadmp3 -u URL`
```
.
└── Inconnu
    └── Inconnu
        └── Georges_Brassens_Les_copains_d´abord.mp3
        └── ...       
```

- **Artist and Album**

`downloadmp3 -u URL -a "Georges Brassens" -A "The Best of Brassens" `
```
.
└── Georges Brassens
    └── The Best of Brassens
        └── Georges_Brassens_Les_copains_d´abord.mp3
        └── ...       
```

- **Dossier de stockage**

`downloadmp3 -u URL -d "/home/user/Music"`
```
Music
└── Inconnu
    └── Inconnu
        └── Georges_Brassens_Les_copains_d´abord.mp3
        └── ...       
```
- **Integrate information to the mp3**

`downloadmp3 -u URL -a "Georges Brassens" -A "The Best of Brassens" -g "French Music" -y 2019`

*Note: By default, the artist, album and genre are* "Inconnu" *and the year is* 0000.

- **Indicate expressions to remove from titles**

`downloadmp3 -u URL -r "(audio)/lyrics/live"`

This will remove the expressions *"(audio)"*, *"lyrics"* and *"live"*, **with unsensitive case**.

*Note: By default, only the expression* " - " *is removed (generally used to separate the artist from the music name).*


### Contact
To report a bug or a comment, you can join me at:
- Mastodon: rafutek@mamot.fr
- Diaspora*: rafutek@framasphere.org
- Mail: rafutek@protonmail.com