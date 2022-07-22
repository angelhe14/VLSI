library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity pwm is
port(
	reloj: in std_logic;
	d: in std_logic_vector(15 downto 0);
	s: out std_logic
);
end pwm;

architecture behavioral of pwm is 
begin
	process(reloj)
		variable cuenta: integer range 0 to 65535 := 0;
	begin
		if reloj = '1' and reloj' event then 
			cuenta := (cuenta + 1) mod 65536;
			if cuenta < d then 
				s <= '1';
			else 
				s <= '0';
			end if;
		end if;
	end process;
end behavioral;