# Transcoding Service

The transcoding service converts mkv videos to webm and uploads them to Amazon S3.
After that, the URL(`archived_url`) of the uploaded video is send to the Peepol.tv API `PUT /api/streams/:id`

## Environment variables

This are the required environment variables

* AWS_KEY_ID
* AWS_ACCESS_KEY
* AWS_S3_BUCKET
* AUTH_TOKEN: A User token access protected parts of the api
* API_HOST: The URL of the API server( Ex. http://api.peepol.tv)
* VIDEO_DIRECTORY: Ex. /tmp

## Dependencies

### ffmpeg 1.2
```sh
wget http://www.ffmpeg.org/releases/ffmpeg-1.2.4.tar.bz2
bunzip2 ffmpeg-1.2.4.tar.bz2
tar xvf ffmpeg-1.2.4.tar
cd ffmpeg-1.2.4/
sudo apt-get install yasm pkg-config build-essential
./configure
make -j6
sudo make install
```
