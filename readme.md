# ANN on FPGA Implementation 🚀

This project is based on the original work by Vipin Kizheppatt. You can find the foundational codebase at [Vipin Kizheppatt's GitHub](https://github.com/vipinkmenon/neuralNetwork/tree/master).

## 🌟 What's New?
The most notable change in this version of the code is the addition of FPGA architecture simulation capabilities on APIO, utilizing the economically friendly IceStick board as the specified environment. This enhancement allows for a more accessible entry into FPGA experimentation and learning.

### 🛠️ Enhancements Include:
- **Simulation on APIO**: Ability to simulate the FPGA architecture using simple commands:
  - `apio init -b icestick`
  - Navigate to the source directory: `cd src`
  - Run the simulation: `apio sim`
  Please ensure APIO is correctly configured in your environment before running these commands.
- **Code Commentary**: Comments have been added throughout the codebase, clarifying complex segments, especially those dealing with the handling of overflows and underflows in fixed point calculations.
- **Simplified Top-Level Simulation Script**: The top-level simulation script was a complex issue to resolve, but it's now working efficiently and has been greatly simplified for use in APIO.

## 📚 Documentation
For more detailed information about each module and their functionalities, please refer to the comments within the code files. These comments provide insights and explanations necessary for understanding and modifying the code effectively.

## 🛑 Prerequisites
- APIO installed and configured
- IceStick FPGA board

## 🚀 Getting Started
To get started with this project:
1. Clone the repository to your local machine.
2. Initialize the project environment with APIO for the IceStick board as described in the enhancements section.
3. Navigate to the `src` directory and run the simulation to see the ANN in action.

## 📚 Recommended Resources
- **Introduction to FPGA YouTube Series by Digi-Key**
  [Watch here](https://www.youtube.com/watch?v=lLg1AgA2Xoo&list=PLEBQazB0HUyT1WmMONxRZn9NmQ_9CIKhb)
- **The Complete Mathematics of Neural Networks and Deep Learning**
  [Watch here](https://www.youtube.com/watch?v=Ixl3nykKG9M&t=2321s)
- **Neural Network Implementation This Project is Based On**
  - Paper: [Read here](https://ieeexplore.ieee.org/abstract/document/8977883)
  - YouTube Series: [Watch here](https://www.youtube.com/watch?v=rw_JITpbh3k&list=PLJePd8QU_LYKZwJnByZ8FHDg5l1rXtcIq&index=1)
  - GitHub: [Visit here](https://github.com/vipinkmenon/neuralNetwork/tree/master)

## 🤖 Contributing
Contributions to this project are welcome! Whether it's enhancing the simulation capabilities, refining the code, or improving documentation, your help is appreciated. Please feel free to fork the repository and submit pull requests.

---
Happy coding! 💻🚀
