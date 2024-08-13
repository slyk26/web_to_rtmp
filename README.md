# web_to_rtmp
Stream any web page into rtmp endpoint(e.g. twitch). Headless.

# Requirements

Docker - https://www.docker.com/

# Usage

First, open main.go and modify this line ```chromedp.Navigate("https://forsen.fun/forse_____")```
to web page you want to stream.

Then open entrypoint.sh and replace {stream_key} with your twitch stream key(remove brackets aswell).

Then, run these commands:

```bash
sudo docker build -t web_to_rtmp .
sudo docker run -it web_to_rtmp
```
