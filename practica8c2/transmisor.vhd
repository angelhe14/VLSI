library ieee;
use ieee.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

entity transmisor is 
  port( Clk       : in std_logic;
		  inICIO    : in std_logic;
		  dato      : in std_logic_vector(7 downto 0);
        baud      : in std_logic_vector(2 downto 0);
        bandera   : out std_logic;
        TX_WIRE   : out std_logic);
end entity;

architecture behavioral OF transmisor IS
  signal conta      : integer := 0;
  signal valor      : integer := 70000;
  signal dato_env   : std_logic_vector(7 downto 0);
  signal PRE        : integer range 0 TO 5208 := 0;
  signal inDICE     : integer range 0 TO 9 := 0;
  signal BUFF       : std_logic_vector (9 downto 0);
  signal FLAG       : std_logic := '0';
  signal PRE_val    : integer range 0 to 41600;
  signal i          : integer range 0 to 4;
  signal pulso      : std_logic:='0';
  signal contador   : integer range 0 to 49999999 := 0;
  signal dato_bin   : std_logic_vector(3 downto 0);
  signal hex_val    : std_logic_vector(7 downto 0):=(others=>'0');

begin 
  TX_divisor  : process(Clk)
  begin 
    if rising_edge(Clk) then 
      contador<=contador + 1;
      if (contador < 140000) then 
        pulso <= '1';
      else 
        pulso <= '0';
      end if; 
    end if;
  end process TX_divisor;

  TX_prepara : process(Clk, pulso)
    type arreglo is array (0 to 1) of std_logic_vector(7 downto 0);
    variable asc_dato : arreglo := (X"30",X"0A");
  begin
    asc_dato(0) := hex_val;
    if (pulso='1') then 
      if rising_edge(Clk) then 
        if (conta=valor) then
          conta <= 0;
          dato_env <= asc_dato(i);
          if (i=1) then
            i <=0;
          else
            i <= i + 1;
          end if; 
        else
          conta <= conta + 1;
        end if; 
      end if; 
    end if; 
  end process TX_prepara;

  TX_envia : process(Clk,inICIO,dato)
  begin 
    if(Clk'EVENT and Clk = '1') then
      if (Flag = '0' and inICIO = '0') then 
        Flag <= '1';
        BUFF(0) <= '0'; 
        BUFF(9) <= '1'; 
        BUFF(8 DOWNTO 1) <= dato_env; 
      end if;
      if (Flag = '1') then 
        if (PRE < PRE_val) then
          PRE <= PRE + 1; 
        else
          PRE <= 0;
        end if; 
        if(PRE = PRE_val/2) then -
          TX_WIRE <= BUFF(inDICE); 
          if (inDICE < 9) then 
            inDICE <= inDICE + 1;
          else 
            Flag <= '0'; 
            inDICE <= 0;
          end if; 
        end if; 
      end if; 
    end if; 
  end process TX_envia;

  bandera <= pulso;
  hex_val <= dato;


  with(baud) select 
    PRE_val <=  41600 when "000",
                20800 when "001",
                10400 when "010",
                5200  when "011",
                2600  when "100",
                1300  when "101",
                866   when "110",
                432   when others;
                
end architecture behavioral;