# Hardware-Accelerated Median Filtering via Parallel Shear Sort

## Overview
This project implements a high-performance **Digital Image Processing (DIP) Pipeline** designed to remove "Salt and Pepper" noise from grayscale images using Verilog HDL. The core of the system is a **Parallel Modified Shear Sort Algorithm**, which is synthesized and optimized for hardware execution on FPGAs.

The project explores the hardware trade-offs between **3x3** and **4x4** kernel sizes, providing a comparative analysis of noise-rejection capability, visual clarity, and standard hardware metrics like PSNR and MSE.

---

## Filter Architecture
The following diagram illustrates the data flow of the Median Filter, featuring the transformation from a noisy input stream to a cleaned output via the Shear Sort sorting network.

![3x3 Sliding Window Architecture]("images\3x3 sliding window.png")



---

## System Specifications
| Feature | 3x3 Kernel Implementation | 4x4 Kernel Implementation |
| :--- | :--- | :--- |
| **Algorithm** | Parallel Modified Shear Sort | Parallel Modified Shear Sort |
| **Input Data** | 9-bit Parallel Pixels (8-bit per pixel) | 16-bit Parallel Pixels (8-bit per pixel) |
| **Processing Window** | 3x3 Neighborhood | 4x4 Neighborhood |
| **Control Logic** | 4-State FSM (IDLE, LOAD, SORT, DONE) | 4-State FSM (IDLE, LOAD, SORT, DONE) |
| **Throughput** | 1 Pixel per clock cycle (post-latency) | 1 Pixel per clock cycle (post-latency) |
| **FPGA Resources** | ~252-283 Slices (Spartan 3e target) | Higher slice utilization due to 16-input sorter |

---

## Modular Components
The filtering system consists of several integrated units:

* **Virtual Line Buffer (Python):** Pre-processes 512x512 images into "sliding window" hex files to feed the hardware simulation.
* **Shear Sort Sorter:** The core computational unit. It sorts the 2D mesh using a serpentine (snake-like) pattern across rows and columns.
* **State Machine (FSM):** Manages the `start` and `done` signals to synchronize the loading of pixel data and the extraction of the median value.
* **Rank-Order Selector:** For 3x3, it extracts the 5th rank ($o_5$). For 4x4, it extracts the middle ranks to find the median.

---

## Experimental Results & Comparison
The hardware was validated using the standard **Lena** and **Cameraman** test images.

### 1. Lena Image (Moderate Noise)
| Kernel | MSE | PSNR (dB) | Observation |
| :--- | :--- | :--- | :--- |
| **3x3** | **281.66** | **23.63** | Best for detail preservation in light noise. |
| **4x4** | **350.20** | **22.69** | Slightly more aggressive; causes minor smoothing. |

### 2. Cameraman Image (High-Density Noise)
| Kernel | MSE | PSNR (dB) | Cleaning Intensity |
| :--- | :--- | :--- | :--- |
| **3x3** | **213.08** | **24.85** | 14.59 levels (Struggles with dense noise). |
| **4x4** | **666.04** | **19.90** | **24.30 levels** (Highly effective at clearing dots). |

> **Analysis:** While the 4x4 kernel has a lower PSNR, its **Cleaning Intensity (24.30)** proves it is mathematically superior at rejecting dense impulse noise that overwhelms a 3x3 window.

---

## Visual Results
Below are the comparisons of the original noisy stimulus vs. the hardware-filtered output for different kernels.

### 3x3 Shear Sort Result (Lena)
![Lena Filtered Result](./images/girl_filtered(3x3).jpg)


### 3x3 Shear Sort Result (Cameraman)
![Cameraman 4x4 Result](./images/camera_man_512_comp(3x3).jpg)


### 4x4 Shear Sort Result (Lena)
![Lena Filtered Result](./images/girl_filtered_4x4.jpg)

### 4x4 Shear Sort Result (Cameraman)
![Cameraman 4x4 Result](./images/camera_man_512_comp(4x4).jpg)

---

## How to Run
1. **Generate Stimulus:** Run the Python script to convert your image into a `.hex` file.
2. **Simulate:** Compile the Verilog files (`shear_sort_3x3.v` or `shear_sort_4x4.v`) in your preferred simulator (e.g., Vivado, ModelSim, or Icarus Verilog).
3. **Reconstruct:** Run the reconstruction script to view the filtered image and calculate hardware performance metrics.

---

## Future Extensions
* **On-Chip Line Buffers:** Integrating FIFO-based line buffers to remove the dependency on pre-processed Python hex files.
* **5x5 Kernel:** Expanding the sorting network to 25 inputs for even higher noise-density environments.
* **Adaptive Median Filter:** Implementing logic to only sort pixels identified as noise, preserving more original image detail.

## Author
**Raghul D**
* ECE Student
* Interests: Digital VLSI Design,RTL designer, FPGA Image Processing, and Processor Architecture.
