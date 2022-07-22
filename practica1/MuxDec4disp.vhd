library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity MuxDec4disp is
port(reloj: in std_logic;
	  D0,D1,D2,D3: in std_logic_vector(3 downto 0);
	  A: out std_logic_vector(3 downto 0);
	  L: out std_logic_vector(6 downto 0));
end MuxDec4disp;

architecture behavioral of MuxDec4disp is
	signal segundo: std_logic;
	signal rapido: std_logic;
	signal Qs: std_logic_vector(3 downto 0);
	signal Qr: std_logic_vector(1 downto 0);

begin
	divisor: process(reloj)
		variable CUENTA: STD_LOGIC_VECTOR(27 downto 0) := X"0000000";
	begin
		if rising_edge(reloj) then 
			if CUENTA = X"48009E0" then
				CUENTA := X"0000000";
			else 
				CUENTA:= CUENTA + 1;
			end if;
		end if;
		segundo <= CUENTA(22);
		rapido <= CUENTA(10);
	end process;


	CONTRAPID: process (rapido)
		variable CUENTA: STD_LOGIC_VECTOR(1 downto 0) := "00";
	begin
		if rising_edge (rapido) then 
			CUENTA := CUENTA +1;
		end if;
		Qr <= CUENTA;
	end process;
	
	MUXY: PROCESS (Qr)
	begin
		if Qr = "00" then
			Qs <= D0;
		elsif Qr = "01" then
			Qs <= D1;
		elsif Qr = "10" then
			Qs <= D2;
		elsif Qr = "11" then
			Qs <= D3;
		end if;
	end process;
	
	seledisplay: process(Qr)
	begin
		case Qr is
			when "00" =>
				A<= "1110";
			when "01" =>
				A<= "1101";
			when "10" =>
				A<= "1011";
			when others =>
				A<= "0111";
		end case;
	end process;
	
	with Qs select
		L<= "1000000" when "0000",
			 "1111001" when "0001",
			 "0100100" when "0010",
			 "0110000" when "0011",
			 "0011001" when "0100",
			 "0010010" when "0101",
			 "0000010" when "0110",
			 "1111000" when "0111",
			 "0000000" when "1000",
			 "0010000" when "1001",
			 "1000000" when others;
			 
end behavioral;