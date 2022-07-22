library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Se nos pide una señal de reloj con una frecuencia dada por el usuario y
--que tenga un ciclo de trabajo definido por el usuario.
--Se genera la siguiente entidad con las variables necesarias.
entity actcomp is
Port ( sreloj : in std_logic; 
		 Hz : in std_logic_vector (4 downto 0);
		 ciclo : in std_logic_vector (4 downto 0); --se usan 5 Switchs cuyo valor va de 00000 a 11111 
		 led : out std_logic); --El led de salida 
end actcomp;

architecture Behavioral of actcomp is
	
	signal freclk : integer := 50000000; 	--Reloj
	signal frec_usuario : integer := 0;	--Varianle que almacena la frecuencia proporcionada por el usuario
	signal ciclo_trabajo_usr : integer := 0;--Ciclo Trabajo proporcionado por el usuario

begin

	USR_CICLO_TRABAJO : process(ciclo)	
		variable ct : integer := 0; 
	begin
		ct := to_integer(unsigned(ciclo));
		ciclo_trabajo_usr <= ct;
	end process;
	
	
	USR_FRECUENCIA : process(Hz)	
		variable fq : integer := 0;
	begin
	 fq := to_integer(unsigned(Hz));
	 frec_usuario <= fq;
	end process;
	
	
	SALIDA : process (sreloj)	--Manejo del led de acuerdo a los dados por el usuario
		variable cuenta: integer := 0;
		begin
		if rising_edge (sreloj) then  
			if cuenta < freclk/frec_usuario then -- Esta relación nos da el valor máximo al que se llega	
				if cuenta <= ((freclk/frec_usuario)*(ciclo_trabajo_usr))/100 then--Proporciona el tiempo de encendido
					led <= '1';
					cuenta := cuenta + 1;
				else
					led <= '0';
					cuenta := cuenta + 1;
				end if;
			else
				led <= '0';
				cuenta := 0;
			end if;
		end if;
	end process;

end Behavioral;