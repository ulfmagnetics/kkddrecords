KillKillDieDie Records - The Rails App
======================================

by John Berry (ulfmagnetics@gmail.com)

TODO
====
- Everything, pretty much

REQUIREMENTS
=====
- Simple, clean browser of KKDD discography.  One big page that scrolls vertically.
    - Sort by artist name or release date.  Floating table of contents indexes by alpha (for name sort) or year (for release date sort)
    - Hovering over album reveals Youtube-style "play button" overlay to kick off streaming playback of the album.  Player needs fwd/back/play/pause navigation.
    - Download links for whatever formats have been uploaded appear below album.
    - Decent default cover image if no art

- Easy-to-use album uploader.  Need to facilitate the filling in of missing content byKKDD members.
    - Password authentication.
    - Log who uploaded album and when.
    - Upload ZIP of album tracks and artwork.
    - App parses archive and attempts to create database records.
    - Verify results with user before "publishing" to site.

- CRUD interface for bands, albums, and tracks.
    - Doesn't really have to be pretty.

- Auditing
    - Duplicate band names?
    - Missing tracks
    - Missing cover art

TECH NOTES
=====
- Need local storage for uploaded ZIPs.  Extract media, create db records, then upload to S3.
  This should happen through a status interface with steps/checkboxes to show progress.
      - Uploading (show progress in percent)
      - Exploding (blow ZIP out onto local filesystem)
      - Interactive Verify/Edit
      - Teleporting (send to S3, show progress in percent)
      - Cleaning up (remove local files)

- ExplosionsController: an explosion is when a ZIPfile gets turned into:
    - an album with cover art
    - a set of tracks for that album (potentially multiple formats)

