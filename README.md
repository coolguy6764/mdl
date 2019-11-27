# DownloadMusic
Ce script permet de télécharger l'audio de une ou plusieurs vidéos Youtube en format mp3, et d'ajouter une image à ces mp3. 

De façon optionnelle il est possible de renseigner d'autres informations aux musiques téléchargées comme l'album et l'artiste (utile à la création de l'arborescence), le genre ou encore la date.

Enfin, ce script intègre de façon automatique le titre de(s) vidéo(s) comme titre de(s) mp3(s). Il est alors possible de dire quelles expressions supprimer du titre.

### Installation

**Ce script utlise les paquets youtube-dl, ffmpeg et mid3v2, donc veiller à les installer avant toute chose.**

Une fois un terminal ouvert dans le dossier téléchargé, installer le script avec:
```bash
sudo ./install.sh
```
Cela permet d'utiliser le script `downloadmp3` à partir de n'importe quel dossier.

Pour le désinstaller, exécuter:
```bash
sudo ./uninstall.sh
```

**L'exécution de ce script doit se faire dans un shell bash**

Pour vérifier l'installation, ouvrir un nouveau terminal et afficher l'aide avec:
```bash
downloadmp3 -h
```

### Exemples

L'utilisation la plus simple, `downloadmp3 -i /chemin/absolu/image -u url-youtube-musique-ou-playlist`, donne:
```
.
└── Inconnu
    └── Inconnu
        └── Georges_Brassens_Les_copains_d´abord.mp3
        └── ...       
```

Mais avec `downloadmp3 -i /chemin/absolu/image -u url-youtube-musique-ou-playlist -a "Georges Brassens" -A "Le meilleur de Brassens" `, cela donne:
```
.
└── Georges Brassens
    └── Le meilleur de Brassens
        └── Georges_Brassens_Les_copains_d´abord.mp3
        └── ...       
```

Pour créer l'aborescence dans un dossier spécifique, `downloadmp3 -i /chemin/absolu/image -u url-youtube-musique-ou-playlist -d "/home/user/Musique"`:
```
Musique
└── Inconnu
    └── Inconnu
        └── Georges_Brassens_Les_copains_d´abord.mp3
        └── ...       
```
En indiquant l'artiste et l'auteur, le fichier mp3 intègre ces informations. Il est possible d'en ajouter d'autres comme le genre et l'année:

`downloadmp3 -i /chemin/absolu/image -u url-youtube-musique-ou-playlist -a "Georges Brassens" -A "Le meilleur de Brassens" -g "Chanson française" -y 2019`

Enfin, l'intégration du titre de la vidéo au mp3 se fait automatiquement, mais il est possible de renseigner des expressions à supprimer:

`downloadmp3 -i /chemin/absolu/image -u url-youtube-musique-ou-playlist -a "Georges Brassens" -A "Le meilleur de Brassens" -g "Chanson française" -y 2019 -r "(audio)/lyrics/live"`

Cela enlèvera toute occurence des expressions (audio), lyrics et live, sans être sensible à la casse.
Par défaut seules les expressions " - " sont enlevées (en général pour séparer l'artiste du titre).

### Notes
- L'url n'est pas forcément une playlist, ce peut être une simple vidéo
- Il se peut que le téléchargement de l'audio marche sur d'autres sites que Youtube, mais il faut trouver le bon url
