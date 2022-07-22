library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity comp2 is 
  port( Clk       : IN STD_LOGIC;
          INICIO    : IN STD_LOGIC;
		    SW1			: IN STD_LOGIC;
		    SW2			: IN STD_LOGIC;
		    SW3			: IN STD_LOGIC;
		    SW4			: IN STD_LOGIC;
			 bandera    : out std_logic;
        TX_WIRE   : OUT STD_LOGIC);
end entity;

architecture behavioral OF comp2 IS
  signal baud       : STD_LOGIC_VECTOR(2 downto 0);
  signal pulso      : STD_LOGIC:='0';
  signal flag      : STD_LOGIC;
  signal contador   : integer range 0 to 49999999 := 0;
  signal dato_bin_0   : STD_LOGIC;
  signal dato_bin_1   : STD_LOGIC;
  signal dato_bin_2   : STD_LOGIC;
  signal dato_bin_3   : STD_LOGIC;
  signal hex_val   : STD_LOGIC_VECTOR(7 downto 0):=(others=>'0');
  signal hex_val_0    : STD_LOGIC_VECTOR(7 downto 0):=(others=>'0');
  signal hex_val_1    : STD_LOGIC_VECTOR(7 downto 0):=(others=>'0');
  signal hex_val_2    : STD_LOGIC_VECTOR(7 downto 0):=(others=>'0');
  signal hex_val_3    : STD_LOGIC_VECTOR(7 downto 0):=(others=>'0');

  U1: entity work.transmisor(behavioral) port map(Clk,INICIO,hex_val,baud,bandera,TX_WIRE);

begin 
  TX_divisor  : process(Clk, INICIO)
  begin 
    if rising_edge(Clk) then 
      contador<=contador + 1;
      if (contador < 50000000) then 
        pulso <= '1';
      else 
        pulso <= '0';
      end if; 
    end if;
  end process TX_divisor;
  
  TX_SELECTOR: process(clk)
	  variable i: integer := 0;
	  variable salida: STD_LOGIC_VECTOR(7 downto 0);
  begin
  if rising_edge(Clk) then 
	if i = 0 then    --Switch 1
		salida := hex_val_0;
		i := i+1;
	elsif i = 1 then --Switch 2
		salida := hex_val_1;
		i := i+1;
	elsif i = 2 then --Switch 3
		salida := hex_val_2;
		i := i+1;
	elsif i = 3 then --Switch 4
		salida := hex_val_3;
		i := i+1;
	elsif i = 4 then 
		salida := X"0A"; 
		i := 0;
	end if;
  end if;
  hex_val <= salida;
  end process TX_SELECTOR;

  baud <= "011";
  dato_bin_0 <= SW1;
  dato_bin_1 <= SW2;
  dato_bin_2 <= SW3;
  dato_bin_3 <= SW4;
  
  with(dato_bin_0) select 
    hex_val_0 <=  X"30" when '0',
                X"31" when '1';
				
  with(dato_bin_1) select 
    hex_val_1 <=  X"30" when '0',
                  X"31" when '1';
					 
  with(dato_bin_2) select 
    hex_val_2 <=  X"30" when '0',
                  X"31" when '1';
					 
					 
  with(dato_bin_3) select 
    hex_val_3 <=  X"30" when '0',
                  X"31" when '1';

 
end architecture behavioral;