library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity comp2 is
	port( reloj : in std_logic;
			sw : std_logic;
			 display1, display2, display3, display4, display5,display6 : buffer std_logic_vector(6 downto 0)
			);
end entity;

architecture arqcomp2 of comp2 is
	signal segundo : std_logic;
	signal Q : std_logic_vector(3 downto 0) := "0000";
	signal msg1 : std_logic_vector(6 downto 0);
	signal msg2 : std_logic_vector(6 downto 0);
begin
	divisor : process(reloj)
		variable CUENTA : std_logic_vector(27 downto 0) := X"0000000";
	begin 
		if rising_edge (reloj) then
			if CUENTA = X"48009E0" then
				cuenta := X"0000000";
			else
				cuenta := cuenta +1;
			end if;
		end if;
		segundo <= CUENTA(22);
	end process;

	contador : process(segundo)
	begin
		if rising_edge(segundo) then
			Q <= Q + 1;
		end if;
	end process;
	
	
	with Q select 
		msg1 <=      "0110000" when "0000", --3--
						"1111001" when "0001", --1--
						"0100100" when "0010", --2
						"1111001" when "0011", --1--
						"1000000" when "0100", --0	
						"0110000" when "0101", --3--
						"0010000" when "0110", --9
						"1111001" when "0111", --1
						"0011001" when "1000", --4
						"1111111" when others; --Default
						
	------------------------ 312103914					
	with Q select 
		msg2 <=     "0110000" when "0000", --3--
						"1111001" when "0001", --1
						"0010010" when "0010", --5
						"0100100" when "0011", --2
						"0000000" when "0100", --8
						"0010000" when "0101", --9
						"0010010" when "0110", --5
						"0110000" when "0111", --3
						"0000000" when "1000", --8
						"0111111" when others; --espacio

----------315289538				

selector : process(segundo)
begin
	if sw = '0' then
		display1 <= msg1;
	end if;
	if sw = '1' then 
		display1 <= msg2;
	end if;
end process;

FF1 : process(segundo)
begin
	if rising_edge(segundo) then
		display2 <= display1;
	end if;
end process;

FF2 : process(segundo)
begin
	if rising_edge(segundo) then
		display3 <= display2;
	end if;
end process;

FF3 : process(segundo)
begin
	if rising_edge(segundo) then
		display4 <= display3;
	end if;
end process;

FF4 : process(segundo)
begin
	if rising_edge(segundo) then
		display5 <= display4;
	end if;
end process;

FF5 : process(segundo)
begin
	if rising_edge(segundo) then
		display6 <= display5;
	end if;
end process;

end architecture;