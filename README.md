## [README(English version)](https://gutaozi.github.io/2022/11/06/CS211_Project_Report_Flappy_Bird/)

# CS211 数字逻辑 (H) 项目设计报告 Flappy Bird

![](https://www.android-digital.de/wp-content/uploads/flappy_bird-600x337.jpg)

## Part I. ~~团队~~成员

| 姓名 | 学号 | ~~贡献率~~ |
| ---- | ---- | ---------- |
| 咕桃 | -    | ~~100%~~   |

## Part II. 系统功能

​		在本项目中，本人基于EGO1开发板的VGA模块，使用`Verilog`语言设计了一个模仿**Flappy Bird**的小游戏项目。项目中，玩家可以通过按键控制小鸟向上跳动以通过水管的间隙来得分。项目实现了基本的用户交互界面、开始、暂停、重置等游戏功能，也添加了最高记录、调整难度、开发者模式等新特性，在保证高还原度的前提下，提供了更舒适的玩家体验。

## Part III. 系统设计

1. **工作原理**

   - **(a)** 连接显示器后按下总控重置按钮，显示器显示640\*480游戏画面，此时小鸟静止，水管在右侧“屏外”。

   - **(b)** 通过拨码开关选择难度后游戏开始，小鸟将在模拟重力和跳跃键下开始运动，同时随机高度的水管从右侧屏幕生成并向左移动，跳跃键支持短按短跳、长按连飞功能。

   - **(c)** 玩家操作小鸟通过水管后将获得一分，右侧四位数码管显示当前得分，左侧四位数码管显示最高记录，当得分突破最高记录时最高记录会自动更新。
   - **(d)** 当操作不当，小鸟与水管或地面碰撞时游戏结束，小鸟以匀速落地，水管停止运动，跳跃键和难度调整键功能被禁用，游戏结束指示LED亮起。
   - **(e)** 游戏结束后将难度调整键归零，按下restart按钮选择难度后重新开始游戏。在EGO1开发板未断开连接时，高分榜将被保留。游戏过程中将难度调整键归零可以暂停游戏。
   - **(f)** 最右侧小拨码开关设置为开发者模式，用于观察游戏难度和调试特性，开启后开发者模式指示LED亮起，小鸟将从水管层被剥离到更高维度，从水管侧面飞过而不会因撞击导致游戏结束。
   - **(g)** 游戏同时支持640\*480和800\*600两种分辨率的热切换，并且会适配不同分辨率生成适宜难度的地图。

2. **系统工作流程图**

   <img src="https://s2.loli.net/2022/08/04/tRlj5IZaWAVKTJ3.png" alt="System work flow chart" style="zoom: 67%;" />

3. **系统框图**

   <img src="https://s2.loli.net/2022/08/04/eb5SPRATqdhuMEf.png" alt="System frame diagram" style="zoom: 80%;" />

4. **端口描述**

   | 端口      | 方向 | 位宽 | 功能简介            |
   | --------- | ---- | ---- | ------------------- |
   | R         | OUT  | 4    | VGA红色信号         |
   | G         | OUT  | 4    | VGA绿色信号         |
   | B         | OUT  | 4    | VGA蓝色信号         |
   | hsync     | OUT  | 1    | 横向同步信号        |
   | vsync     | OUT  | 1    | 纵向同步信号        |
   | cho       | OUT  | 8    | 亮起数码管序列      |
   | lseg      | OUT  | 8    | 左侧数码管示数      |
   | rseg      | OUT  | 8    | 右侧数码管示数      |
   | overled   | OUT  | 1    | 游戏结束LED         |
   | stateled  | OUT  | 1    | 分辨率模式LED       |
   | cheatled  | OUT  | 1    | 开发者模式LED       |
   | rst       | IN   | 1    | 刷新显示器          |
   | restart   | IN   | 1    | 重开游戏            |
   | flap      | IN   | 1    | 跳跃键              |
   | reso      | IN   | 1    | 分辨率开关          |
   | cheatmode | IN   | 1    | 开发者模式开关      |
   | clk       | IN   | 1    | 默认时钟            |
   | sw        | IN   | 3    | 难度开关(0难度暂停) |

5. **子模块设计**

   本项目分为11个子模块，各模块之间的关系如下图所示。

   <img src="https://s2.loli.net/2022/08/04/j7Kgtlx3wiH1PD9.png" alt="submodule design" style="zoom: 33%;" />

   - **(a) Main module**

     ​		总控模块，集成各个子模块，获取时钟信号、数码管信号、坐标信息，同时负责VGA显示信号的输出、游戏难度选择、游戏结束判断、重启游戏、切换分辨率等功能，是所有输入端口和输出端口的集成模块。

   - **(b) Clock divider & clock wizard module**

     ​		分频模块，手动实现了游戏时钟分频，将EGO1开发板100MHz的时钟频率降低两百万倍得到50帧的游戏时钟频率，手动分频器的原理为：利用计数器t%2000000=0的条件输出1ns的高电平游戏时钟并归零计数器；利用clock wizard IP核实现了两种分辨率下VGA同步时钟分频，640\*480对应25.175MHz，800\*600对应40MHz。

   - **(c) Random generator module**

     ​		本随机数生成器引用自@nguthrie在`stackoverflow`社区中的回答： [ how to implement a pseudo hardware random number generator?](https://stackoverflow.com/questions/14497877)

   - **(d) Segment & Converter module**

     ​		数码管显示与转换器模块，转换器模块负责对输入的十进制得分转换为BCD码形式，进而根据参数表输出数码管序列；数码管显示模块负责从转换器模块读取序列，并通过分频显示的方式将最高分和目前得分显示于八位八段数码管。

   - **(e) Bird position module**

     ​		鸟坐标计算模块负责对输入的当前纵坐标和跳跃键信息进行处理并得到下一瞬间的纵坐标。当跳跃键按下时，鸟被给予一个向上初速度，否则鸟将受到向下的模拟重力加速度。计算坐标时为了流畅性，使用了右移位运算一定程度上模拟了小数，较好地模拟了重力。

   - **(f) Display module (is_bird & is_tube module)**

     ​		显示模块负责对输入的查询坐标和各元素位置信息进行处理，并输出查询坐标对应的颜色信息。同一坐标的显示优先级：鸟>水管>背景，`is_bird`和`is_tube`模块对输入坐标传出其与最左上角像素的相对坐标，并在显示模块中利用`Block Memory Generator` IP核取出对应的颜色值，决定优先级后输出当前查询位置的颜色。

   - **(g) Block Memory Generator**

     本项目使用此IP核连接`bird.coe`, `tube_body.coe`, `tube_head.coe`, `bg.coe`，进行鸟、水管、背景的图像显示，具体原理在帮助文档中已有详细介绍，此处不再赘述。

6. **模拟结果(波形图)**

   由于有些模块有一吨的输入输出端口，过于复杂不便模拟调试，且在开发过程中并未进行模拟过程，因此部分模块的模拟结果并未在此展示~~(实际上整个过程非常自信，没有用一次模拟)~~

   - **(a) Converter simulation**

     ![counter_sim](https://s2.loli.net/2022/08/04/l67RJGQOLdvVicT.png)

   - **(b) Random generator simulation**

     ![random_generator_sim](https://s2.loli.net/2022/08/04/5MlnNjHiLtDUqkT.png)

   - **(c) Clock divider module** (Mod factor shrunk for better simulation)

     ![clk_div_sim](https://s2.loli.net/2022/08/04/2XM1CEdf5PeFqo4.png)

   - **(d) Segment module** (Higher shifting frequency for better simulation)

     ![seg_sim](https://s2.loli.net/2022/08/04/oAEKzSFUw5aDCBd.png)

## Part IV. 开发中遇到的困难与解决方案

### **Question1**.  如何显示精美的图像而非矩形正方形？

**Reason**: 项目开发第一步，保护自己的双眼，精美的界面能让开发过程更舒适，因此我开发第一步就实现了图像显示功能。

**Solution**: 通过阅读~~隔壁边缘检测Project的~~帮助文档和向同学寻求帮助，获悉Block memory generator的用法。顺带一提，我刚实现图像显示的时候屏幕上是黑暗风的火烧云界面，用一条RGB为`12'hfff`的 检测条发现竟然是渐变色。这种现象是因为屏外未显示的部分被意外赋上了非零值，显示器把它们当作噪声减掉了，导致屏内的正常颜色发生了色差偏移。

<img src="https://s2.loli.net/2022/08/04/lVepHaoWziFyrcq.jpg" alt="A4E63FBDF6897343FF0B9C709AD6EBE5.jpg" style="zoom: 25%;" />

### **Question2**.  如何生成随机高度的水管？

**Reason**: 给游戏加点难度。

**Solution**: 从 _stackoverflow_ 社区寻求帮助,  找到的五位伪随机数生成器对我的项目来说就够用了。

### **Question3**.  怎么针对不同分辨率创建对应的地图？

**Reason**: 开发时了解到有同学在调整到高分辨率时碰到了麻烦，因此我防患于未然。

**Solution**: 用当前分辨率当作参数在模块间传递，用于代替常数来生成地图，保证了管子的高度和管子间的距离会自适应不同分辨率，也为热切换分辨率打好了基础。

### **Question4**.  怎么模拟重力？

**Reason**: 为了让跳跃过程更丝滑。

**Solution**: 使用右移位运算来模拟小数运算，引入了速度和加速度来计算鸟的坐标，并以50Hz的频率更新坐标。

### **Question5**.  如何判定游戏结束？ / 如何判定各元素显示优先级？

**Reason**: 为了优化视觉体验，鸟在创上水管的时候会徐徐落地，此时可能出现鸟和水管有重合的情况，需要判定此时该显示哪个元素。

**Solution**: 鸟>水管>背景, 有些鸟的像素是透明的，这些像素在显示的时候就该显示鸟下面的图层信息。同时，利用显示逻辑可以很轻松的判定游戏结束：当一个像素同时要显示鸟和水管的时候，那就说明鸟创上水管了，游戏结束。

<img src="https://s2.loli.net/2022/08/05/molDeZp2Fgdb6hP.jpg" alt="255B0D0A848EB7FA08864668093A2855.jpg" style="zoom:50%;" />

## Part V. 总结与感想

​		本次项目我利用本学期所学知识，基于EGO1开发板使用Verilog复现了经典小游戏Flappy Bird，项目中熟悉了VGA显示原理、数码管显示原理、状态机的转移和设计、简单游戏逻辑设计、硬件语言开发流程等内容。

​		特别感谢xjc等同学提供了若干踩坑的经验，开发过程中预防了很多问题，整个开发过程实际用时不到24h，不过我在开发过程中还是遇到了花式的问题和困难，但最终也都得到了不错的解决。同时我也为其他同学提供了多次帮助，例如屏外噪声、图像导入、分辨率切换、游戏逻辑等问题。

​		项目中最大的收获是模块化设计的思想，本次开发前我先在纸上设计好了各个模块的大致功能和模块间互相调用的关系，在实际开发时按部就班达到了很高的效率，比较java项目边写边加的模式更为从容有条理。

​		实际上，本次项目由于开发周期短(同期的数据库项目对时间占用较大)还存在较多的不足，在本学期课程结束后我会将GitHub上的项目同步并继续开发，优化界面、调整重力等参数，因为我对本项目抱有较大的兴趣，所以我会继续做下去。

​		报告的最后，非常感谢为本学期课程和项目提供指导帮助的老师、助教和图班优秀的同学们，让我从一个对硬件一无所知甚至抱有胆怯的小白变成了对硬件编程、电路设计感兴趣的人，受益匪浅。  
