library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity comp1 is
	generic( constant h_pulse: integer := 96;
				constant h_bp: integer := 48;
				constant h_pixels: integer := 640;
				constant h_fp: integer := 16;
				constant v_pulse: integer := 2;
				constant v_bp: integer := 33;
				constant v_pixels: integer := 480;
				constant v_fp: integer := 10
	);

	port( clk50MHz: in std_logic;
			column: out integer;
			row: out integer;
			h_sync: out std_logic;
			v_sync: out std_logic
	);
end entity comp1;

architecture behavioral of comp1 is 
constant h_period: integer := h_pulse + h_bp + h_pixels + h_fp;
constant v_period: integer := v_pulse + v_bp + v_pixels + v_fp;
signal h_count: integer range 0 to h_period - 1 := 0;
signal v_count: integer range 0 to v_period - 1 := 0;
signal reloj_pixel: std_logic;
--signal column: integer range 0 to h_period - 1 := 0;
--signal row: integer range 0 to v_period - 1 := 0;
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
	

end architecture behavioral;