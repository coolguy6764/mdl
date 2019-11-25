# DownloadMusic
Ce script permet de télécharger l'audio de une ou plusieurs vidéos Youtube en format mp3, et d'ajouter une image à ces mp3.

### Utilisation
Une fois un terminal ouvert dans le dossier, rendre le script exécutable avec:
```bash
sudo chmod +x ./downloadmp3.sh
```
Puis, l'exécuter avec:
```bash
./downloadmp3 /chemin/absolu/dossier/dest/ /chemin/absolu/image.jpg url-youtube-musique-ou-playlist
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
