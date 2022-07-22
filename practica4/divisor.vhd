library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity divisor is 
port (
	clk: in std_logic;
	div_clk: out std_logic
);
end divisor;

architecture behavioral of divisor is 
begin
	process(clk)
		constant n: integer := 3;
		variable cuenta: std_logic_vector(27 downto 0) := X"0000000";
	begin
		if rising_edge (clk) then
			cuenta := cuenta + 1;
		end if;
		div_clk <= cuenta(n);
	end process;
end behavioral;
--Periodo de la señal de salida en funcion del valor N para clk=50MHz:
--27 - 5.37s, 26-68s, 25 - 1.34s, 24-671ms,
--22 168ms, 21 - 83.9ms, 20-41.9ms