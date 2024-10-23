------------------------------------------------------------------------
-- Engineer:    Dalmasso Loic
-- Create Date: 07/10/2024
-- Module Name: SCCBMaster
-- Description:
--      Serial Camera Control Bus (SCCB) Master Controller for OV7670 Camera Module.
--		Supports:
--			- Write Mode: 3-Phase Write Transmission
--			- Read Mode: 2-Phase Write Transmission, then 2-Phase Read Transmission
--
-- WARNING: /!\ Require Pull-Up on SCL and SDA pins /!\
--
-- Usage:
--		1. Set the inputs (keep unchanged until Ready signal is de-asserted)
--			* Mode (Read/Write)
--			* SCCB Slave Addresss
--			* Register Address
--			* Register Value (Write Mode only)
--		2. Asserts Start input (available only when the SCCB Master is Ready)
--		3. SCCB Master de-asserts the Ready signal
--		4. SCCB Master re-asserts the Ready signal at the end of transmission (master is ready for a new transmission)
--		5. In Read mode only, the read value is available when its validity signal is asserted
--
-- Generics
--		Input	-	input_clock: Module Input Clock Frequency
--		Output	-	sccb_clock: SCCB Serial Clock Frequency
-- Ports
--		Input 	-	i_clock: Module Input Clock
--		Input 	-	i_mode: Read or Write Mode ('0': Write, '1': Read)
--		Input 	-	i_slave_addr: Address of the SCCB Slave (7 bits)
--		Input 	-	i_reg_addr: Address of the Register to Read/Write
--		Input 	-	i_reg_value: Value of the Register to Write
--		Input 	-	i_start: Start SCCB Transmission ('0': No Start, '1': Start)
--		Output 	-	o_ready: Ready State of SCCB Master ('0': Not Ready, '1': Ready)
--		Output 	-	o_read_value_valid: Validity of value of the SCCB Slave Register ('0': Not Valid, '1': Valid)
--		Output 	-	o_read_value: Value of the SCCB Slave Register
--		Output 	-	o_scl: SCCB Serial Clock ('0'-'Z'(as '1') values, working with Pull-Up)
--		In/Out 	-	io_sda: SCCB Serial Data ('0'-'Z'(as '1') values, working with Pull-Up)
------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Testbench_SCCBMaster is
end Testbench_SCCBMaster;

architecture Behavioral of Testbench_SCCBMaster is

COMPONENT SCCBMaster is

GENERIC(
	input_clock: INTEGER := 12_000_000;
	sccb_clock: INTEGER := 100_000
);

PORT(
	i_clock: IN STD_LOGIC;
	i_mode: IN STD_LOGIC;
	i_slave_addr: IN STD_LOGIC_VECTOR(6 downto 0);
	i_reg_addr: IN STD_LOGIC_VECTOR(7 downto 0);
	i_reg_value: IN STD_LOGIC_VECTOR(7 downto 0);
	i_start: IN STD_LOGIC;
	o_ready: OUT STD_LOGIC;
	o_read_value_valid: OUT STD_LOGIC;
	o_read_value: OUT STD_LOGIC_VECTOR(7 downto 0);
	o_scl: OUT STD_LOGIC;
	io_sda: INOUT STD_LOGIC
);

END COMPONENT;

signal clock_12M: STD_LOGIC := '0';
signal mode: STD_LOGIC := '0';
signal slave_addr: STD_LOGIC_VECTOR(6 downto 0):= (others => '0');
signal reg_addr: STD_LOGIC_VECTOR(7 downto 0):= (others => '0');
signal reg_value: STD_LOGIC_VECTOR(7 downto 0):= (others => '0');
signal start: STD_LOGIC := '0';
signal ready: STD_LOGIC := '0';
signal read_value_valid: STD_LOGIC := '0';
signal read_value: STD_LOGIC_VECTOR(7 downto 0):= (others => '0');
signal scl: STD_LOGIC := '0';
signal sda: STD_LOGIC := '0';
signal sda_read: STD_LOGIC := '0';

begin

-- Clock 12 MHz
clock_12M <= not(clock_12M) after 41.6667 ns;

-- Start Trigger
start <= '1', '0' after 2.5 us, '1' after 4.5 us, '0' after 4.8 us, '1' after 10 us, '0' after 10.2 us, '1' after 601 us, '0' after 601.1 us;

-- SCCB Operation Mode (Write then Read)
mode <= '0', '1' after 600 us;

-- Slave Addr
slave_addr <= "0100001";

-- Register Addr
reg_addr <= X"18";

-- Register Value (Write Only)
reg_value <= X"58";

-- SDA Input Value
sda_read <= 	'Z',
    			'1' after 920.049027 us,
				'1' after 930.049107 us,
				'0' after 940.049187 us,
				'0' after 950.049267 us,
				'1' after 960.049347 us,
				'1' after 970.049427 us,
				'1' after 980.049507 us,
				'0' after 990.049587 us,
				'Z' after 1000.049667 us;
sda <= 'Z' when mode = '0' else sda_read;

uut: SCCBMaster port map(
	i_clock => clock_12M,
	i_mode => mode,
	i_start=> start,
	i_slave_addr => slave_addr,
	i_reg_addr => reg_addr,
	i_reg_value => reg_value,
	o_ready => ready,
	o_read_value_valid => read_value_valid,
	o_read_value => read_value,
	o_scl => scl,
	io_sda => sda);

end Behavioral;