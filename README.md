# FPGA
My Project about FPGA, 包含数电课内作业 和 数电实验 彩蛋机
## 项目结构
包含两个独立的Quartus项目，请分别导入
- FinaiExpr 数电综合实验-彩蛋机
  - source verilog源代码
    - module 程序模块目录
    - test 测试仿真相关文件
      - scripts 测试仿真脚本，使用vsim -do xxxx.do 执行(pwd: FinalExpr/simulate)
    - Root.v 程序主入口Root
- Quartus 数电课内实验,结构类似
  - source verilog源代码
    - module 公共功能模块
    - utils 公共工具模块
    - weeks 各周作业
    - Root.v 程序主入口Root
## 版权
所有代码均本人完成，保留许可  
仅可用于学习和研究目的，使用请注明出处。
