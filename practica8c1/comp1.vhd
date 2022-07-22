library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity comp1 is
port( clk: in std_logic;
		INICIO: in std_logic;
		baud: in std_logic_vector(2 downto 0);
		sw: in std_logic_vector(7 downto 0);
		led: out std_logic;
		TX_WIRE: out std_logic);
end entity;

architecture behavioral of comp1 is
	signal conta: integer:= 0;
	signal valor: integer:= 70000;
	signal dato: std_logic_vector(7 downto 0);
	signal PRE: integer range 0 to 5208:= 0;
	signal INDICE: integer range 0 to 9:= 0;
	signal BUFF: std_logic_vector(9 downto 0);
	signal flag: std_logic:= '0';
	signal PRE_val: integer range 0 to 41600;
	signal i: integer range 0 to 4;
	signal pulso: std_logic;
	signal contador: integer range 0 to 49999999:= 0;
	signal dato_bin: std_logic_vector(7 downto 0);
	signal hex_val: std_logic_vector(7 downto 0):= (others => '0');

begin 

	TX_divisor: process(clk)
	begin
		if rising_edge(clk) then
			contador<= contador + 1;
			if (contador < 140000) then 
				pulso <= '1';
			else
				pulso <= '0';
			end if;
		end if;
	end process TX_divisor;
	
	TX_prepara: process(clk,pulso)
	type arreglo is array (0 to 1) of std_logic_vector(7 downto 0);
	variable asc_dato: arreglo := (X"30",X"0A");
	begin
		asc_dato(0):= hex_val;
		if (pulso='1') then
			if rising_edge(clk) then
				if (conta=valor) then
					conta <= 0;
					DATO <= asc_dato(i);
					if (i = 1) then
						i<= 0;
					else
						i<= i+1;
					end if;
				else
					conta <= conta + 1;
				end if;
			end if;
		end if;
	end process TX_prepara;

	TX_envia: process(clk, INICIO,dato)
	begin
		if(clk'EVENT and clk = '1') then
			if(flag= '0' and INICIO = '0') then
				flag<= '1';
				BUFF(0) <= '0';
				BUFF(9) <= '1';
				BUFF(8 downto 1) <= dato;
			end if;
			if(flag = '1') then
				if(PRE < PRE_val) then
					PRE<= PRE + 1;
				else
					PRE<= 0;
				end if;
				if(PRE = PRE_val/2) then
					TX_WIRE <= BUFF(INDICE);
					if(INDICE < 9) then
						INDICE <= INDICE + 1;
					else
						flag <= '0';
						INDICE <= 0;
					end if;
				end if;
			end if;
		end if;
	end process TX_envia;
	
	LED <= INICIO;
	dato_bin<=SW;
	
	with(dato_bin) select
		hex_val<= X"30" when "00000000",
					 X"31" when "00000001",
					 X"32" when "00000010",
					 X"33" when "00000011",
					 X"34" when "00000100",
					 X"35" when "00000101",
					 X"36" when "00000110",
					 X"37" when "00000111",
					 X"38" when "00001000",
					 X"39" when "00001001",
					 X"41" when "00001010",
					 X"42" when "00001011",
				    X"43" when "00001100",
				    X"44" when "00001101",
				    X"45" when "00001110",
				    X"46" when "00001111",
					 X"47" when "00010000",
					 X"48" when "00010001",
					 X"49" when "00010010",
					 X"4A" when "00010011",
					 X"4B" when "00010100",
					 X"4C" when "00010101",
					 X"4D" when "00010110",
					 X"4E" when "00010111",
					 X"4F" when "00011000",
					 X"50" when "00011001",
					 X"51" when "00011010",
					 X"52" when "00011011",
					 X"53" when "00011100",
					 X"54" when "00011101",
					 X"55" when "00011110",
					 X"56" when "00011111",
				    X"23" when others;
	
	with (baud) select
		PRE_val<=41600 when "000", --1200 bauds
					  20800 when "001", --2400 bauds
					  10400 when "010", --4800 bauds
					   5200 when "011", --9600 bauds
					   2600 when "100", --19200 bauds
					   1300 when "101", --38400 bauds
						 866 when "110", --57600 bauds
						 432 when others; --115200 bauds
					  
end behavioral;