# DownloadMusic
Ce script permet de télécharger l'audio de une ou plusieurs vidéos Youtube en format mp3, et d'ajouter une image à ces mp3.

### Installation

**Ce script utlise les paquets youtube-dl, ffmpeg et mid3v2, donc veiller à les installer avant toute chose.**

Une fois un terminal ouvert dans le dossier téléchargé, rendre le script d'installation exécutable avec:
```bash
chmod +x ./install.sh
```
Puis, l'exécuter avec:
```bash
./install.sh
```
Cela permet d'utiliser le script `downloadmp3` à partir de n'importe quel dossier.

Pour vérifier l'installation, ouvrir un nouveau terminal et afficher l'aide avec:
```bash
downloadmp3 -h
```

### Exemples

L'utilisation la plus simple, `downloadmp3 -u url-youtube-musique-ou-playlist`, donne:
```
.
└── Inconnu
    └── Inconnu
        └── Georges_Brassens_Les_copains_d´abord.mp3
        └── ...       
```

Mais avec `downloadmp3 -a "Georges Brassens" -A "Le meilleur de Brassens" -u url-youtube-musique-ou-playlist`, cela donne:
```
.
└── Georges Brassens
    └── Le meilleur de Brassens
        └── Georges_Brassens_Les_copains_d´abord.mp3
        └── ...       
```

Pour créer l'aborescence dans un dossier spécifique, `downloadmp3 -d "/home/user/Musique" -u url-youtube-musique-ou-playlist`:
```
Musique
└── Inconnu
    └── Inconnu
        └── Georges_Brassens_Les_copains_d´abord.mp3
        └── ...       
```
En indiquant l'artiste et l'auteur, le fichier mp3 intègre ces informations. Il est possible d'en ajouter d'autres comme le genre, l'année, ou encore une image de couverture:

`downloadmp3 -a "Hk & Les Saltimbanks" -A "Les temps modernes" -g "Chanson française" -y 2012 -i /home/rafutek/Musique/pochettes/tempsmodernes.jpeg -u url-youtube-musique-ou-playlist`

### Notes
- L'url n'est pas forcément une playlist, ce peut être une simple vidéo
- Il se peut que cela marche avec d'autres sites que Youtube, mais il faut trouver le bon lien
