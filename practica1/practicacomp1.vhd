library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity practicacomp1 is 
port(
	reloj: in std_logic;
	d1,d2,d3,d4 : out std_logic_vector(6 downto 0)
);
end;

architecture behavioral of practicacomp1 is
	signal segundo: std_logic;
	signal rapido: std_logic;
	signal n: std_logic;
	signal qs: std_logic_vector(3 downto 0);
	signal qum: std_logic_vector(3 downto 0);
	signal qdm: std_logic_vector(3 downto 0);
	signal qum1: std_logic_vector(3 downto 0) ;
	signal qdm1: std_logic_vector(3 downto 0) ;
	signal e: std_logic;
	signal qr: std_logic_vector(1 downto 0);
	signal quh: std_logic_vector(3 downto 0);
	signal qdh: std_logic_vector(3 downto 0);
	signal quh1: std_logic_vector(3 downto 0) ;
	signal qdh1: std_logic_vector(3 downto 0) ;
	signal z: std_logic;
	signal u: std_logic;
	signal d: std_logic;
	signal reset: std_logic;
	signal bandera: std_logic := '0';
	signal bandera2: std_logic := '0';
	signal i: integer := 0;
	signal alarma: std_logic := '1';
	signal habilitador: std_logic := '0';
	
begin
	divisor: process (reloj)
		variable cuenta: std_logic_vector(27 downto 0) := X"0000000";
	begin
		if rising_edge (reloj) then 
			if cuenta = X"48009E0" then 
				cuenta := X"0000000";
			else
				cuenta := cuenta + 1;
			end if;
		end if;
		segundo <= cuenta(22);
		rapido <= cuenta(10);
	end process;
	
	unidades: process(segundo)
		variable cuenta: std_logic_vector(3 downto 0) := "0000";
	begin
		if rising_edge (segundo) then
			if cuenta = "1001" then 
				cuenta := "0000";
				i <= i+1;
				n <= '1';
				habilitador <= not(habilitador);
			else
				cuenta := cuenta + 1;
				n <= '0';
				habilitador <= not(habilitador);
			end if;
		end if;
		if bandera = '1' and i >= 9 then
			qum <= "0010";
			alarma <= '0';
		else
			qum <= cuenta;
		end if;
	end process;
	
	decenas: process(n)
		variable cuenta: std_logic_vector(3 downto 0) := "0000";
	begin
		if rising_edge (n) then
			if cuenta = "0101" then 
				cuenta := "0000";
				bandera <= '1';
				e <= '1';
			else
				cuenta := cuenta + 1;
				e <= '0';
			end if;
		end if;
		if i >= 9 then 
			qdm <= "0100";
		else
			qdm <= cuenta;
		end if;
	end process;
	
	horau: process(e, reset)
		variable cuenta: std_logic_vector(3 downto 0) := "0000";
	begin
		if rising_edge(e) then
			if cuenta = "1001" then
				cuenta := "0000";
				z <= '1';
			else
				cuenta := cuenta + 1;
				z <= '0';
			end if;
		end if;
		if bandera = '1' then 
			quh <= "0001";
		else
			quh <= cuenta;
		end if;
		u <= cuenta(2);
	end process;
	
	horad: process(z, reset)
		variable cuenta: std_logic_vector(3 downto 0) := "0000";
	begin
		if rising_edge(z) then
			if cuenta = "0010" then
				cuenta := "0000";
			else
				cuenta := cuenta + 1;
			end if;
		end if;
		if reset = '1' then
			cuenta := "0000";
		end if;
		qdh <= "0000";
		d <= cuenta(1);
	end process;
	
	
	
	alrma: process(habilitador, alarma)
	begin
		if bandera = '1' and i >= 9 then
			if habilitador = '1' then
				qum1 <= qum;
				qdm1 <= qdm;
				quh1 <= quh;
				qdh1 <= qdh;
			else
				qum1 <= "1111";
				qdm1 <= "1111";
				quh1 <= "1111";
				qdh1 <= "1111";
			end if;
		else
			qum1 <= qum;
			qdm1 <= qdm;
			quh1 <= quh;
			qdh1 <= qdh;
		end if;
			case qum1 is
				when "0000" => d1 <= "1000000";
				when "0001" => d1 <= "1111001";
				when "0010" => d1 <= "0100100";
				when "0011" => d1 <= "0110000";
				when "0100" => d1 <= "0011001";
				when "0101" => d1 <= "0010010";
				when "0110" => d1 <= "0000010";
				when "0111" => d1 <= "1111000";
				when "1000" => d1 <= "0000000";
				when "1001" => d1 <= "0010000";
				when others => d1 <= "1111111";
			end case;
			
			case qdm1 is
				when "0000" => d2 <= "1000000";
				when "0001" => d2 <= "1111001";
				when "0010" => d2 <= "0100100";
				when "0011" => d2 <= "0110000";
				when "0100" => d2 <= "0011001";
				when "0101" => d2 <= "0010010";
				when "0110" => d2 <= "0000010";
				when "0111" => d2 <= "1111000";
				when "1000" => d2 <= "0000000";
				when "1001" => d2 <= "0010000";
				when others => d2 <= "1111111";
			end case;
			
			case quh1 is
				when "0000" => d3 <= "1000000";
				when "0001" => d3 <= "1111001";
				when "0010" => d3 <= "0100100";
				when "0011" => d3 <= "0110000";
				when "0100" => d3 <= "0011001";
				when "0101" => d3 <= "0010010";
				when "0110" => d3 <= "0000010";
				when "0111" => d3 <= "1111000";
				when "1000" => d3 <= "0000000";
				when "1001" => d3 <= "0010000";
				when others => d3 <= "1111111";
			end case;
			
			case qdh1 is
				when "0000" => d4 <= "1000000";
				when "0001" => d4 <= "1111001";
				when "0010" => d4 <= "0100100";
				when "0011" => d4 <= "0110000";
				when "0100" => d4 <= "0011001";
				when "0101" => d4 <= "0010010";
				when "0110" => d4 <= "0000010";
				when "0111" => d4 <= "1111000";
				when "1000" => d4 <= "0000000";
				when "1001" => d4 <= "0010000";
				when others => d4 <= "1111111";
			end case;
	end process;
end behavioral;