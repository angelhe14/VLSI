library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity practica7 is 
	port( clk: in std_logic;
			sensor_disp: out std_logic;
			sensor_eco: in std_logic;
			anodos: out std_logic_vector (3 downto 0);
			segmentos: out std_logic_vector(7 downto 0));
end practica7;

architecture behavioral of practica7 is 
	signal cuenta: unsigned(16 downto 0) := (others => '0');
	signal centimetros: unsigned(15 downto 0) := (others => '0');
	signal centimetros_unid: unsigned(3 downto 0) := (others => '0');
	signal centimetros_dece: unsigned(3 downto 0) := (others => '0');
	signal sal_unid: unsigned(3 downto 0) := (others => '0');
	signal sal_dece: unsigned(3 downto 0) := (others => '0');
	signal digito: unsigned(3 downto 0) := (others => '0');
	signal eco_pasado: std_logic := '0';
	signal eco_sinc: std_logic := '0';
	signal eco_nsinc: std_logic := '0';
	signal espera: std_logic := '0';
	signal siete_seg_cuenta: unsigned(15 downto 0) := (others => '0');

begin 
	anodos (1 downto 0)<="11";
	siete_seg:process(clk)
	begin
		if rising_edge (clk) then
			if siete_seg_cuenta(siete_seg_cuenta'high)='1' then
				digito <= sal_unid;
				anodos(3 downto 2)<="01";
			else
				digito <= sal_dece;
				anodos (3 downto 2) <= "10";
			end if;
				siete_seg_cuenta <= siete_seg_cuenta +1;
		end if;
	end process;

	trigger: process(clk)
	begin 
		if rising_edge(clk) then
				if espera = '0' then 
					if cuenta = 500 then 
						sensor_disp <= '0';
						espera <= '1';
						cuenta <= (others => '0');
					else
						sensor_disp <= '1';
						cuenta <= cuenta + 1;
					end if;
				elsif eco_pasado = '0' and eco_sinc = '1' then
					cuenta <= (others => '0');
					centimetros <= (others => '0');
					centimetros_unid <= (others => '0');
					centimetros_dece <= (others => '0');
				elsif eco_pasado = '1' and eco_sinc = '0' then 
					sal_unid <= centimetros_unid;
					sal_dece <= centimetros_dece;
				elsif cuenta = 2900-1 then
					if centimetros_unid = 9 then
						centimetros_unid <= (others => '0');
						centimetros_dece <= centimetros_dece + 1;
					else
						centimetros_unid <= centimetros_unid + 1;
					end if;
					centimetros <= centimetros + 1;
					cuenta<= (others => '0');
					if centimetros = 3448 then	
						espera <= '0';
					end if;
				else
					cuenta <= cuenta + 1;
				end if;
			eco_pasado<= eco_sinc;
			eco_sinc<= eco_nsinc;
			eco_nsinc <= sensor_eco;
			end if;
	end process;

	Decodificador: process (digito)
	begin
		if    digito=X"0" then segmentos <= X"81";--G F E D C B A dp
		elsif digito=X"1" then segmentos <= X"F3";
		elsif digito=X"2" then segmentos <= X"49";
		elsif digito=X"3" then segmentos <= X"61";
		elsif digito=X"4" then segmentos <= X"33";
		elsif digito=X"5" then segmentos <= X"25";
		elsif digito=X"6" then segmentos <= X"05";
		elsif digito=X"7" then segmentos <= X"F1";
		elsif digito=X"8" then segmentos <= X"01";
		elsif digito=X"9" then segmentos <= X"21";
		elsif digito=X"a" then segmentos <= X"11";
		elsif digito=X"b" then segmentos <= X"07";
		elsif digito=X"c" then segmentos <= X"8D";
		elsif digito=X"d" then segmentos <= X"43";
		elsif digito=X"e" then segmentos <= X"0D";
		else 
			segmentos<= X"1D";
		end if;
	end process;
end behavioral;