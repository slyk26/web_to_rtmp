package main

import (
	"flag"
)

func main() {
	var sourceURL, rtmpEndpoint string

	flag.StringVar(&sourceURL, "source_url", "forsen.fun/to_be_filled", "web page url that will go into rtmp")
	flag.StringVar(&rtmpEndpoint, "rtmp_endpoint", "forsen.fun/to_be_filled", "rtmp endpoint to stream web page to (help.twitch.tv/s/twitch-ingest-recommendation)")

	flag.Parse()

}
