library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RX is
port( clk: in std_logic;
		leds: out std_logic_vector(7 downto 0);
		rx_wire: in std_logic);
end entity;

architecture behavioral of RX is
	signal BUFF: std_logic_vector(9 downto 0);
	signal flag: std_logic:= '0';
	signal PRE: integer range 0 to 5208:= 0;
	signal INDICE: integer range 0 to 9:= 0;
	signal PRE_val: integer range 0 to 41600;
	signal baud: std_logic_vector(2 downto 0);
	
begin
	RX_dato: process(clk)
	begin
		if(clk'EVENT and clk = '1') then
			if(flag = '0' and RX_WIRE = '0') then
				flag<= '1';
				INDICE<=  0;
				PRE<= 0;
			end if;
			if(flag= '1') then
				BUFF(INDICE)<=RX_WIRE;
				if(PRE < PRE_val) then
					PRE <= PRE +1;
				else
					PRE <= 0;
				end if;
				if (PRE = PRE_val/2) then
					if(INDICE < 9) then
						INDICE <= INDICE +1;
					else
						if(BUFF(0) = '0' and BUFF(9)= '1') then 
							LEDS <= BUFF(8 downto 1);
						else
							LEDS <= "00000000";
						end if;
						flag <= '0';
					end if;
				end if;
			end if;
		end if;
	end process RX_dato;
	
	baud<="011";
	with (baud) select
		PRE_val<=  41600 when "000", --1200 bauds
					  20800 when "001", --2400 bauds
					  10400 when "010", --4800 bauds
					   5200 when "011", --9600 bauds
					   2600 when "100", --19200 bauds
					   1300 when "101", --38400 bauds
						 866 when "110", --57600 bauds
						 432 when others; --115200 bauds
					  
end behavioral;