library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity Mux4disp is 
Port ( CLK : in std_logic;
		 D0 : in std_logic_vector (3 downto 0);
		 D1 : in std_logic_vector (3 downto 0);
		 D2 : in std_logic_vector (3 downto 0);
		 D3 : in std_logic_vector (3 downto 0);
		 AN : out std_logic_vector (3 downto 0);
		 L : out std_logic_vector (6 downto 0));
end Mux4disp; 

architecture mux of Mux4disp is
	signal segundo : std_logic;
	signal Qr		: std_logic_vector(1 downto 0);
	signal Qs 		: std_logic_vector(6 downto 0);
begin 
	divisor : process (CLK)
		variable CUENTA: STD_LOGIC_VECTOR(27 downto 0) := X"0000000";
	begin 
		if rising_edge (CLK) then
			if CUENTA =X"48009E" then
				CUENTA := X"0000000";
			else
				CUENTA := CUENTA + 1;
			end if;
		end if;
		segundo <= CUENTA(10);
	end process;
	
	CONTRAPID: process (segundo)
		variable CUENTA: STD_LOGIC_VECTOR(1 downto 0) := "00";
	begin 
		if rising_edge (segundo) then 
			CUENTA := CUENTA + 1; 
		end if; 
		Qr <= CUENTA;
	end process; 
	
	seledisplay: process (Qr)
	BEGIN 
		case Qr is 
			when "00" => AN <= "1110";
					Qs<="1111001";
			when "01" => AN <= "1101";
					Qs<="0100100";
			when "10" => AN <= "1011";
					Qs<="0110000";
			when others => AN <= "0111";
					Qs<="0011001";
		end case; 
	end process;	
		
	L<=Qs;	
end; 