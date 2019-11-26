# DownloadMusic
Ce script permet de télécharger l'audio de une ou plusieurs vidéos Youtube en format mp3, et d'ajouter une image à ces mp3.

### Utilisation

**Ce script utlise les paquets youtube-dl, ffmpeg et mid3v2, donc veiller à les installer avant toute chose.**

Une fois un terminal ouvert dans le dossier, rendre le script d'installation exécutable avec:
```bash
chmod +x ./install.sh
```
Puis, l'exécuter avec:
```bash
./install.sh
```
Cela permettra d'utiliser le script à partir de n'importe quel dossier.

Pour afficher l'aide et voir les différentes options:
```bash
downloadmp3 -h
```
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

### Exemple
Téléchargement de [cette playlist](https://www.youtube.com/watch?v=y5Hb5I67Qpc&list=OLAK5uy_lJd7ElgvYo3u-wDsbIXNKVgkm_YmCgiFw) par exemple.

  1. Télécharger une image qui sera intégrée à tous les mp3
  2. Ouvrir un terminal et se placer où se trouve le script
  3. Exécuter `./downloadmp3 /chemin/absolu/dossier/musique/ /chemin/absolu/image.jpg https://www.youtube.com/watch?v=y5Hb5I67Qpc&list=OLAK5uy_lJd7ElgvYo3u-wDsbIXNKVgkm_YmCgiFw`
  4. Ouvrir votre lecteur mp3 préféré et savourer un ou plusieurs morceaux
  
### Notes
- L'url n'est pas forcément une playlist, ce peut être une simple vidéo
- Il se peut que cela marche avec d'autres sites que Youtube, mais il faut de chercher le bon lien
