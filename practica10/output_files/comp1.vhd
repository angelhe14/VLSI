library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity comp1 is
port( clk50MHz: in std_logic;
	clk25: in std_logic;
	red: out std_logic_vector (3 downto 0);
	green: out std_logic_vector (3 downto 0);
	blue: out std_logic_vector (3 downto 0);
	h_sync: out std_logic;
	v_sync: out std_logic
	);
end entity comp1;


architecture behavioral of comp1 is
	CONSTANT h_pulse : INTEGER := 96;
	CONSTANT h_bp : INTEGER := 48;
	CONSTANT h_pixels : INTEGER := 640;
	CONSTANT h_fp : INTEGER := 16;
	CONSTANT v_pulse : INTEGER := 2;
	CONSTANT v_bp : INTEGER := 33;
	CONSTANT v_pixels : INTEGER := 480;
	CONSTANT v_fp : INTEGER := 10;
	signal h_period : INTEGER := h_pulse + h_bp + h_pixels + h_fp;
	signal v_period : INTEGER := v_pulse + v_bp + v_pixels + v_fp;
	signal h_count : INTEGER RANGE 0 TO h_period - 1 := 0;
	signal v_count : INTEGER RANGE 0 TO v_period - 1 := 0;
	signal reloj_pixel : std_logic;
	signal column : INTEGER;
	signal row : INTEGER;
	signal display_ena : STD_LOGIC;
	signal div_clk: std_logic;
	constant contador_maximo: integer := 3000000;
	signal contador: integer range 0 to contador_maximo;
	signal clk_state: STD_LOGIC := '0';

begin
	reloj_pix: process (clk50MHz) is
begin
	if rising_edge(clk50MHz) then
		reloj_pixel <= not reloj_pixel;
	end if;
	end process reloj_pix;
	
reloj: process (clk25) is
	begin
		if rising_edge(clk25) then
			if(contador < contador_maximo) then
				contador <= contador+1;
			else
				clk_state <= not clk_state;
				contador <= 0;
			end if;
		end if;
	div_clk <= clk_state;
end process;


contadores: process (reloj_pixel) -- H_periodo=800, V_periodo=525
begin
	if rising_edge(reloj_pixel) then
		if h_count<(h_period-1) then
			h_count<=h_count+1;
			else
				h_count<=0;
		if v_count<(v_period-1) then
				v_count<=v_count+1;
			else
				v_count<=0;
			end if;
		end if;
	end if;
end process contadores;


senial_hsync : process (reloj_pixel) --h_pixel+h_fp+h_pulse= 784
begin
	if rising_edge(reloj_pixel) then
		if h_count>(h_pixels + h_fp) or
			h_count>(h_pixels + h_fp + h_pulse) then
			h_sync<='0';
			else
			h_sync<='1';
		end if;
	end if;
end process senial_hsync;


senial_vsync : process (reloj_pixel) --vpixels+v_fp+v_pulse=525
begin --checar si se en parte visible es 1 o 0
	if rising_edge(reloj_pixel) then
		if v_count>(v_pixels + v_fp) or
			v_count>(v_pixels + v_fp + v_pulse) then
			v_sync<='0';
		else
			v_sync<='1';
		end if;
	end if;
end process senial_vsync;



coords_pixel: process(reloj_pixel)
begin --asignar una coordenada en parte visible
	if rising_edge(reloj_pixel) then
		if (h_count < h_pixels) then
			column <= h_count;
		end if;
	if (v_count < v_pixels) then
		row <= v_count;
	end if;
end if;
end process coords_pixel;




generador_imagen: PROCESS (display_ena, row, column)
variable mueve1: INTEGER range 100 to 400 := 100;
variable mueve2: INTEGER range 150 to 450 := 150;
variable mueve3: INTEGER range 100 to 400 := 100;
variable mueve4: INTEGER range 150 to 450 := 150;

begin
	if rising_edge(div_clk) then
		mueve1 := mueve1-5;
		mueve2 := mueve2-5;
		mueve3 := mueve3+5;
		mueve4 := mueve4+5;
	end if;
	if(display_ena = '1') THEN
		if ((row > mueve1 and row <mueve2) and (column>250 and column<300)) THEN
			red <= (OTHERS => '1');
			green<=(OTHERS => '0');
			blue<=(OTHERS => '0');
		elsif ((row > 300 and row <350) and (column>350 and column<400)) THEN
			red <= (OTHERS => '0');
			green<=(OTHERS => '1');
			blue<=(OTHERS => '0');
		elsif ((row > 300 and row <350) and (column>mueve3 and column<mueve4)) THEN
			red <= (OTHERS => '0');
			green<=(OTHERS => '0');
			blue<=(OTHERS => '1');
		else
			red <= (OTHERS => '0');
			green <= (OTHERS => '0');
			blue <= (OTHERS => '0');
	end if;
		else
			red<= (OTHERS => '0');
			green <= (OTHERS => '0');
			blue<= (OTHERS => '0');
end if;
end process generador_imagen;



display_enable: process(reloj_pixel) --- h_pixels=640; y_pixeles=480
begin
	if rising_edge(reloj_pixel) then
		if (h_count < h_pixels AND v_count < v_pixels) THEN
			display_ena <= '1';
		else
			display_ena <= '0';
		end if;
	end if;
end process display_enable;
end architecture behavioral;