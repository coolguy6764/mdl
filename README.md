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

`downloadmp3 -i /chemin/absolu/image -u URL -d /chemin/absolu/dossier -e -A "Album" -g "Genre" -y année -r "expr1/expr2/.../exprN"`

### Etapes
1. Choisir une playlist ou une musique sur un [site géré par youtube-dl](https://github.com/ytdl-org/youtube-dl/tree/master/youtube_dl/extractor)
2. Télécharger une image de couverture de l'album si besoin
3. Ouvrir un terminal **bash**
5. Lancer le script avec les options choisies en fonction des titres des musiques
6. Vérifier le téléchargement avec votre lecteur mp3 préféré

### Exemples

- **Minimal**

`downloadmp3 -u URL`
```
.
└── Inconnu
    └── Inconnu
        └── Georges_Brassens_Les_copains_d´abord.mp3
        └── ...       
```

- **Artiste et Album**

`downloadmp3 -u URL -a "Georges Brassens" -A "Le meilleur de Brassens" `
```
.
└── Georges Brassens
    └── Le meilleur de Brassens
        └── Georges_Brassens_Les_copains_d´abord.mp3
        └── ...       
```

- **Dossier de stockage**

`downloadmp3 -u URL -d "/home/user/Musique"`
```
Musique
└── Inconnu
    └── Inconnu
        └── Georges_Brassens_Les_copains_d´abord.mp3
        └── ...       
```
- **Intégrer des informations aux mp3**

`downloadmp3 -u URL -a "Georges Brassens" -A "Le meilleur de Brassens" -g "Chanson française" -y 2019`

*Note: Par défaut, l'artiste, l'album et le genre sont* "Inconnu" *et date est* 0000.

- **Renseigner des expressions à supprimer des titres**

`downloadmp3 -u URL -r "(audio)/lyrics/live"`

Cela enlèvera toute occurence des expressions *"(audio)"*, *"lyrics"* et *"live"*, **sans être sensible à la casse**.

*Note: Par défaut seule l'expression* " - " *est enlevée (en général utilisée pour séparer l'artiste du titre).*


### Contact
Pour rapporter un bug ou tout commentaire, vous pouvez me joindre par:
- Mastodon: rafutek@mamot.fr
- Diaspora*: rafutek@framasphere.org
- Mail: rafutek@protonmail.com