
## 1 背景
在开发流媒体服务器的过程中，尝试了不少Web播放器，在实际使用时发现这些播放器支持的音视频编码格式大都限于H.264/AAC，现在也有不少播放器借助WebAssembly技术实现了H.265解码播放，但音频格式基本上仍仅限于AAC。在实际使用过程中遇到相当多的设备仅支持G.711A/U的音频编码（特别是各种监控设备），因此，本项目尝试开发一款支持H.265/H.264/AAC/G.711A/G.711U等编码格式的播放器，以配合流媒体服务器的开发。

## 2 目标
1. 支持视频解码：H.264、H.265
2. 支持音频解码：AAC、G.711A（PCM-ALAW）、G.711U（PCM-MULAW）、G.723.1、G.729，涵盖GB28181-2016涉及的各种格式
3. 支持流式媒体：HTTP-FLV、Websocket-FLV
4. 支持远程文件播放

## 3 依赖
本项目代码使用WASM、FFmpeg、WebGL、Web Audio等组件，主要参考了以下项目：

[基于WASM的H265 Web播放器](https://blog.csdn.net/sonysuqin/article/details/86770715)

在此基础上做了以下扩展：
1. 增加对Websocket-FLV流的支持
2. 增加对G.711A（PCM-ALAW）、G.711U（PCM-MULAW）、G.723.1、G.729音频编码格式的支持
3. 增加对解码后的YUVJ420P图像格式支持

## 4 编译
### 4.1 安装Emscripten
参考其[官方文档](https://emscripten.org/docs/getting_started/downloads.html)。
### 4.2 下载FFmpeg
```
git clone https://git.ffmpeg.org/ffmpeg.git
```
### 4.3 下载本项目代码
保证FFmpeg目录和代码目录平级。
```
git clone https://github.com/lawrencehj/WasmMediaPlayer.git
```
### 4.4 编译
代码中已包含编译好的wasm，如未对decoder.c进行修改且未对ffmpeg进行重新编译，可直接进入下一节《5. 测试》

如果修改过decoder.c，未重新编译ffmpeg，可在代码目录执行：
```
./build_decoder_wasm.sh
```

如需修改ffmpeg配置，则需修改build_decoder.sh，保存后执行：
```
./build_decoder.sh
```

## 5 测试
安装了Emscripten后，可使用内置的Http Server，在代码目录下执行：

```
http-server -p 8080 .
```
在浏览器输入即可：

```
http://localhost:8080
```

## 6 待优化问题
1. 解码、播放H265时CPU占用相对较高
2. 对于高码流实时流存在延时逐步加大的问题，拟采用Ring Buffer取代FIFO解决
3. 代码封装