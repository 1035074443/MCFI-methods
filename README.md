# MCFI-methods
Motion compensation video interpolation methods

---

## Explain

| index | abbreviation |                            paper                             | published time | main  function |
| :---: | :----------: | :----------------------------------------------------------: | :------------: | :------------: |
|   1   |    AOBMC     | Motion-compensated frame interpolation using bilateral  motion estimation and adaptive overlapped block motion compensation |      2007      |  AOBMCF_RGB.m  |
|   2   |     DSME     | Direction-select motion estimation for motion-compensated  frame rate up-conversion |      2013      |   DSME_RGB.m   |
|   3   |     EBME     | Motion compensated frame rate up-conversion using extended  bilateral motion estimation |      2007      |   EBME_RGB.m   |
|   4   |     MCMP     | Multi-channel mixed-pattern based frame rate up-conversion using  spatio-temporal motion vector refinement and dual-weighted overlapped block motion  compensation |      2014      |   MCMP_RGB.m   |
|   5   |     MFM      |           基于多特征匹配的双向运动估计帧率提升算法           |      2015      |   MFM_RGB.m    |
|   6   |    PFRUC     | High visual quality particle based frame rate up conversion with acceleration  assisted motion trajectory calibration |      2012      |  PFRUC_RGB.m   |

---

## Language

All codes are in MATLAB language and Tested in Matlab2018

---

## Usage example

```matlab
clc;
clear all;
addpath('.\tools\VideoRead\')
addpath('.\tools\VideoWrite\')
addpath('.\tools\VideoTools\')
addpath('.\AOBMC\')

video = "your_video_path.avi";
videoFrames = AVIRead(video,[1,1]);
% Double the frame rate
videoFrames_interpolation_2 = AOBMCF_RGB(double(videoFrames),2);
videoOut = "your_video_path.avi";
WriteAVI(videoFrames_interpolation_2,videoOut, your target frame rate, 'rgb');
```

---

## Attention

 The program only uses CPU to calculate, uncompress the video and read it into memory for processing, which requires high memory size！

---

## Contribution

Thanks for Xiangling Ding!