library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity reldig is
port(reloj: in std_logic;
	  d1,d2,d3,d4: out std_logic_vector(6 downto 0));
end reldig;

architecture behavioral of reldig is
	signal segundo: std_logic;
	signal rapido: std_logic;
	signal n: std_logic;
	signal Qs: std_logic_vector(3 downto 0);
	signal Qum: std_logic_vector(3 downto 0);
	signal Qdm: std_logic_vector(3 downto 0);
	signal e: std_logic;
	signal Qr: std_logic_vector(1 downto 0);
	signal Quh: std_logic_vector(3 downto 0);
	signal Qdh: std_logic_vector(3 downto 0);
	signal z: std_logic;
	signal u: std_logic;
	signal d: std_logic;
	signal reset: std_logic;

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
	
	UNIDADES: process(segundo)
	 variable CUENTA: STD_LOGIC_VECTOR(3 downto 0) := "0000";
	begin 
		if rising_edge(segundo) then
			if CUENTA ="1001" then
				CUENTA :="0000";
				N<= '1';
			else
				CUENTA := CUENTA + 1;
				N <= '0';
				end if;
			end if;
			Qum <= CUENTA;
		end process;
	
	DECENAS: process (N)
		variable CUENTA: STD_LOGIC_VECTOR(3 downto 0) := "0000";
	begin
		if rising_edge (N) then
			if CUENTA = "0101" then
				CUENTA:= "0000";
				E<= '1';
			else 
				CUENTA := CUENTA +1;
				e <= '0';
			end if;
		end if;
		Qdm <= CUENTA;
	end process;
	
	HoraU: Process(E, reset)
		variable cuenta: std_logic_vector(3 downto 0):="0000";
	begin
		if rising_edge(E) then 
			if cuenta= "1001" then
				cuenta:= "0000";
				Z<='1';
			else
				cuenta:=cuenta+1;
				Z<='0';
			end if;
		end if;
		if reset = '1' then 
			cuenta:="0000";
		end if;
		Quh<=cuenta;
		--U<=cuenta(2);
	end process;
	
	HoraD: process(Z, reset)
		variable cuenta: std_logic_vector(3 downto 0):="0000";
	begin
		if rising_edge(Z) then
			if cuenta="0010" then
				cuenta:= "0000";
			else
				cuenta:= cuenta+1;
			end if;
		end if;
		if reset='1' then
			cuenta:="0000";
		end if;
		Qdh<=cuenta;
		--D<=cuenta(1);
	end process;
	
	
	with Qum select
		d1<= "1000000" when "0000",
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
	
	with Qdm select
		d2<= "1000000" when "0000",
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

	with Quh select
		d3<= "1000000" when "0000",
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
			 
	with Qdh select
		d4<= "1000000" when "0000",
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