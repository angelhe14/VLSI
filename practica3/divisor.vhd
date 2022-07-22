library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity divisor is
port(clk : in std_logic;
	  div_clk, div_clk2 : out std_logic);
end divisor;

architecture behavioral of divisor is
begin
	process(clk)
	constant N : integer := 24;
	variable cuenta : std_logic_vector (27 downto 0) := X"0000000";
	begin
		if rising_edge (clk) then
			cuenta := cuenta + 1;
		end if;
		div_clk <= cuenta (N);
	end process;

	process(clk)
	constant O : integer := 22;
	variable cuenta2 : std_logic_vector (27 downto 0) := X"0000000";
	begin
		if rising_edge (clk) then
			cuenta2 := cuenta2 + 1;
		end if;
		div_clk2 <= cuenta2 (O);
	end process;
	
end behavioral;
	
	