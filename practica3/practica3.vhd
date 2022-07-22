library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity practica3 is
port(clk : in std_logic;
	  start : in std_logic;
	  tms : std_logic_vector(19 downto 0);
	  P : out std_logic);
end practica3;

architecture behavioral of practica3 is
	constant fclk : integer := 50_000_000;
	signal clklms : std_logic;
	signal previo : std_logic := '0';
begin
	process (clk)
		variable cuenta: integer := 0;
	begin
		if rising_edge (clk) then
			if cuenta >= fclk/1000-1 then
				cuenta := 0;
				clklms <= '1';
			else
				cuenta := cuenta + 1;
				clklms <= '0';
			end if;
		end if;
	end process;
	
	process (clklms, start)
		variable cuenta : std_logic_vector (19 downto 0) := X"00000";
		variable contando : bit := '0';
	begin
		if rising_edge(clklms) then 
			if contando = '0' then
				if start /= previo and start = '1' then
					cuenta := X"00000";
					contando := '1';
					P <= '1';
				else
					P <= '0';
				end if;
			else
				cuenta := cuenta + 1;
				if cuenta < tms then
					P <= '1';
				else 
					P <= '0';
					contando := '0';
				end if;
			end if;
			previo <= start;
		end if;
	end process;
end behavioral;

	