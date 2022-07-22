library ieee;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity colores is
port (clk: in std_logic;
ROJO,VERDE,AZUL: out std_logic
) ;
end colores;

architecture Behavioral of colores is

	component divisor is
	Generic(N: integer := 24);
	port (clk: in std_logic;
			div_clk: out std_logic);
	end component;
	
	component PWM is
	port (reloj: in std_logic;
			D: in std_logic_vector (7 downto 0);
			S: out std_logic);
	end component;
	
signal relojPWM: std_logic;
signal relojCiclo: std_logic;
signal R1: std_logic_vector (7 downto 0);
signal V1: std_logic_vector (7 downto 0);
signal A1: std_logic_vector (7 downto 0);

begin
D1: divisor generic map (10) port map (clk, relojPWM);
D2: divisor generic map (23) port map (clk, relojCiclo);
P1: PWM port map (relojPWM, R1, ROJO);
P2: PWM port map (relojPWM, V1, VERDE);
P3: PWM port map (relojPWM, A1, AZUL);

	process (relojCiclo)
	variable cuenta : integer range 1 to 8 := 1;
	begin
		if relojCiclo = '1' and relojCiclo'event then
			if cuenta=1 then
				R1 <= X"FF";
				V1 <= X"00";
				A1 <= X"00";
			elsif cuenta = 2 then
				R1 <= X"FF";
				V1 <= X"20";
				A1 <= X"00";
			elsif cuenta = 3 then
				R1 <= X"00";
				V1 <= X"FF";
				A1 <= X"00";
			elsif cuenta = 4 then
				R1 <= X"00";
				V1 <= X"00";
				A1 <= X"FF";
			elsif cuenta = 5 then
				R1 <= X"00";
				V1 <= X"0F";
				A1 <= X"00";
			elsif cuenta = 6 then
				R1 <= X"78";
				V1 <= X"28";
				A1 <= X"8C";
			elsif cuenta = 7 then
				R1 <= X"00";
				V1 <= X"FF";
				A1 <= X"FF";
			end if ;
		if cuenta=8 then
			cuenta := 1;
		else
			cuenta := cuenta+1;
		end if;
		end if;
	end process;

end Behavioral ;