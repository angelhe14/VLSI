library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity compP11 is
	generic( constant h_pulse: integer := 96;
				constant h_bp: integer := 48;
				constant h_pixels: integer := 640;
				constant h_fp: integer := 16;
				constant v_pulse: integer := 2;
				constant v_bp: integer := 33;
				constant v_pixels: integer := 480;
				constant v_fp: integer := 10;
				constant cero: std_logic_vector(13 downto 0):="00000000111111"; --gfedcba
				constant uno:  std_logic_vector(13 downto 0):="00000000000110";
				constant dos:    std_logic_vector(13 downto 0):="00000001011011"; 
				constant tres:   std_logic_vector(13 downto 0):="00000001001111"; 
				constant cuatro: std_logic_vector(13 downto 0):="00000001100110"; 
				constant cinco:  std_logic_vector(13 downto 0):="00000001101101"; 
				constant seis:   std_logic_vector(13 downto 0):="00000001111101"; 
				constant siete:  std_logic_vector(13 downto 0):="00000000000111"; 
				constant ocho:   std_logic_vector(13 downto 0):="00000001111111"; 
				constant nueve:  std_logic_vector(13 downto 0):="00000001110011"; 
				constant diez:  std_logic_vector(13 downto 0):="00001100111111";--
				constant once:  std_logic_vector(13 downto 0):="00001100000110";
				constant doce:  std_logic_vector(13 downto 0):="00001101011011";
				constant trece:  std_logic_vector(13 downto 0):="00001101001111";
				constant catorce:  std_logic_vector(13 downto 0):="00001101100110";
				constant quince:  std_logic_vector(13 downto 0):="00001101101101";
				constant dieciseis:  std_logic_vector(13 downto 0):="00001101111101";
				constant diecisiete:  std_logic_vector(13 downto 0):="00001100000111";
				constant dieciocho:  std_logic_vector(13 downto 0):="00001101111111";
				constant diecinueve:  std_logic_vector(13 downto 0):="00001101110011";
				constant veinte:  std_logic_vector(13 downto 0):="10110110111111");
	port( clk50MHz: in std_logic;
			red: out std_logic_vector(3 downto 0);
			green: out std_logic_vector(3 downto 0);
			blue: out std_logic_vector(3 downto 0);
			h_sync: out std_logic;
			reset,st: in std_logic;
			v_sync: out std_logic);
end entity compP11;

architecture behavioral of compP11 is 
constant h_period: integer := h_pulse + h_bp + h_pixels + h_fp;
constant v_period: integer := v_pulse + v_bp + v_pixels + v_fp;
signal h_count: integer range 0 to h_period - 1 := 0;
signal v_count: integer range 0 to v_period - 1 := 0;
signal reloj_pixel: std_logic;
signal column: integer range 0 to h_period - 1 := 0;
signal row: integer range 0 to v_period - 1 := 0;
signal display_ena: std_logic;
signal conectornum: std_logic_vector(13 downto 0);
constant max : integer := 49999999;
signal count1 : integer range 0 to max :=0;
signal count2 : integer range 0 to 20:=0;
begin

	relojpixel: process(clk50MHz) is
	begin
		if rising_edge(clk50MHz) then 
			reloj_pixel <= not reloj_pixel;
		end if;
	end process relojpixel;

	contadores: process(reloj_pixel)
	begin
		if rising_edge(reloj_pixel) then
			if h_count <(h_period-1) then
				h_count <= h_count + 1;
			else
				h_count <= 0;
				if v_count < (v_period - 1) then
					v_count <= v_count + 1;
				else
					v_count<= 0;
				end if;
			end if;
		end if;
	end process contadores;

	serial_hsync: process(reloj_pixel)
	begin
		if rising_edge(reloj_pixel) then 
			if h_count > (h_pixels + h_fp) or h_count > (h_pixels + h_fp + h_pulse) then
				h_sync <= '0';
			else
				h_sync <= '1';
			end if;
		end if;
	end process serial_hsync;
	
	serial_vsync: process(reloj_pixel)
	begin
		if rising_edge(reloj_pixel) then 
			if v_count > (v_pixels + v_fp) or v_count > (v_pixels + v_fp + v_pulse) then
				v_sync <= '0';
			else
				v_sync <= '1';
			end if;
		end if;
	end process serial_vsync;

	coords_pixel: process(reloj_pixel)
	begin
		if rising_edge(reloj_pixel) then
			if(h_count < h_pixels) then
				column <= h_count;
			end if;
			if(v_count < v_pixels) then
				row <= v_count;
			end if;
		end if;
	end process coords_pixel;	
	
	generador_imagen: process(display_ena, row, column)
	begin
		case conectornum is
		when cero=>
			if ((row > 200 and row <210) and (column>110 and column<140)) THEN --a  azul
				red  <=(OTHERS => '0');
				green<=(OTHERS => '0');
				blue <=(OTHERS => '1');
			elsif ((row > 210 and row <240) and (column>140 and column<150)) THEN --b  verde
				red  <=(OTHERS => '0');
				green<=(OTHERS => '1');
				blue <=(OTHERS => '0');
			elsif ((row > 250 and row <280) and (column>140 and column<150)) THEN --c  rojo
				red  <=(OTHERS => '1');
				green<=(OTHERS => '0');
				blue <=(OTHERS => '0');
			elsif ((row > 280 and row <290) and (column>110 and column<140)) THEN --d  blanco
				red  <=(OTHERS => '1');
				green<=(OTHERS => '1');
				blue <=(OTHERS => '1');
			elsif ((row > 250 and row <280) and (column>100 and column<110)) THEN --e cian
				red  <=(OTHERS => '0');
				green<=(OTHERS => '1');
				blue <=(OTHERS => '1');
			elsif ((row > 210 and row <240) and (column>100 and column<110)) THEN --f  amarillo
				red  <=(OTHERS => '1');
				green<=(OTHERS => '1');
				blue <=(OTHERS => '0');
			else												--fondo
				red  <=(OTHERS => '0');
				green<=(OTHERS => '0');
				blue <=(OTHERS => '0');
			end if;	
		when uno=>
			if ((row > 210 and row <240) and (column>140 and column<150)) THEN --b verde
				red <= (OTHERS => '0');
				green<=(OTHERS => '1');
				blue<= (OTHERS => '0');
			elsif ((row > 250 and row <280) and (column>140 and column<150)) THEN 		--c  rojo
				red <= (OTHERS => '1');
				green<=(OTHERS => '0');
				blue<=(OTHERS => '0');
			else												--fondo
				red <= (OTHERS => '0');
				green <= (OTHERS => '0');
				blue <= (OTHERS => '0');
			end if;			
	   when dos=>
		   if ((row > 200 and row <210) and (column>110 and column<140)) THEN--a  azul
				red <= (OTHERS => '0');
				green<=(OTHERS => '0');
				blue<=(OTHERS => '1');
			elsif ((row > 210 and row <240) and (column>140 and column<150)) THEN --b  verde
				Red<= (OTHERS => '0');
				green<=(OTHERS => '1');
				blue<=(OTHERS => '0');
			elsif ((row > 280 and row <290) and (column>110 and column<140)) THEN --d  blanco
				Red<= (OTHERS => '1');
				green<=(OTHERS => '1');
				blue<=(OTHERS => '1');
			elsif ((row > 250 and row <280) and (column>100 and column<110)) THEN --e cian
				Red<= (OTHERS => '0');
				Green<=(OTHERS => '1');
				Blue<=(OTHERS => '1');
			elsif ((row > 240 and row <250) and (column>110 and column<140)) THEN--g violeta
				red <= (OTHERS => '1');
				green<=(OTHERS => '0');
				blue<=(OTHERS => '1');
			else												 -- fondo
				red <= (OTHERS => '0');
				green <= (OTHERS => '0');
				blue <= (OTHERS => '0');
			end if;			
		when tres=>
			if ((row > 200 and row <210) and (column>110 and column<140)) THEN --a  azul
				red <= (OTHERS => '0');
				green<=(OTHERS => '0');
				blue<=(OTHERS => '1');
			elsif ((row > 210 and row <240) and (column>140 and column<150)) THEN --b  verde
				red<= (OTHERS => '0');
				green<=(OTHERS => '1');
				blue<=(OTHERS => '0');
			elsif ((row > 250 and row <280) and (column>140 and column<150)) THEN --c  rojo
				red <= (OTHERS => '1');
				green<=(OTHERS => '0');
				blue<=(OTHERS => '0');
			elsif ((row > 280 and row <290) and (column>110 and column<140)) THEN --d  blanco
				Red<= (OTHERS => '1');
				green<=(OTHERS => '1');
				blue<=(OTHERS => '1');
			elsif ((row > 240 and row <250) and (column>110 and column<140)) THEN --g   violeta
				red <= (OTHERS => '1');
				green<=(OTHERS => '0');
				blue  <= (OTHERS => '1');
			else    --fondo
				red <= (OTHERS => '0');
				green<= (OTHERS => '0');
				blue <= (OTHERS => '0');
			end if;			
		when cuatro=>
			if ((row > 210 and row <240) and (column>140 and column<150)) THEN --b  verde
				red<= (OTHERS => '0');
				green<=(OTHERS => '1');
				blue<=(OTHERS => '0');
			elsif ((row > 250 and row <280) and (column>140 and column<150)) THEN --c  rojo
				red <= (OTHERS => '1');
				green<=(OTHERS => '0');
				blue<=(OTHERS => '0');
			elsif ((row > 210 and row <240) and (column>100 and column<110)) THEN --f  amarillo
				red <= (OTHERS => '1');
				green<=(OTHERS => '1');
				blue  <= (OTHERS => '0');
			elsif ((row > 240 and row <250) and (column>110 and column<140)) THEN --g   violeta
				red <= (OTHERS => '1');
				green<=(OTHERS => '0');
				blue  <= (OTHERS => '1');
			else    --fondo
				red <= (OTHERS => '0');
				green<= (OTHERS => '0');
				blue <= (OTHERS => '0');
			end if;
		when cinco=>
			if ((row > 200 and row <210) and (column>110 and column<140)) THEN --a  azul
				red <= (OTHERS => '0');
				green<=(OTHERS => '0');
				blue<=(OTHERS => '1');
			elsif ((row > 250 and row <280) and (column>140 and column<150)) THEN --c  rojo
				red <= (OTHERS => '1');
				green<=(OTHERS => '0');
				blue<=(OTHERS => '0');
			elsif ((row > 280 and row <290) and (column>110 and column<140)) THEN --d  blanco
				Red<= (OTHERS => '1');
				green<=(OTHERS => '1');
				blue<=(OTHERS => '1');
			elsif ((row > 210 and row <240) and (column>100 and column<110)) THEN --f  amarillo
				red <= (OTHERS => '1');
				green<=(OTHERS => '1');
				blue  <= (OTHERS => '0');
			elsif ((row > 240 and row <250) and (column>110 and column<140)) THEN --g   violeta
				red <= (OTHERS => '1');
				green<=(OTHERS => '0');
				blue  <= (OTHERS => '1');
			else    --fondo
				red <= (OTHERS => '0');
				green<= (OTHERS => '0');
				blue <= (OTHERS => '0');
			end if;
		when seis=>
			if ((row > 200 and row <210) and (column>110 and column<140)) THEN --a  azul
				red <= (OTHERS => '0');
				green<=(OTHERS => '0');
				blue<=(OTHERS => '1');
			elsif ((row > 250 and row <280) and (column>140 and column<150)) THEN --c  rojo
				red <= (OTHERS => '1');
				green<=(OTHERS => '0');
				blue<=(OTHERS => '0');
			elsif ((row > 280 and row <290) and (column>110 and column<140)) THEN --d  blanco
				Red<= (OTHERS => '1');
				green<=(OTHERS => '1');
				blue<=(OTHERS => '1');
			elsif ((row > 250 and row <280) and (column>100 and column<110)) THEN --e cian
				Red<= (OTHERS => '0');
				Green<=(OTHERS => '1');
				Blue<=(OTHERS => '1');
			elsif ((row > 210 and row <240) and (column>100 and column<110)) THEN --f  amarillo
				red <= (OTHERS => '1');
				green<=(OTHERS => '1');
				blue  <= (OTHERS => '0');
			elsif ((row > 240 and row <250) and (column>110 and column<140)) THEN --g   violeta
				red <= (OTHERS => '1');
				green<=(OTHERS => '0');
				blue  <= (OTHERS => '1');
			else    --fondo
				red <= (OTHERS => '0');
				green<= (OTHERS => '0');
				blue <= (OTHERS => '0');
			end if;
		when siete=>
			if ((row > 200 and row <210) and (column>110 and column<140)) THEN --a  azul
				red <= (OTHERS => '0');
				green<=(OTHERS => '0');
				blue<=(OTHERS => '1');
			elsif ((row > 210 and row <240) and (column>140 and column<150)) THEN --b  verde
				red<= (OTHERS => '0');
				green<=(OTHERS => '1');
				blue<=(OTHERS => '0');
			elsif ((row > 250 and row <280) and (column>140 and column<150)) THEN --c  rojo
				red <= (OTHERS => '1');
				green<=(OTHERS => '0');
				blue<=(OTHERS => '0');
			else    --fondo
				red <= (OTHERS => '0');
				green<= (OTHERS => '0');
				blue <= (OTHERS => '0');
			end if;
		when ocho=> 
			if ((row > 200 and row <210) and (column>110 and column<140)) THEN --a  azul
				red <= (OTHERS => '0');
				green<=(OTHERS => '0');
				blue<=(OTHERS => '1');
			elsif ((row > 210 and row <240) and (column>140 and column<150)) THEN --b  verde
				red<= (OTHERS => '0');
				green<=(OTHERS => '1');
				blue<=(OTHERS => '0');
			elsif ((row > 250 and row <280) and (column>140 and column<150)) THEN --c  rojo
				red <= (OTHERS => '1');
				green<=(OTHERS => '0');
				blue<=(OTHERS => '0');
			elsif ((row > 280 and row <290) and (column>110 and column<140)) THEN --d  blanco
				Red<= (OTHERS => '1');
				green<=(OTHERS => '1');
				blue<=(OTHERS => '1');
			elsif ((row > 250 and row <280) and (column>100 and column<110)) THEN --e cian
				Red<= (OTHERS => '0');
				Green<=(OTHERS => '1');
				Blue<=(OTHERS => '1');
			elsif ((row > 210 and row <240) and (column>100 and column<110)) THEN --f  amarillo
				red <= (OTHERS => '1');
				green<=(OTHERS => '1');
				blue  <= (OTHERS => '0');
			elsif ((row > 240 and row <250) and (column>110 and column<140)) THEN --g   violeta
				red <= (OTHERS => '1');
				green<=(OTHERS => '0');
				blue  <= (OTHERS => '1');
			else    --fondo
				red <= (OTHERS => '0');
				green<= (OTHERS => '0');
				blue <= (OTHERS => '0');
			end if;
		when nueve=>
			if ((row > 200 and row <210) and (column>110 and column<140)) THEN --a  azul
				red <= (OTHERS => '0');
				green<=(OTHERS => '0');
				blue<=(OTHERS => '1');
			elsif ((row > 210 and row <240) and (column>140 and column<150)) THEN --b  verde
				red<= (OTHERS => '0');
				green<=(OTHERS => '1');
				blue<=(OTHERS => '0');
			elsif ((row > 250 and row <280) and (column>140 and column<150)) THEN --c  rojo
				red <= (OTHERS => '1');
				green<=(OTHERS => '0');
				blue<=(OTHERS => '0');
			elsif ((row > 210 and row <240) and (column>100 and column<110)) THEN --f  amarillo
				red <= (OTHERS => '1');
				green<=(OTHERS => '1');
				blue  <= (OTHERS => '0');
			elsif ((row > 240 and row <250) and (column>110 and column<140)) THEN --g   violeta
				red <= (OTHERS => '1');
				green<=(OTHERS => '0');
				blue  <= (OTHERS => '1');
			else    --fondo
				red <= (OTHERS => '0');
				green<= (OTHERS => '0');
				blue <= (OTHERS => '0');
			end if;
		when diez=>
			if ((row > 210 and row <240) and (column>140 and column<150)) THEN --b verde
				red <= (OTHERS => '0');
				green<=(OTHERS => '1');
				blue<= (OTHERS => '0');
			elsif ((row > 250 and row <280) and (column>140 and column<150)) THEN 		--c  rojo
				red <= (OTHERS => '1');
				green<=(OTHERS => '0');
				blue<=(OTHERS => '0');	
			elsif ((row > 200 and row <210) and (column>180 and column<210)) THEN --a  azul
				red  <=(OTHERS => '0');
				green<=(OTHERS => '0');
				blue <=(OTHERS => '1');
			elsif ((row > 210 and row <240) and (column>210 and column<220)) THEN --b  verde
				red  <=(OTHERS => '0');
				green<=(OTHERS => '1');
				blue <=(OTHERS => '0');
			elsif ((row > 250 and row <280) and (column>210 and column<220)) THEN --c  rojo
				red  <=(OTHERS => '1');
				green<=(OTHERS => '0');
				blue <=(OTHERS => '0');
			elsif ((row > 280 and row <290) and (column>180 and column<210)) THEN --d  blanco
				red  <=(OTHERS => '1');
				green<=(OTHERS => '1');
				blue <=(OTHERS => '1');
			elsif ((row > 250 and row <280) and (column>170 and column<180)) THEN --e cian
				red  <=(OTHERS => '0');
				green<=(OTHERS => '1');
				blue <=(OTHERS => '1');
			elsif ((row > 210 and row <240) and (column>170 and column<180)) THEN --f  amarillo
				red  <=(OTHERS => '1');
				green<=(OTHERS => '1');
				blue <=(OTHERS => '0');
			else												--fondo
				red <= (OTHERS => '0');
				green <= (OTHERS => '0');
				blue <= (OTHERS => '0');
			end if;	
		when once=>
			if ((row > 210 and row <240) and (column>140 and column<150)) THEN --b verde
				red <= (OTHERS => '0');
				green<=(OTHERS => '1');
				blue<= (OTHERS => '0');
			elsif ((row > 250 and row <280) and (column>140 and column<150)) THEN 		--c  rojo
				red <= (OTHERS => '1');
				green<=(OTHERS => '0');
				blue<=(OTHERS => '0');	
			elsif ((row > 210 and row <240) and (column>210 and column<220)) THEN --b verde
				red <= (OTHERS => '0');
				green<=(OTHERS => '1');
				blue<= (OTHERS => '0');
			elsif ((row > 250 and row <280) and (column>210 and column<220)) THEN 		--c  rojo
				red <= (OTHERS => '1');
				green<=(OTHERS => '0');
				blue<=(OTHERS => '0');
			else												--fondo
				red <= (OTHERS => '0');
				green <= (OTHERS => '0');
				blue <= (OTHERS => '0');
			end if;	
		when doce=>
			if ((row > 210 and row <240) and (column>140 and column<150)) THEN --b verde
				red <= (OTHERS => '0');
				green<=(OTHERS => '1');
				blue<= (OTHERS => '0');
			elsif ((row > 250 and row <280) and (column>140 and column<150)) THEN 		--c  rojo
				red <= (OTHERS => '1');
				green<=(OTHERS => '0');
				blue<=(OTHERS => '0');
		   elsif ((row > 200 and row <210) and (column>180 and column<210)) THEN--a  azul
				red <= (OTHERS => '0');
				green<=(OTHERS => '0');
				blue<=(OTHERS => '1');
			elsif ((row > 210 and row <240) and (column>210 and column<220)) THEN --b  verde
				Red<= (OTHERS => '0');
				green<=(OTHERS => '1');
				blue<=(OTHERS => '0');
			elsif ((row > 280 and row <290) and (column>180 and column<210)) THEN --d  blanco
				Red<= (OTHERS => '1');
				green<=(OTHERS => '1');
				blue<=(OTHERS => '1');
			elsif ((row > 250 and row <280) and (column>170 and column<180)) THEN --e cian
				Red<= (OTHERS => '0');
				Green<=(OTHERS => '1');
				Blue<=(OTHERS => '1');
			elsif ((row > 240 and row <250) and (column>180 and column<210)) THEN--g violeta
				red <= (OTHERS => '1');
				green<=(OTHERS => '0');
				blue<=(OTHERS => '1');
			else												 -- fondo
				red <= (OTHERS => '0');
				green <= (OTHERS => '0');
				blue <= (OTHERS => '0');
			end if;
		when trece=>
			if ((row > 210 and row <240) and (column>140 and column<150)) THEN --b verde
				red <= (OTHERS => '0');
				green<=(OTHERS => '1');
				blue<= (OTHERS => '0');
			elsif ((row > 250 and row <280) and (column>140 and column<150)) THEN 		--c  rojo
				red <= (OTHERS => '1');
				green<=(OTHERS => '0');
				blue<=(OTHERS => '0');
			elsif ((row > 200 and row <210) and (column>180 and column<210)) THEN --a  azul
				red <= (OTHERS => '0');
				green<=(OTHERS => '0');
				blue<=(OTHERS => '1');
			elsif ((row > 210 and row <240) and (column>210 and column<220)) THEN --b  verde
				red<= (OTHERS => '0');
				green<=(OTHERS => '1');
				blue<=(OTHERS => '0');
			elsif ((row > 250 and row <280) and (column>210 and column<220)) THEN --c  rojo
				red <= (OTHERS => '1');
				green<=(OTHERS => '0');
				blue<=(OTHERS => '0');
			elsif ((row > 280 and row <290) and (column>180 and column<210)) THEN --d  blanco
				Red<= (OTHERS => '1');
				green<=(OTHERS => '1');
				blue<=(OTHERS => '1');
			elsif ((row > 240 and row <250) and (column>180 and column<210)) THEN --g   violeta
				red <= (OTHERS => '1');
				green<=(OTHERS => '0');
				blue  <= (OTHERS => '1');
			else    --fondo
				red <= (OTHERS => '0');
				green<= (OTHERS => '0');
				blue <= (OTHERS => '0');
			end if;
		when catorce=>
			if ((row > 210 and row <240) and (column>140 and column<150)) THEN --b verde
				red <= (OTHERS => '0');
				green<=(OTHERS => '1');
				blue<= (OTHERS => '0');
			elsif ((row > 250 and row <280) and (column>140 and column<150)) THEN 		--c  rojo
				red <= (OTHERS => '1');
				green<=(OTHERS => '0');
				blue<=(OTHERS => '0');
			elsif ((row > 210 and row <240) and (column>210 and column<220)) THEN --b  verde
				red<= (OTHERS => '0');
				green<=(OTHERS => '1');
				blue<=(OTHERS => '0');
			elsif ((row > 250 and row <280) and (column>210 and column<220)) THEN --c  rojo
				red <= (OTHERS => '1');
				green<=(OTHERS => '0');
				blue<=(OTHERS => '0');
			elsif ((row > 210 and row <240) and (column>170 and column<180)) THEN --f  amarillo
				red <= (OTHERS => '1');
				green<=(OTHERS => '1');
				blue  <= (OTHERS => '0');
			elsif ((row > 240 and row <250) and (column>180 and column<210)) THEN --g   violeta
				red <= (OTHERS => '1');
				green<=(OTHERS => '0');
				blue  <= (OTHERS => '1');
			else    --fondo
				red <= (OTHERS => '0');
				green<= (OTHERS => '0');
				blue <= (OTHERS => '0');
			end if;		
		when quince=>
			if ((row > 210 and row <240) and (column>140 and column<150)) THEN --b verde
				red <= (OTHERS => '0');
				green<=(OTHERS => '1');
				blue<= (OTHERS => '0');
			elsif ((row > 250 and row <280) and (column>140 and column<150)) THEN 		--c  rojo
				red <= (OTHERS => '1');
				green<=(OTHERS => '0');
				blue<=(OTHERS => '0');
			elsif ((row > 200 and row <210) and (column>180 and column<210)) THEN --a  azul
				red <= (OTHERS => '0');
				green<=(OTHERS => '0');
				blue<=(OTHERS => '1');
			elsif ((row > 250 and row <280) and (column>210 and column<220)) THEN --c  rojo
				red <= (OTHERS => '1');
				green<=(OTHERS => '0');
				blue<=(OTHERS => '0');
			elsif ((row > 280 and row <290) and (column>180 and column<210)) THEN --d  blanco
				Red<= (OTHERS => '1');
				green<=(OTHERS => '1');
				blue<=(OTHERS => '1');
			elsif ((row > 210 and row <240) and (column>170 and column<180)) THEN --f  amarillo
				red <= (OTHERS => '1');
				green<=(OTHERS => '1');
				blue  <= (OTHERS => '0');
			elsif ((row > 240 and row <250) and (column>180 and column<210)) THEN --g   violeta
				red <= (OTHERS => '1');
				green<=(OTHERS => '0');
				blue  <= (OTHERS => '1');
			else    --fondo
				red <= (OTHERS => '0');
				green<= (OTHERS => '0');
				blue <= (OTHERS => '0');
			end if;
		when dieciseis=>
			if ((row > 210 and row <240) and (column>140 and column<150)) THEN --b verde
				red <= (OTHERS => '0');
				green<=(OTHERS => '1');
				blue<= (OTHERS => '0');
			elsif ((row > 250 and row <280) and (column>140 and column<150)) THEN 		--c  rojo
				red <= (OTHERS => '1');
				green<=(OTHERS => '0');
				blue<=(OTHERS => '0');
			elsif ((row > 200 and row <210) and (column>180 and column<210)) THEN --a  azul
				red <= (OTHERS => '0');
				green<=(OTHERS => '0');
				blue<=(OTHERS => '1');
			elsif ((row > 250 and row <280) and (column>210 and column<220)) THEN --c  rojo
				red <= (OTHERS => '1');
				green<=(OTHERS => '0');
				blue<=(OTHERS => '0');
			elsif ((row > 280 and row <290) and (column>180 and column<210)) THEN --d  blanco
				Red<= (OTHERS => '1');
				green<=(OTHERS => '1');
				blue<=(OTHERS => '1');
			elsif ((row > 250 and row <280) and (column>170 and column<180)) THEN --e cian
				Red<= (OTHERS => '0');
				Green<=(OTHERS => '1');
				Blue<=(OTHERS => '1');
			elsif ((row > 210 and row <240) and (column>170 and column<180)) THEN --f  amarillo
				red <= (OTHERS => '1');
				green<=(OTHERS => '1');
				blue  <= (OTHERS => '0');
			elsif ((row > 240 and row <250) and (column>180 and column<210)) THEN --g   violeta
				red <= (OTHERS => '1');
				green<=(OTHERS => '0');
				blue  <= (OTHERS => '1');
			else    --fondo
				red <= (OTHERS => '0');
				green<= (OTHERS => '0');
				blue <= (OTHERS => '0');
			end if;
		when diecisiete=>
			if ((row > 210 and row <240) and (column>140 and column<150)) THEN --b verde
				red <= (OTHERS => '0');
				green<=(OTHERS => '1');
				blue<= (OTHERS => '0');
			elsif ((row > 250 and row <280) and (column>140 and column<150)) THEN 		--c  rojo
				red <= (OTHERS => '1');
				green<=(OTHERS => '0');
				blue<=(OTHERS => '0');
			elsif ((row > 200 and row <210) and (column>180 and column<210)) THEN --a  azul
				red <= (OTHERS => '0');
				green<=(OTHERS => '0');
				blue<=(OTHERS => '1');
			elsif ((row > 210 and row <240) and (column>210 and column<220)) THEN --b  verde
				red<= (OTHERS => '0');
				green<=(OTHERS => '1');
				blue<=(OTHERS => '0');
			elsif ((row > 250 and row <280) and (column>210 and column<220)) THEN --c  rojo
				red <= (OTHERS => '1');
				green<=(OTHERS => '0');
				blue<=(OTHERS => '0');
			else    --fondo
				red <= (OTHERS => '0');
				green<= (OTHERS => '0');
				blue <= (OTHERS => '0');
			end if;				
		when dieciocho=>
			if ((row > 210 and row <240) and (column>140 and column<150)) THEN --b verde
				red <= (OTHERS => '0');
				green<=(OTHERS => '1');
				blue<= (OTHERS => '0');
			elsif ((row > 250 and row <280) and (column>140 and column<150)) THEN 		--c  rojo
				red <= (OTHERS => '1');
				green<=(OTHERS => '0');
				blue<=(OTHERS => '0');				
			elsif ((row > 200 and row <210) and (column>180 and column<210)) THEN --a  azul
				red <= (OTHERS => '0');
				green<=(OTHERS => '0');
				blue<=(OTHERS => '1');
			elsif ((row > 210 and row <240) and (column>210 and column<220)) THEN --b  verde
				red<= (OTHERS => '0');
				green<=(OTHERS => '1');
				blue<=(OTHERS => '0');
			elsif ((row > 250 and row <280) and (column>210 and column<220)) THEN --c  rojo
				red <= (OTHERS => '1');
				green<=(OTHERS => '0');
				blue<=(OTHERS => '0');
			elsif ((row > 280 and row <290) and (column>180 and column<210)) THEN --d  blanco
				Red<= (OTHERS => '1');
				green<=(OTHERS => '1');
				blue<=(OTHERS => '1');
			elsif ((row > 250 and row <280) and (column>170 and column<180)) THEN --e cian
				Red<= (OTHERS => '0');
				Green<=(OTHERS => '1');
				Blue<=(OTHERS => '1');
			elsif ((row > 210 and row <240) and (column>170 and column<180)) THEN --f  amarillo
				red <= (OTHERS => '1');
				green<=(OTHERS => '1');
				blue  <= (OTHERS => '0');
			elsif ((row > 240 and row <250) and (column>180 and column<210)) THEN --g   violeta
				red <= (OTHERS => '1');
				green<=(OTHERS => '0');
				blue  <= (OTHERS => '1');
			else    --fondo
				red <= (OTHERS => '0');
				green<= (OTHERS => '0');
				blue <= (OTHERS => '0');
			end if;
		when diecinueve=>
			if ((row > 210 and row <240) and (column>140 and column<150)) THEN --b verde
				red <= (OTHERS => '0');
				green<=(OTHERS => '1');
				blue<= (OTHERS => '0');
			elsif ((row > 250 and row <280) and (column>140 and column<150)) THEN 		--c  rojo
				red <= (OTHERS => '1');
				green<=(OTHERS => '0');
				blue<=(OTHERS => '0');			
			elsif ((row > 200 and row <210) and (column>180 and column<210)) THEN --a  azul
				red <= (OTHERS => '0');
				green<=(OTHERS => '0');
				blue<=(OTHERS => '1');
			elsif ((row > 210 and row <240) and (column>210 and column<220)) THEN --b  verde
				red<= (OTHERS => '0');
				green<=(OTHERS => '1');
				blue<=(OTHERS => '0');
			elsif ((row > 250 and row <280) and (column>210 and column<220)) THEN --c  rojo
				red <= (OTHERS => '1');
				green<=(OTHERS => '0');
				blue<=(OTHERS => '0');
			elsif ((row > 210 and row <240) and (column>170 and column<180)) THEN --f  amarillo
				red <= (OTHERS => '1');
				green<=(OTHERS => '1');
				blue  <= (OTHERS => '0');
			elsif ((row > 240 and row <250) and (column>180 and column<210)) THEN --g   violeta
				red <= (OTHERS => '1');
				green<=(OTHERS => '0');
				blue  <= (OTHERS => '1');
			else    --fondo
				red <= (OTHERS => '0');
				green<= (OTHERS => '0');
				blue <= (OTHERS => '0');
			end if;
		when veinte=>
		   if ((row > 200 and row <210) and (column>110 and column<140)) THEN--a  azul
				red <= (OTHERS => '0');
				green<=(OTHERS => '0');
				blue<=(OTHERS => '1');
			elsif ((row > 210 and row <240) and (column>140 and column<150)) THEN --b  verde
				Red<= (OTHERS => '0');
				green<=(OTHERS => '1');
				blue<=(OTHERS => '0');
			elsif ((row > 280 and row <290) and (column>110 and column<140)) THEN --d  blanco
				Red<= (OTHERS => '1');
				green<=(OTHERS => '1');
				blue<=(OTHERS => '1');
			elsif ((row > 250 and row <280) and (column>100 and column<110)) THEN --e cian
				Red<= (OTHERS => '0');
				Green<=(OTHERS => '1');
				Blue<=(OTHERS => '1');
			elsif ((row > 240 and row <250) and (column>110 and column<140)) THEN--g violeta
				red <= (OTHERS => '1');
				green<=(OTHERS => '0');
				blue<=(OTHERS => '1');
			elsif ((row > 200 and row <210) and (column>180 and column<210)) THEN --a  azul
				red  <=(OTHERS => '0');
				green<=(OTHERS => '0');
				blue <=(OTHERS => '1');
			elsif ((row > 210 and row <240) and (column>210 and column<220)) THEN --b  verde
				red  <=(OTHERS => '0');
				green<=(OTHERS => '1');
				blue <=(OTHERS => '0');
			elsif ((row > 250 and row <280) and (column>210 and column<220)) THEN --c  rojo
				red  <=(OTHERS => '1');
				green<=(OTHERS => '0');
				blue <=(OTHERS => '0');
			elsif ((row > 280 and row <290) and (column>180 and column<210)) THEN --d  blanco
				red  <=(OTHERS => '1');
				green<=(OTHERS => '1');
				blue <=(OTHERS => '1');
			elsif ((row > 250 and row <280) and (column>170 and column<180)) THEN --e cian
				red  <=(OTHERS => '0');
				green<=(OTHERS => '1');
				blue <=(OTHERS => '1');
			elsif ((row > 210 and row <240) and (column>170 and column<180)) THEN --f  amarillo
				red  <=(OTHERS => '1');
				green<=(OTHERS => '1');
				blue <=(OTHERS => '0');
			else												--fondo
				red  <=(OTHERS => '0');
				green<=(OTHERS => '0');
				blue <=(OTHERS => '0');
			end if;			
	when others =>
		if ((row > 200 and row <210) and (column>110 and column<140)) THEN --a  azul
				red <= (OTHERS => '0');
				green<=(OTHERS => '1');
				blue<=(OTHERS => '0');
			elsif ((row > 210 and row <240) and (column>140 and column<150)) THEN --b  verde
				red<= (OTHERS => '0');
				green<=(OTHERS => '0');
				blue<=(OTHERS => '1');
			elsif ((row > 250 and row <280) and (column>140 and column<150)) THEN --c  rojo
				red <= (OTHERS => '1');
				green<=(OTHERS => '0');
				blue<=(OTHERS => '0');
			elsif ((row > 210 and row <240) and (column>100 and column<110)) THEN --f  amarillo
				red <= (OTHERS => '1');
				green<=(OTHERS => '1');
				blue  <= (OTHERS => '0');
			elsif ((row > 240 and row <250) and (column>110 and column<140)) THEN --g   violeta
				red <= (OTHERS => '1');
				green<=(OTHERS => '0');
				blue  <= (OTHERS => '1');
			else    --fondo
				red <= (OTHERS => '0');
				green<= (OTHERS => '0');
				blue <= (OTHERS => '0');
			end if;
		end case;				
	end process generador_imagen;
		
	display_enable: process(reloj_pixel)
	begin
		if rising_edge(reloj_pixel) then
			if(h_count < h_pixels and v_count < v_pixels) then
				display_ena <= '1';
			else
				display_ena <= '0';
			end if;
		end if;
	end process display_enable;
	
	process(clk50MHz)
	begin
	if rising_edge(clk50MHz) then
	 if reset = '0' then
	  count1 <= 0;
	  count2 <= 0;
	  else
		if st = '1' then
		 count1 <=count1+1;
		  if count1 = max then
			count1 <= 0;
			 count2 <= count2+1;
			  if count2 = 20 then
				  count2 <=0;
			  end if;
		  end if;
		end if;
	 end if;
	end if;
	end process;
	conectornum <=
		"00000000111111" when count2 = 0 else
		"00000000000110" when count2 = 1 else
		"00000001011011" when count2 = 2 else
		"00000001001111" when count2 = 3 else
		"00000001100110" when count2 = 4 else
		"00000001101101" when count2 = 5 else
		"00000001111101" when count2 = 6 else
		"00000000000111" when count2 = 7 else
		"00000001111111" when count2 = 8 else
		"00000001110011" when count2 = 9 else
		"00001100111111" when count2 = 10 else
		"00001100000110" when count2 = 11 else
		"00001101011011" when count2 = 12 else
		"00001101001111" when count2 = 13 else
		"00001101100110" when count2 = 14 else
		"00001101101101" when count2 = 15 else
		"00001101111101" when count2 = 16 else
		"00001100000111" when count2 = 17 else
		"00001101111111" when count2 = 18 else
		"00001101110011" when count2 = 19 else
		"10110110111111" when count2 = 20 else
		"00000000000000";
end architecture behavioral;