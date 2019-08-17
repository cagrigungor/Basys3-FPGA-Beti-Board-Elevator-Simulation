The project has been finished according to specified instruction. No additional physical modules used. Before starting execution, passengers are placed on 8x8 led by using 4x4 keypad on BetiBoard. For execution, reset and system reset, buttons on Basys 3 are used. To observe time and direction of elevator seven segment on Basys 3 is used. To display elevator and passenger during the execution and placing passengers, 8x8 led is used. Whole execution can be observed from 8x8 led in detail.
Description of Modules
There are many System Verilog modules are created on Vivado. Each module is responsible for different part of project. They are working in harmony and there are data flow among them.

1.	ControlElevator Module
This module includes elevator algorithm to describe how elevator act on execution process. This algorithm will be explained in detail.  This module takes passenger information on floors from 4x4 modules. There are three red 2x6 matrices on 8x8 led that represents the floors and two 2x8 matrices that represents elevator as shown in figure below. Passenger is represented with just red color. Elevator is represented with both red and blue color. Red color means there is passenger in specified place, blue color means specified place is empty.  After started execution according to elevator algorithm, place of elevator and passenger number on floors and elevator changes. This module sends matrices to 8x8 led to display simultaneously so that elevator and passenger flow can be observed.
 
2. Control4x4 Module
This module uses another module inside called keypad4x4 that is given to be used 4x4 buttons. There are six buttons used on 4x4. Three of them for increases number of passenger because there are three floors to wait passenger. Others for reduces number of passengers. Until execution starts, these buttons can be used. After execution starts, these 4x4 buttons are dysfunctional. If system resets, these buttons can be used again. According to number of pressing of specific button on 4x4 buttons, creates three 2x6 matric. Each matrix represents floors on 8x8 led.  These matrices are sent to ControlElevator module to be changed and display on 8x8 led.
 
3. Control8x8 Module
This module uses another module called display_8x8 that is given as ready code to display execution. This module takes two matrices from ControlElevator module. One of these matrices is for red color. Another matric is for blue color. ControlElevator sends these matrices for each clock circle and these matrices are refreshed. Thus, data flow is provided to display execution scenario.
 
4. SevSeg_4digit Module
This module has a purpose of timing after starting execution and through its first digit, represents which direction elevator goes. For implementing these, this module controls seven segment digits on Basys3. It takes a logic from ControlElevator to show the direction. When execution starts, timer starts to count until execution finish. Moreover, this timer can be set to zero by pushing reset or system reset button on Basys3.
 
5. Debounce Module
This module is used from internet as ready code. The purpose of this module is that when the buttons on Basys3(execution, reset and system reset) are pushed, it is created only single pulse for avoiding unpredictable result.

6. MainController Module
All modules specified above are used in this module. Inputs and outputs of these module are all inputs and outputs of project that is used in constraint of project.  It has clock parameter and this parameter connects all modules so that the system works simultaneously. SevSeg_4digit module uses this clock to refresh its counter for 1 sec and refresh its direction of elevator digit for 0.25 sec. ControlElevator module uses this clock to refresh its data per 3 sec if elevator is going down and up and if elevator stops to drop off passenger, data is refreshed for 2 sec.
Details of Elevator Algorithm
This algorithm is created in ControlElevator module as stated. This algorithm does not include any Finite State Machine or High-Level State Machine. This algorithm is created in very long if-else block that includes all execution scenario. This if-else block is represented below as flow-chart. 
