library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity comp2 is
port( clk: in std_logic;
		leds: out std_logic_vector(3 downto 0);
		baud: in std_logic_vector(2 downto 0); 
		rx_wire: in std_logic;
	   bandera: out std_logic;
		ledOn: out std_logic;
		mot: out std_logic_vector(3 downto 0));
end entity;

architecture behavioral of comp2 is
	signal BUFF: std_logic_vector(9 downto 0);
	signal flag: std_logic:= '0';
	signal PRE: integer range 0 to 41608:= 0;
	signal INDICE: integer range 0 to 9:= 0;
	signal PRE_val: integer range 0 to 41600;
	signal UD: std_logic;
	signal div: unsigned(22 downto 0);
	signal clks: std_logic;
	signal motor: std_logic_vector(3 downto 0);
	signal motorOn: std_logic := '0';
	signal auxiliar: std_logic:= '0';
	type estado is(sm0,sm1,sm2,sm3,sm4);
	signal pres_S, next_s: estado;
	
begin
	RX_dato: process(clk)
	begin
		if(clk'EVENT and clk = '1') then
			if(flag = '0' and RX_WIRE = '0') then
				flag<= '1';
				INDICE<=  0;
				PRE<= 0;
				bandera<= '1';
			end if;
			if(flag= '1') then
				BUFF(INDICE)<=RX_WIRE;
				if(PRE < PRE_val) then
					PRE <= PRE +1;
					bandera<= '1';
				else
					PRE <= 0;
					bandera<= '1';
				end if;
				if (PRE = PRE_val/2) then
					if(INDICE < 9) then
						INDICE <= INDICE +1;
						bandera<='1';
					else
						if(BUFF(0) = '0' and BUFF(9)= '1') then 
							bandera<='0';
							if buff(8 downto 1)= X"44" or buff(8 downto 1)= X"64" then
								motorOn<='1';
								UD<='1';
							elsif buff(8 downto 1)= X"49" or buff(8 downto 1)= X"69" then
								motorOn<='1';
								UD<='0';
							elsif buff(8 downto 1)= X"41" or buff(8 downto 1)= X"61" then
								motorOn<='0';
							elsif buff(8 downto 1)= X"54" or buff(8 downto 1)= X"74" then
								if auxiliar='0' then 
									ledOn<= '1';
									auxiliar<= '1';
								else
									ledOn<= '0';
									auxiliar<= '0';
								end if;
							end if;
						else
							bandera<='1';
						end if;
						flag<= '0';
					end if;
				end if;
				end if;
			end if;
					
	end process RX_dato;
	
	process (clk, motorOn)
	begin
		if motorOn = '0' then
			div<= (others => '0');
		elsif clk'event and clk= '1' then
			div<= div+1;
		end if;
	end process;
	clks<= div(21);
	
	process(clks, motorOn)
	begin
		if motorOn= '0' then
			pres_S<= sm0;
		elsif clks'event and clks='1' then
			pres_S<= next_s;
		end if;
	end process;
	
	process(pres_S, UD, motorOn)
	begin
	case(pres_S) is
			when sm0=>
						next_s<= sm1;
			when sm1=>
						if UD= '1' then 
							next_s<=sm2;
						else
							next_s<= sm4;
						end if;
			when sm2=>
						if UD= '1' then 
							next_s<=sm3;
						else
							next_s<= sm1;
						end if;
			when sm3=>
						if UD= '1' then 
							next_s<=sm4;
						else
							next_s<= sm2;
						end if;
			when sm4=>
						if UD= '1' then 
							next_s<=sm1;
						else
							next_s<= sm3;
						end if;
			when others=> next_s <= sm0;
	end case;
	end process;
									
	process(pres_S)
	begin
	case pres_S is
		when sm0 => motor <= "0000";
		when sm1 => motor <= "1000";
		when sm2 => motor <= "0100";
		when sm3 => motor <= "0010";
		when sm4 => motor <= "0001";
		when others => motor <= "0000";
	end case;
	end process;

	with (baud) select
		PRE_val<=  41600 when "000", --1200 bauds
					  20800 when "001", --2400 bauds
					  10400 when "010", --4800 bauds
					  5200 when "011", --9600 bauds
					  2600 when "100", --19200 bauds
					  1300 when "101", --38400 bauds
					  866 when "110", --57600 bauds
					  432 when others; --115200 bauds
	
	mot<= motor;
	LEDS<= motor;
					  
end behavioral;