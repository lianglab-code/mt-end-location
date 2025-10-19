# 微管相关蛋白（MAPs）在生长的微管末端的定位

## 概述

这是一个MATLAB脚本，用于追踪微管相关蛋白（MAPs）在微管末端的位置信息。

## 系统要求

- MATLAB（建议R2020a或更高版本）
- 图像处理工具箱

## 数据准备

- 输入格式：TIFF格式的动态影像
- 影像要求：包含清晰的单次结合事件
- 预处理：请先对影像进行去除尺度信息处理

## 快速开始

### 1. 导入数据

```matlab
% 导入微管通道和MAPs通道影像
mymt = tif_img_reader('path_to_microtubule_movie');
mymap = tif_img_reader('path_to_MAPs_movie');
```

**注意**：请确保两个通道的帧数和图像尺寸完全一致。

### 2. 执行追踪

```matlab
[param_mt, param_map, rel_pos, res_mt, exitflag_mt, arrow_mt] = find_mt_map(mymt, mymap);
```

程序将显示微管图像，请微管**沿微管生长方向绘制线段**，完成后双击确认。

### 3. 验证与数据分析

检查追踪质量：
```matlab
check_point(mymt, param_mt)    % 查看微管末端追踪
check_point(mymap, param_map)  % 查看MAPs追踪
```

数据分析流程：
1. 删除结合事件期间追踪不准确的数据点
2. 提取`rel_pos`第一列在结合时间段内的位置数据
3. 计算这些位置数据的平均值，作为本次结合事件的最终结合位置

## 输出说明

- `rel_pos`：相对位置表格，第一列为MAPs结合时间内的位置信息
- `param_mt`, `param_map`：拟合参数
- `res_mt`, `exitflag_mt`：优化结果和退出标志
- `arrow_mt`：微管方向信息

## 注意事项

- 确保影像质量良好，对比度适中
- 绘制方向线时请尽量准确沿微管生长方向
- 建议多次运行验证结果稳定性

---

### English Version README：

# MAPs Tracking Script for Microtubule End Positions

## Overview

A MATLAB script designed to track the position information of Microtubule-Associated Proteins (MAPs) at microtubule ends, particularly suitable for analyzing single binding event dynamics.

## System Requirements

- MATLAB (R2018a or later recommended)
- Image Processing Toolbox

## Data Preparation

- Input format: Dynamic movies in TIFF format
- Movie requirement: Contains clear single binding events
- Preprocessing: Remove scale information before processing

## Quick Start

### 1. Data Import

```matlab
% Import microtubule channel and MAPs channel movies
mymt = tif_img_reader('path_to_microtubule_movie');
mymap = tif_img_reader('path_to_MAPs_movie');
```

**Note**: Ensure both channels have identical frame numbers and image dimensions.

### 2. Execute Tracking

```matlab
[param_mt, param_map, rel_pos, res_mt, exitflag_mt, arrow_mt] = find_mt_map(mymt, mymap);
```

The microtubule image will be displayed. **Draw a line along the microtubule growth direction** and double-click to confirm.

### 3. Verification and Data Analysis

Check tracking quality:
```matlab
check_point(mymt, param_mt)    % Microtubule end tracking
check_point(mymap, param_map)  % MAPs tracking
```

Data analysis workflow:
1. Remove inaccurate tracking data points during the binding event
2. Extract position data from the first column of `rel_pos` during binding timeframe
3. Calculate the average value as the final binding position for this event

## Output Description

- `rel_pos`: Relative position table, first column contains position information over time
- `param_mt`, `param_map`: Fitting parameters
- `res_mt`, `exitflag_mt`: Optimization results and exit flags
- `arrow_mt`: Microtubule direction information

## Notes

- Ensure good image quality with moderate contrast
- Draw direction lines as accurately as possible along microtubule growth direction
- Recommend multiple runs to verify result stability
