library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

entity complementaria is
Port ( clk : in std_logic; 
		 DC : in std_logic_vector (4 downto 0); --Ciclo de trabajo, se usan 5 sw, maximo valor con 5 bits  11111 = 31 %
		 Hz : in std_logic_vector (4 downto 0); --Frecuencia, se usan 5 sw, maximo valor con 5 bits 11111 = 31 hz
		 S : out std_logic); 
end complementaria;

architecture Behavioral of complementaria is
	
	signal fclk : integer := 50000000; 	--Reloj FPGA
	signal frecuencia : integer := 0;	--Frecuencia del Usuario en entero
	signal ciclo_trabajo : integer := 0;--Ciclo Trabajo del usuario en entero

begin

	VAL_FRECUENCIA : process(Hz)	--Obtiene el valor entero de la frecuencia dada por el usuario
		variable fq : integer := 0;
	begin
	 fq := to_integer(unsigned(Hz));
	 frecuencia <= fq;
	end process;
	
	VAL_CICLO_TRABAJO : process(DC)	--Obtiene el valor entero de la frecuencia dada por el usuario
		variable ct : integer := 0; 
	begin
		ct := to_integer(unsigned(DC));
		ciclo_trabajo <= ct;
	end process;
	
	SALIDA : process (clk)	--Encendido del led de acuerdo con F y CT indicados
		variable cuenta: integer := 0;
		begin
		if rising_edge (clk) then  
			if cuenta < fclk/frecuencia then  
			--fclk/frecuencia es la relación entre reloj fpga y reloj del usuario
			-- indica la cuenta maxima antes del reset
				if cuenta <= ((fclk/frecuencia)*(ciclo_trabajo))/100 then
				--((fclk/frecuencia)*(ciclo_trabajo))/100 es el porcentaje de la cuenta maxima
				-- que indica el tiempo que el led estará encendido (CT)
					S <= '1';
					cuenta := cuenta + 1;
				else
					S <= '0';
					cuenta := cuenta + 1;
				end if;
			else
				s <= '0';
				cuenta := 0;
			end if;
		end if;
	end process;

end Behavioral;