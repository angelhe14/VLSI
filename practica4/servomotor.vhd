library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity servomotor is 
port (
	clk: in std_logic;
	pini: in std_logic;
	pfin: in std_logic;
	inc: in std_logic;
	dec: in std_logic;
	control: out std_logic
);
end servomotor;

architecture behavioral of servomotor is
	component divisor is
	port (
		clk: in std_logic;
		div_clk: out std_logic
	);
	end component;
	component pwm is
	port (
		reloj: in std_logic;
		d: in std_logic_vector(15 downto 0);
		s: out std_logic
	);
	end component;
	signal reloj: std_logic;
	signal ancho: std_logic_vector(15 downto 0):= X"0CCE";
begin
	u1: divisor port map (clk, reloj);
	u2: pwm port map (reloj, ancho, control);
	
	process(reloj,pini,pfin,inc,dec)
		variable valor: std_logic_vector(15 downto 0):= X"0CCE";
		variable cuenta: integer range 0 to 1023:=0;
	begin
		if reloj = '1' and reloj' event then
			if cuenta > 0 then 
				cuenta := cuenta - 1;
			else
				if pini = '1' then
					valor := X"0CCD";
				elsif pfin = '1' then
					valor := X"199A";
				elsif inc = '1' and valor <X"199A" then
					valor := valor + 1;
				elsif dec = '1' and valor > X"0CCD" then
					valor := valor - 1;
				end if;
				cuenta := 1023;
				ancho <= valor;
			end if;
		end if;
	end process;
end behavioral;