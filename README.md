youtube-dl-batch-lq
===================

Low quality download with youtube-dl given a json file with links and titles.

Format of input json file `videos.json`:

```
[{ "id":1, "title": "1 intro", "link": "https://www.youtube.com/watch?v=w23hN36w26U" }]
```

Download all links in that give json file:

```
node youtube-dl-batch videos.json
```

This downloads the videos in 240px with audio.
