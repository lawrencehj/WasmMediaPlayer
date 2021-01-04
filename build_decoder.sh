echo "Beginning Build:"
rm -r dist
mkdir -p dist
cd ../ffmpeg
echo "emconfigure"
emconfigure ./configure --cc="emcc" --cxx="em++" --ar="emar" --ranlib="emranlib" --prefix=$(pwd)/../WasmMediaPlayer/dist --enable-cross-compile --target-os=none \
        --arch=x86_32 --cpu=generic --enable-gpl --enable-version3 --disable-avdevice --disable-swresample --disable-postproc --disable-avfilter --disable-swscale \
        --disable-programs --disable-logging --disable-everything --enable-avformat --enable-decoder=hevc --enable-decoder=h264 --enable-decoder=aac \
        --enable-decoder=pcm_alaw --enable-decoder=pcm_mulaw --enable-decoder=g723_1 --enable-decoder=g729 \
        --disable-ffplay --disable-ffprobe --disable-asm --disable-doc --disable-devices --disable-network --disable-hwaccels \
        --disable-parsers --disable-bsfs --disable-debug --enable-protocol=file --enable-demuxer=mov --enable-demuxer=flv --disable-indevs --disable-outdevs
if [ -f "Makefile" ]; then
  echo "make clean"
  make clean
fi
echo "make"
make
echo "make install"
make install
cd ../WasmMediaPlayer
./build_decoder_wasm.sh
