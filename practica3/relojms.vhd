library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity relojms is
port(clk : in std_logic;
	  tms : std_logic_vector(19 downto 0);
	  reloj : out std_logic);
end relojms;

architecture behavioral of relojms is
	constant fclk : integer := 50_000_000;
	signal clklms : std_logic;
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
			end  if;
		end if;
	end process;
	
	process (clklms)
		variable tiempo : std_logic_vector(19 downto 0) := X"00000";
	begin
		if rising_edge (clklms) then
			if tiempo >= tms-1 then
				tiempo := X"00000";
				reloj <= '1';
			else
				tiempo := tiempo + 1;
				reloj <= '0';
			end if;
		end if;
	end process;
end behavioral;

