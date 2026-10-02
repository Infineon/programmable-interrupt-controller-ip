

// New CSC: "InterruptControllerCSC"
// Bitfields: 265

#ifndef InterruptControllerCSC_265_h
#include <stdint.h>
#define InterruptControllerCSC_265_h 1

// Interface 0: "DefaultInterface"
//   Registers (Units): 48

// Interface: DefaultInterface
  // Register: "enable"
    #define enable             *(volatile uint32_t*) (0)  //0x00
    // Contained Bitfields: Position // SwRd, SwWr, HwRd, HwWr; [Size];  Default Value
    #define enable_int_0       0     //  T  ,  T  ,  T  ,  F  ;    [1];  0
    #define enable_int_1       1     //  T  ,  T  ,  T  ,  F  ;    [1];  0
    #define enable_int_2       2     //  T  ,  T  ,  T  ,  F  ;    [1];  0
    #define enable_int_3       3     //  T  ,  T  ,  T  ,  F  ;    [1];  0
    #define enable_int_4       4     //  T  ,  T  ,  T  ,  F  ;    [1];  0
    #define enable_int_5       5     //  T  ,  T  ,  T  ,  F  ;    [1];  0
    #define enable_int_6       6     //  T  ,  T  ,  T  ,  F  ;    [1];  0
    #define enable_int_7       7     //  T  ,  T  ,  T  ,  F  ;    [1];  0
    #define enable_int_8       8     //  T  ,  T  ,  T  ,  F  ;    [1];  0
    #define enable_int_9       9     //  T  ,  T  ,  T  ,  F  ;    [1];  0
    #define enable_int_10      10    //  T  ,  T  ,  T  ,  F  ;    [1];  0
    #define enable_int_11      11    //  T  ,  T  ,  T  ,  F  ;    [1];  0
    #define enable_int_12      12    //  T  ,  T  ,  T  ,  F  ;    [1];  0
    #define enable_int_13      13    //  T  ,  T  ,  T  ,  F  ;    [1];  0
    #define enable_int_14      14    //  T  ,  T  ,  T  ,  F  ;    [1];  0
    #define enable_int_15      15    //  T  ,  T  ,  T  ,  F  ;    [1];  0
    #define enable_int_16      16    //  T  ,  T  ,  T  ,  F  ;    [1];  0
    #define enable_int_17      17    //  T  ,  T  ,  T  ,  F  ;    [1];  0
    #define enable_int_18      18    //  T  ,  T  ,  T  ,  F  ;    [1];  0
    #define enable_int_19      19    //  T  ,  T  ,  T  ,  F  ;    [1];  0
    #define enable_int_20      20    //  T  ,  T  ,  T  ,  F  ;    [1];  0
    #define enable_int_21      21    //  T  ,  T  ,  T  ,  F  ;    [1];  0
    #define enable_int_22      22    //  T  ,  T  ,  T  ,  F  ;    [1];  0
    #define enable_int_23      23    //  T  ,  T  ,  T  ,  F  ;    [1];  0
    #define enable_int_24      24    //  T  ,  T  ,  T  ,  F  ;    [1];  0
    #define enable_int_25      25    //  T  ,  T  ,  T  ,  F  ;    [1];  0
    #define enable_int_26      26    //  T  ,  T  ,  T  ,  F  ;    [1];  0
    #define enable_int_27      27    //  T  ,  T  ,  T  ,  F  ;    [1];  0
    #define enable_int_28      28    //  T  ,  T  ,  T  ,  F  ;    [1];  0
    #define enable_int_29      29    //  T  ,  T  ,  T  ,  F  ;    [1];  0
    #define enable_int_30      30    //  T  ,  T  ,  T  ,  F  ;    [1];  0
    #define enable_int_31      31    //  T  ,  T  ,  T  ,  F  ;    [1];  0
  // Register: "unmask"
    #define unmask             *(volatile uint32_t*) (4)  //0x04
    // Contained Bitfields: Position // SwRd, SwWr, HwRd, HwWr; [Size];  Default Value
    #define unmask_int_0       0     //  T  ,  T  ,  T  ,  F  ;    [1];  0
    #define unmask_int_1       1     //  T  ,  T  ,  T  ,  F  ;    [1];  0
    #define unmask_int_2       2     //  T  ,  T  ,  T  ,  F  ;    [1];  0
    #define unmask_int_3       3     //  T  ,  T  ,  T  ,  F  ;    [1];  0
    #define unmask_int_4       4     //  T  ,  T  ,  T  ,  F  ;    [1];  0
    #define unmask_int_5       5     //  T  ,  T  ,  T  ,  F  ;    [1];  0
    #define unmask_int_6       6     //  T  ,  T  ,  T  ,  F  ;    [1];  0
    #define unmask_int_7       7     //  T  ,  T  ,  T  ,  F  ;    [1];  0
    #define unmask_int_8       8     //  T  ,  T  ,  T  ,  F  ;    [1];  0
    #define unmask_int_9       9     //  T  ,  T  ,  T  ,  F  ;    [1];  0
    #define unmask_int_10      10    //  T  ,  T  ,  T  ,  F  ;    [1];  0
    #define unmask_int_11      11    //  T  ,  T  ,  T  ,  F  ;    [1];  0
    #define unmask_int_12      12    //  T  ,  T  ,  T  ,  F  ;    [1];  0
    #define unmask_int_13      13    //  T  ,  T  ,  T  ,  F  ;    [1];  0
    #define unmask_int_14      14    //  T  ,  T  ,  T  ,  F  ;    [1];  0
    #define unmask_int_15      15    //  T  ,  T  ,  T  ,  F  ;    [1];  0
    #define unmask_int_16      16    //  T  ,  T  ,  T  ,  F  ;    [1];  0
    #define unmask_int_17      17    //  T  ,  T  ,  T  ,  F  ;    [1];  0
    #define unmask_int_18      18    //  T  ,  T  ,  T  ,  F  ;    [1];  0
    #define unmask_int_19      19    //  T  ,  T  ,  T  ,  F  ;    [1];  0
    #define unmask_int_20      20    //  T  ,  T  ,  T  ,  F  ;    [1];  0
    #define unmask_int_21      21    //  T  ,  T  ,  T  ,  F  ;    [1];  0
    #define unmask_int_22      22    //  T  ,  T  ,  T  ,  F  ;    [1];  0
    #define unmask_int_23      23    //  T  ,  T  ,  T  ,  F  ;    [1];  0
    #define unmask_int_24      24    //  T  ,  T  ,  T  ,  F  ;    [1];  0
    #define unmask_int_25      25    //  T  ,  T  ,  T  ,  F  ;    [1];  0
    #define unmask_int_26      26    //  T  ,  T  ,  T  ,  F  ;    [1];  0
    #define unmask_int_27      27    //  T  ,  T  ,  T  ,  F  ;    [1];  0
    #define unmask_int_28      28    //  T  ,  T  ,  T  ,  F  ;    [1];  0
    #define unmask_int_29      29    //  T  ,  T  ,  T  ,  F  ;    [1];  0
    #define unmask_int_30      30    //  T  ,  T  ,  T  ,  F  ;    [1];  0
    #define unmask_int_31      31    //  T  ,  T  ,  T  ,  F  ;    [1];  0
  // Register: "pending"
    #define pending            *(volatile uint32_t*) (8)  //0x08
    // Contained Bitfields: Position // SwRd, SwWr, HwRd, HwWr; [Size];  Default Value
    #define pending_int_0      0     //  T  ,  T  ,  T  ,  T  ;    [1];  0
    #define pending_int_1      1     //  T  ,  T  ,  T  ,  T  ;    [1];  0
    #define pending_int_2      2     //  T  ,  T  ,  T  ,  T  ;    [1];  0
    #define pending_int_3      3     //  T  ,  T  ,  T  ,  T  ;    [1];  0
    #define pending_int_4      4     //  T  ,  T  ,  T  ,  T  ;    [1];  0
    #define pending_int_5      5     //  T  ,  T  ,  T  ,  T  ;    [1];  0
    #define pending_int_6      6     //  T  ,  T  ,  T  ,  T  ;    [1];  0
    #define pending_int_7      7     //  T  ,  T  ,  T  ,  T  ;    [1];  0
    #define pending_int_8      8     //  T  ,  T  ,  T  ,  T  ;    [1];  0
    #define pending_int_9      9     //  T  ,  T  ,  T  ,  T  ;    [1];  0
    #define pending_int_10     10    //  T  ,  T  ,  T  ,  T  ;    [1];  0
    #define pending_int_11     11    //  T  ,  T  ,  T  ,  T  ;    [1];  0
    #define pending_int_12     12    //  T  ,  T  ,  T  ,  T  ;    [1];  0
    #define pending_int_13     13    //  T  ,  T  ,  T  ,  T  ;    [1];  0
    #define pending_int_14     14    //  T  ,  T  ,  T  ,  T  ;    [1];  0
    #define pending_int_15     15    //  T  ,  T  ,  T  ,  T  ;    [1];  0
    #define pending_int_16     16    //  T  ,  T  ,  T  ,  T  ;    [1];  0
    #define pending_int_17     17    //  T  ,  T  ,  T  ,  T  ;    [1];  0
    #define pending_int_18     18    //  T  ,  T  ,  T  ,  T  ;    [1];  0
    #define pending_int_19     19    //  T  ,  T  ,  T  ,  T  ;    [1];  0
    #define pending_int_20     20    //  T  ,  T  ,  T  ,  T  ;    [1];  0
    #define pending_int_21     21    //  T  ,  T  ,  T  ,  T  ;    [1];  0
    #define pending_int_22     22    //  T  ,  T  ,  T  ,  T  ;    [1];  0
    #define pending_int_23     23    //  T  ,  T  ,  T  ,  T  ;    [1];  0
    #define pending_int_24     24    //  T  ,  T  ,  T  ,  T  ;    [1];  0
    #define pending_int_25     25    //  T  ,  T  ,  T  ,  T  ;    [1];  0
    #define pending_int_26     26    //  T  ,  T  ,  T  ,  T  ;    [1];  0
    #define pending_int_27     27    //  T  ,  T  ,  T  ,  T  ;    [1];  0
    #define pending_int_28     28    //  T  ,  T  ,  T  ,  T  ;    [1];  0
    #define pending_int_29     29    //  T  ,  T  ,  T  ,  T  ;    [1];  0
    #define pending_int_30     30    //  T  ,  T  ,  T  ,  T  ;    [1];  0
    #define pending_int_31     31    //  T  ,  T  ,  T  ,  T  ;    [1];  0
  // Register: "pending_1"
    #define pending_1          *(volatile uint32_t*) (12)  //0x0c
    // Contained Bitfields: Position // SwRd, SwWr, HwRd, HwWr; [Size];  Default Value
    #define pending_NMI        0     //  T  ,  T  ,  T  ,  T  ;    [1];  0
  // Register: "active"
    #define active             *(volatile uint32_t*) (16)  //0x10
    // Contained Bitfields: Position // SwRd, SwWr, HwRd, HwWr; [Size];  Default Value
    #define active_int_0       0     //  T  ,  T  ,  T  ,  T  ;    [1];  0
    #define active_int_1       1     //  T  ,  T  ,  T  ,  T  ;    [1];  0
    #define active_int_2       2     //  T  ,  T  ,  T  ,  T  ;    [1];  0
    #define active_int_3       3     //  T  ,  T  ,  T  ,  T  ;    [1];  0
    #define active_int_4       4     //  T  ,  T  ,  T  ,  T  ;    [1];  0
    #define active_int_5       5     //  T  ,  T  ,  T  ,  T  ;    [1];  0
    #define active_int_6       6     //  T  ,  T  ,  T  ,  T  ;    [1];  0
    #define active_int_7       7     //  T  ,  T  ,  T  ,  T  ;    [1];  0
    #define active_int_8       8     //  T  ,  T  ,  T  ,  T  ;    [1];  0
    #define active_int_9       9     //  T  ,  T  ,  T  ,  T  ;    [1];  0
    #define active_int_10      10    //  T  ,  T  ,  T  ,  T  ;    [1];  0
    #define active_int_11      11    //  T  ,  T  ,  T  ,  T  ;    [1];  0
    #define active_int_12      12    //  T  ,  T  ,  T  ,  T  ;    [1];  0
    #define active_int_13      13    //  T  ,  T  ,  T  ,  T  ;    [1];  0
    #define active_int_14      14    //  T  ,  T  ,  T  ,  T  ;    [1];  0
    #define active_int_15      15    //  T  ,  T  ,  T  ,  T  ;    [1];  0
    #define active_int_16      16    //  T  ,  T  ,  T  ,  T  ;    [1];  0
    #define active_int_17      17    //  T  ,  T  ,  T  ,  T  ;    [1];  0
    #define active_int_18      18    //  T  ,  T  ,  T  ,  T  ;    [1];  0
    #define active_int_19      19    //  T  ,  T  ,  T  ,  T  ;    [1];  0
    #define active_int_20      20    //  T  ,  T  ,  T  ,  T  ;    [1];  0
    #define active_int_21      21    //  T  ,  T  ,  T  ,  T  ;    [1];  0
    #define active_int_22      22    //  T  ,  T  ,  T  ,  T  ;    [1];  0
    #define active_int_23      23    //  T  ,  T  ,  T  ,  T  ;    [1];  0
    #define active_int_24      24    //  T  ,  T  ,  T  ,  T  ;    [1];  0
    #define active_int_25      25    //  T  ,  T  ,  T  ,  T  ;    [1];  0
    #define active_int_26      26    //  T  ,  T  ,  T  ,  T  ;    [1];  0
    #define active_int_27      27    //  T  ,  T  ,  T  ,  T  ;    [1];  0
    #define active_int_28      28    //  T  ,  T  ,  T  ,  T  ;    [1];  0
    #define active_int_29      29    //  T  ,  T  ,  T  ,  T  ;    [1];  0
    #define active_int_30      30    //  T  ,  T  ,  T  ,  T  ;    [1];  0
    #define active_int_31      31    //  T  ,  T  ,  T  ,  T  ;    [1];  0
  // Register: "active_1"
    #define active_1           *(volatile uint32_t*) (20)  //0x14
    // Contained Bitfields: Position // SwRd, SwWr, HwRd, HwWr; [Size];  Default Value
    #define active_NMI         0     //  T  ,  T  ,  T  ,  T  ;    [1];  0
  // Register: "priority"
    #define priority           *(volatile uint32_t*) (24)  //0x18
    // Contained Bitfields: Position // SwRd, SwWr, HwRd, HwWr; [Size];  Default Value
    #define priority_int_0     0     //  T  ,  T  ,  T  ,  F  ;    [3];  0
    #define priority_int_1     3     //  T  ,  T  ,  T  ,  F  ;    [3];  0
    #define priority_int_2     6     //  T  ,  T  ,  T  ,  F  ;    [3];  0
    #define priority_int_3     9     //  T  ,  T  ,  T  ,  F  ;    [3];  1
    #define priority_int_4     12    //  T  ,  T  ,  T  ,  F  ;    [3];  1
    #define priority_int_5     15    //  T  ,  T  ,  T  ,  F  ;    [3];  0
    #define priority_int_6     18    //  T  ,  T  ,  T  ,  F  ;    [3];  2
    #define priority_int_7     21    //  T  ,  T  ,  T  ,  F  ;    [3];  2
    #define priority_int_8     24    //  T  ,  T  ,  T  ,  F  ;    [3];  1
    #define priority_int_9     27    //  T  ,  T  ,  T  ,  F  ;    [3];  1
  // Register: "priority_1"
    #define priority_1         *(volatile uint32_t*) (28)  //0x1c
    // Contained Bitfields: Position // SwRd, SwWr, HwRd, HwWr; [Size];  Default Value
    #define priority_int_10    0     //  T  ,  T  ,  T  ,  F  ;    [3];  3
    #define priority_int_11    3     //  T  ,  T  ,  T  ,  F  ;    [3];  3
    #define priority_int_12    6     //  T  ,  T  ,  T  ,  F  ;    [3];  2
    #define priority_int_13    9     //  T  ,  T  ,  T  ,  F  ;    [3];  2
    #define priority_int_14    12    //  T  ,  T  ,  T  ,  F  ;    [3];  4
    #define priority_int_15    15    //  T  ,  T  ,  T  ,  F  ;    [3];  4
    #define priority_int_16    18    //  T  ,  T  ,  T  ,  F  ;    [3];  3
    #define priority_int_17    21    //  T  ,  T  ,  T  ,  F  ;    [3];  3
    #define priority_int_18    24    //  T  ,  T  ,  T  ,  F  ;    [3];  5
    #define priority_int_19    27    //  T  ,  T  ,  T  ,  F  ;    [3];  5
  // Register: "priority_2"
    #define priority_2         *(volatile uint32_t*) (32)  //0x20
    // Contained Bitfields: Position // SwRd, SwWr, HwRd, HwWr; [Size];  Default Value
    #define priority_int_20    0     //  T  ,  T  ,  T  ,  F  ;    [3];  4
    #define priority_int_21    3     //  T  ,  T  ,  T  ,  F  ;    [3];  6
    #define priority_int_22    6     //  T  ,  T  ,  T  ,  F  ;    [3];  4
    #define priority_int_23    9     //  T  ,  T  ,  T  ,  F  ;    [3];  5
    #define priority_int_24    12    //  T  ,  T  ,  T  ,  F  ;    [3];  6
    #define priority_int_25    15    //  T  ,  T  ,  T  ,  F  ;    [3];  5
    #define priority_int_26    18    //  T  ,  T  ,  T  ,  F  ;    [3];  6
    #define priority_int_27    21    //  T  ,  T  ,  T  ,  F  ;    [3];  7
    #define priority_int_28    24    //  T  ,  T  ,  T  ,  F  ;    [3];  7
    #define priority_int_29    27    //  T  ,  T  ,  T  ,  F  ;    [3];  6
  // Register: "priority_3"
    #define priority_3         *(volatile uint32_t*) (36)  //0x24
    // Contained Bitfields: Position // SwRd, SwWr, HwRd, HwWr; [Size];  Default Value
    #define priority_int_30    0     //  T  ,  T  ,  T  ,  F  ;    [3];  7
    #define priority_int_31    3     //  T  ,  T  ,  T  ,  F  ;    [3];  7
  // Register: "requested"
    #define requested          *(volatile uint32_t*) (40)  //0x28
    // Contained Bitfields: Position // SwRd, SwWr, HwRd, HwWr; [Size];  Default Value
    #define requested_int_0    0     //  T  ,  F  ,  T  ,  T  ;    [1];  0
    #define requested_int_1    1     //  T  ,  F  ,  T  ,  T  ;    [1];  0
    #define requested_int_2    2     //  T  ,  F  ,  T  ,  T  ;    [1];  0
    #define requested_int_3    3     //  T  ,  F  ,  T  ,  T  ;    [1];  0
    #define requested_int_4    4     //  T  ,  F  ,  T  ,  T  ;    [1];  0
    #define requested_int_5    5     //  T  ,  F  ,  T  ,  T  ;    [1];  0
    #define requested_int_6    6     //  T  ,  F  ,  T  ,  T  ;    [1];  0
    #define requested_int_7    7     //  T  ,  F  ,  T  ,  T  ;    [1];  0
    #define requested_int_8    8     //  T  ,  F  ,  T  ,  T  ;    [1];  0
    #define requested_int_9    9     //  T  ,  F  ,  T  ,  T  ;    [1];  0
    #define requested_int_10   10    //  T  ,  F  ,  T  ,  T  ;    [1];  0
    #define requested_int_11   11    //  T  ,  F  ,  T  ,  T  ;    [1];  0
    #define requested_int_12   12    //  T  ,  F  ,  T  ,  T  ;    [1];  0
    #define requested_int_13   13    //  T  ,  F  ,  T  ,  T  ;    [1];  0
    #define requested_int_14   14    //  T  ,  F  ,  T  ,  T  ;    [1];  0
    #define requested_int_15   15    //  T  ,  F  ,  T  ,  T  ;    [1];  0
    #define requested_int_16   16    //  T  ,  F  ,  T  ,  T  ;    [1];  0
    #define requested_int_17   17    //  T  ,  F  ,  T  ,  T  ;    [1];  0
    #define requested_int_18   18    //  T  ,  F  ,  T  ,  T  ;    [1];  0
    #define requested_int_19   19    //  T  ,  F  ,  T  ,  T  ;    [1];  0
    #define requested_int_20   20    //  T  ,  F  ,  T  ,  T  ;    [1];  0
    #define requested_int_21   21    //  T  ,  F  ,  T  ,  T  ;    [1];  0
    #define requested_int_22   22    //  T  ,  F  ,  T  ,  T  ;    [1];  0
    #define requested_int_23   23    //  T  ,  F  ,  T  ,  T  ;    [1];  0
    #define requested_int_24   24    //  T  ,  F  ,  T  ,  T  ;    [1];  0
    #define requested_int_25   25    //  T  ,  F  ,  T  ,  T  ;    [1];  0
    #define requested_int_26   26    //  T  ,  F  ,  T  ,  T  ;    [1];  0
    #define requested_int_27   27    //  T  ,  F  ,  T  ,  T  ;    [1];  0
    #define requested_int_28   28    //  T  ,  F  ,  T  ,  T  ;    [1];  0
    #define requested_int_29   29    //  T  ,  F  ,  T  ,  T  ;    [1];  0
    #define requested_int_30   30    //  T  ,  F  ,  T  ,  T  ;    [1];  0
    #define requested_int_31   31    //  T  ,  F  ,  T  ,  T  ;    [1];  0
  // Register: "requested_1"
    #define requested_1        *(volatile uint32_t*) (44)  //0x2c
    // Contained Bitfields: Position // SwRd, SwWr, HwRd, HwWr; [Size];  Default Value
    #define requested_NMI      0     //  T  ,  F  ,  T  ,  T  ;    [1];  0
  // Register: "paused"
    #define paused             *(volatile uint32_t*) (48)  //0x30
    // Contained Bitfields: Position // SwRd, SwWr, HwRd, HwWr; [Size];  Default Value
    #define paused_int_0       0     //  T  ,  F  ,  T  ,  T  ;    [1];  0
    #define paused_int_1       1     //  T  ,  F  ,  T  ,  T  ;    [1];  0
    #define paused_int_2       2     //  T  ,  F  ,  T  ,  T  ;    [1];  0
    #define paused_int_3       3     //  T  ,  F  ,  T  ,  T  ;    [1];  0
    #define paused_int_4       4     //  T  ,  F  ,  T  ,  T  ;    [1];  0
    #define paused_int_5       5     //  T  ,  F  ,  T  ,  T  ;    [1];  0
    #define paused_int_6       6     //  T  ,  F  ,  T  ,  T  ;    [1];  0
    #define paused_int_7       7     //  T  ,  F  ,  T  ,  T  ;    [1];  0
    #define paused_int_8       8     //  T  ,  F  ,  T  ,  T  ;    [1];  0
    #define paused_int_9       9     //  T  ,  F  ,  T  ,  T  ;    [1];  0
    #define paused_int_10      10    //  T  ,  F  ,  T  ,  T  ;    [1];  0
    #define paused_int_11      11    //  T  ,  F  ,  T  ,  T  ;    [1];  0
    #define paused_int_12      12    //  T  ,  F  ,  T  ,  T  ;    [1];  0
    #define paused_int_13      13    //  T  ,  F  ,  T  ,  T  ;    [1];  0
    #define paused_int_14      14    //  T  ,  F  ,  T  ,  T  ;    [1];  0
    #define paused_int_15      15    //  T  ,  F  ,  T  ,  T  ;    [1];  0
    #define paused_int_16      16    //  T  ,  F  ,  T  ,  T  ;    [1];  0
    #define paused_int_17      17    //  T  ,  F  ,  T  ,  T  ;    [1];  0
    #define paused_int_18      18    //  T  ,  F  ,  T  ,  T  ;    [1];  0
    #define paused_int_19      19    //  T  ,  F  ,  T  ,  T  ;    [1];  0
    #define paused_int_20      20    //  T  ,  F  ,  T  ,  T  ;    [1];  0
    #define paused_int_21      21    //  T  ,  F  ,  T  ,  T  ;    [1];  0
    #define paused_int_22      22    //  T  ,  F  ,  T  ,  T  ;    [1];  0
    #define paused_int_23      23    //  T  ,  F  ,  T  ,  T  ;    [1];  0
    #define paused_int_24      24    //  T  ,  F  ,  T  ,  T  ;    [1];  0
    #define paused_int_25      25    //  T  ,  F  ,  T  ,  T  ;    [1];  0
    #define paused_int_26      26    //  T  ,  F  ,  T  ,  T  ;    [1];  0
    #define paused_int_27      27    //  T  ,  F  ,  T  ,  T  ;    [1];  0
    #define paused_int_28      28    //  T  ,  F  ,  T  ,  T  ;    [1];  0
    #define paused_int_29      29    //  T  ,  F  ,  T  ,  T  ;    [1];  0
    #define paused_int_30      30    //  T  ,  F  ,  T  ,  T  ;    [1];  0
    #define paused_int_31      31    //  T  ,  F  ,  T  ,  T  ;    [1];  0
  // Register: "paused_1"
    #define paused_1           *(volatile uint32_t*) (52)  //0x34
    // Contained Bitfields: Position // SwRd, SwWr, HwRd, HwWr; [Size];  Default Value
    #define paused_NMI         0     //  T  ,  F  ,  T  ,  T  ;    [1];  0
  // Register: "group_priority"
    #define group_priority     *(volatile uint32_t*) (56)  //0x38
    // Contained Bitfields:    Position // SwRd, SwWr, HwRd, HwWr; [Size];  Default Value
    #define group_priority_Group1 0     //  T  ,  T  ,  T  ,  F  ;    [2];  0
    #define group_priority_Group2 2     //  T  ,  T  ,  T  ,  F  ;    [2];  1
    #define group_priority_Group3 4     //  T  ,  T  ,  T  ,  F  ;    [2];  2
    #define group_priority_Group4 6     //  T  ,  T  ,  T  ,  F  ;    [2];  3
  // Register: "int_0_addr"
    #define int_0_addr         *(volatile uint32_t*) (60)  //0x3c
    // Contained Bitfields: Position // SwRd, SwWr, HwRd, HwWr; [Size];  Default Value
    #define addr_int_0         0     //  T  ,  T  ,  T  ,  F  ;   [32];  0
  // Register: "int_1_addr"
    #define int_1_addr         *(volatile uint32_t*) (64)  //0x40
    // Contained Bitfields: Position // SwRd, SwWr, HwRd, HwWr; [Size];  Default Value
    #define addr_int_1         0     //  T  ,  T  ,  T  ,  F  ;   [32];  0
  // Register: "int_2_addr"
    #define int_2_addr         *(volatile uint32_t*) (68)  //0x44
    // Contained Bitfields: Position // SwRd, SwWr, HwRd, HwWr; [Size];  Default Value
    #define addr_int_2         0     //  T  ,  T  ,  T  ,  F  ;   [32];  0
  // Register: "int_3_addr"
    #define int_3_addr         *(volatile uint32_t*) (72)  //0x48
    // Contained Bitfields: Position // SwRd, SwWr, HwRd, HwWr; [Size];  Default Value
    #define addr_int_3         0     //  T  ,  T  ,  T  ,  F  ;   [32];  0
  // Register: "int_4_addr"
    #define int_4_addr         *(volatile uint32_t*) (76)  //0x4c
    // Contained Bitfields: Position // SwRd, SwWr, HwRd, HwWr; [Size];  Default Value
    #define addr_int_4         0     //  T  ,  T  ,  T  ,  F  ;   [32];  0
  // Register: "int_5_addr"
    #define int_5_addr         *(volatile uint32_t*) (80)  //0x50
    // Contained Bitfields: Position // SwRd, SwWr, HwRd, HwWr; [Size];  Default Value
    #define addr_int_5         0     //  T  ,  T  ,  T  ,  F  ;   [32];  0
  // Register: "int_6_addr"
    #define int_6_addr         *(volatile uint32_t*) (84)  //0x54
    // Contained Bitfields: Position // SwRd, SwWr, HwRd, HwWr; [Size];  Default Value
    #define addr_int_6         0     //  T  ,  T  ,  T  ,  F  ;   [32];  0
  // Register: "int_7_addr"
    #define int_7_addr         *(volatile uint32_t*) (88)  //0x58
    // Contained Bitfields: Position // SwRd, SwWr, HwRd, HwWr; [Size];  Default Value
    #define addr_int_7         0     //  T  ,  T  ,  T  ,  F  ;   [32];  0
  // Register: "int_8_addr"
    #define int_8_addr         *(volatile uint32_t*) (92)  //0x5c
    // Contained Bitfields: Position // SwRd, SwWr, HwRd, HwWr; [Size];  Default Value
    #define addr_int_8         0     //  T  ,  T  ,  T  ,  F  ;   [32];  0
  // Register: "int_9_addr"
    #define int_9_addr         *(volatile uint32_t*) (96)  //0x60
    // Contained Bitfields: Position // SwRd, SwWr, HwRd, HwWr; [Size];  Default Value
    #define addr_int_9         0     //  T  ,  T  ,  T  ,  F  ;   [32];  0
  // Register: "int_10_addr"
    #define int_10_addr        *(volatile uint32_t*) (100)  //0x64
    // Contained Bitfields: Position // SwRd, SwWr, HwRd, HwWr; [Size];  Default Value
    #define addr_int_10        0     //  T  ,  T  ,  T  ,  F  ;   [32];  0
  // Register: "int_11_addr"
    #define int_11_addr        *(volatile uint32_t*) (104)  //0x68
    // Contained Bitfields: Position // SwRd, SwWr, HwRd, HwWr; [Size];  Default Value
    #define addr_int_11        0     //  T  ,  T  ,  T  ,  F  ;   [32];  0
  // Register: "int_12_addr"
    #define int_12_addr        *(volatile uint32_t*) (108)  //0x6c
    // Contained Bitfields: Position // SwRd, SwWr, HwRd, HwWr; [Size];  Default Value
    #define addr_int_12        0     //  T  ,  T  ,  T  ,  F  ;   [32];  0
  // Register: "int_13_addr"
    #define int_13_addr        *(volatile uint32_t*) (112)  //0x70
    // Contained Bitfields: Position // SwRd, SwWr, HwRd, HwWr; [Size];  Default Value
    #define addr_int_13        0     //  T  ,  T  ,  T  ,  F  ;   [32];  0
  // Register: "int_14_addr"
    #define int_14_addr        *(volatile uint32_t*) (116)  //0x74
    // Contained Bitfields: Position // SwRd, SwWr, HwRd, HwWr; [Size];  Default Value
    #define addr_int_14        0     //  T  ,  T  ,  T  ,  F  ;   [32];  0
  // Register: "int_15_addr"
    #define int_15_addr        *(volatile uint32_t*) (120)  //0x78
    // Contained Bitfields: Position // SwRd, SwWr, HwRd, HwWr; [Size];  Default Value
    #define addr_int_15        0     //  T  ,  T  ,  T  ,  F  ;   [32];  0
  // Register: "int_16_addr"
    #define int_16_addr        *(volatile uint32_t*) (124)  //0x7c
    // Contained Bitfields: Position // SwRd, SwWr, HwRd, HwWr; [Size];  Default Value
    #define addr_int_16        0     //  T  ,  T  ,  T  ,  F  ;   [32];  0
  // Register: "int_17_addr"
    #define int_17_addr        *(volatile uint32_t*) (128)  //0x80
    // Contained Bitfields: Position // SwRd, SwWr, HwRd, HwWr; [Size];  Default Value
    #define addr_int_17        0     //  T  ,  T  ,  T  ,  F  ;   [32];  0
  // Register: "int_18_addr"
    #define int_18_addr        *(volatile uint32_t*) (132)  //0x84
    // Contained Bitfields: Position // SwRd, SwWr, HwRd, HwWr; [Size];  Default Value
    #define addr_int_18        0     //  T  ,  T  ,  T  ,  F  ;   [32];  0
  // Register: "int_19_addr"
    #define int_19_addr        *(volatile uint32_t*) (136)  //0x88
    // Contained Bitfields: Position // SwRd, SwWr, HwRd, HwWr; [Size];  Default Value
    #define addr_int_19        0     //  T  ,  T  ,  T  ,  F  ;   [32];  0
  // Register: "int_20_addr"
    #define int_20_addr        *(volatile uint32_t*) (140)  //0x8c
    // Contained Bitfields: Position // SwRd, SwWr, HwRd, HwWr; [Size];  Default Value
    #define addr_int_20        0     //  T  ,  T  ,  T  ,  F  ;   [32];  0
  // Register: "int_21_addr"
    #define int_21_addr        *(volatile uint32_t*) (144)  //0x90
    // Contained Bitfields: Position // SwRd, SwWr, HwRd, HwWr; [Size];  Default Value
    #define addr_int_21        0     //  T  ,  T  ,  T  ,  F  ;   [32];  0
  // Register: "int_22_addr"
    #define int_22_addr        *(volatile uint32_t*) (148)  //0x94
    // Contained Bitfields: Position // SwRd, SwWr, HwRd, HwWr; [Size];  Default Value
    #define addr_int_22        0     //  T  ,  T  ,  T  ,  F  ;   [32];  0
  // Register: "int_23_addr"
    #define int_23_addr        *(volatile uint32_t*) (152)  //0x98
    // Contained Bitfields: Position // SwRd, SwWr, HwRd, HwWr; [Size];  Default Value
    #define addr_int_23        0     //  T  ,  T  ,  T  ,  F  ;   [32];  0
  // Register: "int_24_addr"
    #define int_24_addr        *(volatile uint32_t*) (156)  //0x9c
    // Contained Bitfields: Position // SwRd, SwWr, HwRd, HwWr; [Size];  Default Value
    #define addr_int_24        0     //  T  ,  T  ,  T  ,  F  ;   [32];  0
  // Register: "int_25_addr"
    #define int_25_addr        *(volatile uint32_t*) (160)  //0xa0
    // Contained Bitfields: Position // SwRd, SwWr, HwRd, HwWr; [Size];  Default Value
    #define addr_int_25        0     //  T  ,  T  ,  T  ,  F  ;   [32];  0
  // Register: "int_26_addr"
    #define int_26_addr        *(volatile uint32_t*) (164)  //0xa4
    // Contained Bitfields: Position // SwRd, SwWr, HwRd, HwWr; [Size];  Default Value
    #define addr_int_26        0     //  T  ,  T  ,  T  ,  F  ;   [32];  0
  // Register: "int_27_addr"
    #define int_27_addr        *(volatile uint32_t*) (168)  //0xa8
    // Contained Bitfields: Position // SwRd, SwWr, HwRd, HwWr; [Size];  Default Value
    #define addr_int_27        0     //  T  ,  T  ,  T  ,  F  ;   [32];  0
  // Register: "int_28_addr"
    #define int_28_addr        *(volatile uint32_t*) (172)  //0xac
    // Contained Bitfields: Position // SwRd, SwWr, HwRd, HwWr; [Size];  Default Value
    #define addr_int_28        0     //  T  ,  T  ,  T  ,  F  ;   [32];  0
  // Register: "int_29_addr"
    #define int_29_addr        *(volatile uint32_t*) (176)  //0xb0
    // Contained Bitfields: Position // SwRd, SwWr, HwRd, HwWr; [Size];  Default Value
    #define addr_int_29        0     //  T  ,  T  ,  T  ,  F  ;   [32];  0
  // Register: "int_30_addr"
    #define int_30_addr        *(volatile uint32_t*) (180)  //0xb4
    // Contained Bitfields: Position // SwRd, SwWr, HwRd, HwWr; [Size];  Default Value
    #define addr_int_30        0     //  T  ,  T  ,  T  ,  F  ;   [32];  0
  // Register: "int_31_addr"
    #define int_31_addr        *(volatile uint32_t*) (184)  //0xb8
    // Contained Bitfields: Position // SwRd, SwWr, HwRd, HwWr; [Size];  Default Value
    #define addr_int_31        0     //  T  ,  T  ,  T  ,  F  ;   [32];  0
  // Register: "NMI_addr"
    #define NMI_addr           *(volatile uint32_t*) (188)  //0xbc
    // Contained Bitfields: Position // SwRd, SwWr, HwRd, HwWr; [Size];  Default Value
    #define addr_NMI           0     //  T  ,  T  ,  T  ,  F  ;   [32];  0

#endif


