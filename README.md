# Serial Camera Control Bus (SCCB) Master Controller (for OV7670 Camera Module)

This module implements the OmniVision Serial Camera Control Bus (SCCB) protocol used by the OV7670 Camera. This module supports:
- Write Mode (3-Phase Write Transmission)
- Read Mode (2-Phase Write Transmission, then 2-Phase Read Transmission)

**/!\ Require Pull-Up on SCL and SDA pins /!\ **

![IMG_0567](https://github.com/user-attachments/assets/6e2f0ceb-f834-4dc9-899e-e39ee4fc1b29)


## Usage
1. Set the inputs (mode, Slave address, register address, register value) (keep unchanged until Ready signal is de-asserted)
2. Asserts Start input (available only when the SCCB Master is Ready).
3. SCCB Master de-asserts the Ready signal
4. SCCB Master re-asserts ths Ready signal at the end of transmission (the master is ready for a new transmission)
5. In Read mode only, the read value is available when its validity signal is asserted

## Pin Description

### Generics

| Name | Description |
| ---- | ----------- |
| input_clock | Module Input Clock Frequency |
| sccb_clock | SCCB Serial Clock Frequency |

### Ports

| Name | Type | Description |
| ---- | ---- | ----------- |
| i_clock | Input | Module Input Clock |
| i_mode | Input | Read or Write Mode ('0': Write, '1': Read) |
| i_slave_addr | Input | Address of the SCCB Slave (7 bits) |
| i_reg_addr | Input | Address of the Register to Read/Write |
| i_reg_value | Input | Value of the Register to Write |
| i_start | Input | Start SCCB Transmission ('0': No Start, '1': Start) |
| o_ready | Output | Ready State of SCCB Master ('0': Not Ready, '1': Ready) |
| o_read_value_valid | Output | Validity of value of the SCCB Slave Register ('0': Not Valid, '1': Valid) |
| o_read_value | Output | Value of the SCCB Slave Register |
| o_scl | Output | SCCB Serial Clock ('0'-'Z'(as '1') values, working with Pull-Up) |
| io_sda | InOut | SCCB Serial Data ('0'-'Z'(as '1') values, working with Pull-Up) |
