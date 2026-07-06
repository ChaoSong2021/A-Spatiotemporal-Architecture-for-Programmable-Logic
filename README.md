# A Spatiotemporal Architecture for Programmable Logic


> This repository contains the official MATLAB implementations, theoretical simulations, BNN training scripts, and physical hardware experimental data for the paper:

> **Title:** A Spatiotemporal Architecture for Programmable Logic 
> **Authors:** Chao Song, Xiaowen Li, Ruiliang Fang, and Hanqing Jiang*

---

## 📄 Abstract
> The growing complexity of machine intelligence and advanced computing systems demands a highly efficient and adaptable hardware architecture. Conventional programmable logic relies on the assumption that functions must be explicitly stored and routed, treating logic as a predefined object. However, such static predefinition is fundamentally unnecessary and inherently limits systemic adaptability. Here, we present a conceptually distinct architecture in which computation intrinsically emerges from locally distributed update rules, bypassing the need for complex global routing and predefined circuit structures. This paradigm enables true spatiotemporal programmability, allowing a single, compact physical region to perform multiple distinct logic functions over successive time steps. We demonstrate universal Boolean logic, combinational circuits, and a binary neural network within a unified system. By establishing a substrate-independent computing framework for programmable logic, our work paves the way for next-generation, highly adaptive neuro-inspired hardware and resource-efficient intelligent systems.

---

## 🛠️ Overview & System Requirements

This repository provides a complete workflow for simulating logic-to-circuit conversion, dynamic evolution via Cellular Automata (CA), binarized neural network (BNN) classification on the MNIST dataset, and time-domain hardware experimental validation.

### Prerequisites
* **MATLAB**: Version R2020a or later (R2021a+ is strongly recommended for optimal `heatmap` rendering and font formatting).
* **Toolboxes**: Statistics and Machine Learning Toolbox (required for `confusionmat` and statistical evaluations).

---

## 📂 Repository Structure

Please ensure that all `.m` scripts, `.mat` data files, and raw MNIST binary files are placed in the **same working directory**:

```text
├── 📄 README.md                           # This document
│
├── 🧠 1. Logic Conversion & Cellular Automata
│   └── combinational_logic.m              # Converts logic expressions to Lego-like circuit diagrams and simulates CA dynamic evolution
│
├── 🖥️ 2. BNN Classification & Visualization
│   ├── BNN_all_two_groups_compares.m      # Reads MNIST dataset and performs exhaustive training for all 45 digit pairs
│   ├── numberPairs_b_and_accuracy.mat     # Pre-trained results (optimal weights b1~b4 and accuracies for all pairs)
│   └── plot_numberPairs_accuracy.m        # Plots the customized accuracy heatmap and confusion matrix from pre-trained data
│
├── ⚡ 3. Hardware Experimental Validation
    ├── plot_voltage_signals_time_domain.m # Plots time-domain voltage waveforms (S0~S4) with interval highlights
    ├── S0.mat                             # Experimental hardware data: T = 0
    ├── S1.mat                             # Experimental hardware data: T = 1
    ├── S2.mat                             # Experimental hardware data: T = 2
    ├── S3.mat                             # Experimental hardware data: T = 3
    └── S4.mat                             # Experimental hardware data: T = 4


---


## 📊 Dataset Source

The handwritten digit images used for model evaluation are obtained from the standard **MNIST Database** created by Yann LeCun, Corinna Cortes, and Christopher J.C. Burges. It consists of 60,000 training samples and 10,000 testing samples of $28 \times 28$ grayscale digits ($0 \sim 9$). 

The original, unmodified IDX binary files are included in this repository to ensure seamless offline execution. For more technical details and historical context, please visit the [Official MNIST Website](http://yann.lecun.com/exdb/mnist/).

> **Reference:** LeCun, Y., et al. (1998). "Gradient-based learning applied to document recognition." *Proceedings of the IEEE*, 86(11):2278-2324.
