library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity uart_tx is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           tx : out STD_LOGIC;
           led_o : out std_logic);
end uart_tx;

architecture Behavioral of uart_tx is
  signal clk_div : std_logic;
  signal clk_counter : integer range 0 to 2604;
  
  signal tx_bit : integer range 0 to 7;
  
  type tx_state_t is (IDLE, START, DATA, STOP);
  signal tx_state : tx_state_t; 
  
  signal char_tx : std_logic_vector(7 downto 0);
  signal char_pointer : integer range 0 to 10;
  
  signal wait_50 : integer range 0 to 50;
  
begin

-----------------------------------------------------
-- Memoria ROM que almacena el texto a enviar
-----------------------------------------------------
process(char_pointer)
begin

  case(char_pointer) is
     when 0 =>
       char_tx <= conv_std_logic_vector(character'pos('H'),8);
     when 1 =>
       char_tx <= conv_std_logic_vector(character'pos('i'),8);
     when 2 =>
       char_tx <= conv_std_logic_vector(character'pos(' '),8);
     when 3 =>
       char_tx <= conv_std_logic_vector(character'pos('A'),8);
     when 4 =>
       char_tx <= conv_std_logic_vector(character'pos('r'),8);
     when 5 =>
       char_tx <= conv_std_logic_vector(character'pos('a'),8);
     when 6 =>
       char_tx <= conv_std_logic_vector(character'pos('n'),8);
     when 7 =>
       char_tx <= conv_std_logic_vector(character'pos('z'),8);
     when 8 =>
       char_tx <= conv_std_logic_vector(character'pos('a'),8);
     when 9 =>
       char_tx <= conv_std_logic_vector(character'pos('!'),8);
     when 10 =>
       char_tx <= conv_std_logic_vector(character'pos('!'),8);
     when others =>
       char_tx <= (others=>'0');
  end case;       

end process;


-----------------------------------------------------
-- Divisor de reloj de 50Mhz a 9600bps
-----------------------------------------------------

process(clk,reset)
begin
  if (reset='0') then
    clk_div <='0';
  elsif(rising_edge(clk)) then
    if(clk_counter = 2604) then    
      clk_div<=not(clk_div);
      clk_counter <= 0;
    else
      clk_counter <= clk_counter +1;
    end if;
    
  end if;  
 end process;    
  
-----------------------------------------------------
-- Maquina de estados que lee la ROM y forma la trama
-----------------------------------------------------

 process(clk_div,reset)
 begin
  if (reset='0') then
    tx <= '1';
    tx_state <= IDLE;
    tx_bit <= 0;
    led_o <= '0';
    char_pointer <= 0;
    wait_50 <= 0;
  elsif(rising_edge(clk_div)) then
    case(tx_state) is
      when IDLE =>  
        tx <= '1';
        tx_bit <= 0;
        if(wait_50=50) then
          tx_state <= START;
          wait_50 <= 0;
        else
          wait_50 <= wait_50 +1;
        end if;	 
      when START =>
        tx <= '0';
        tx_state <= DATA;
      when DATA =>
        tx <= char_tx(tx_bit);
        if(tx_bit=7) then
          tx_state <= STOP;
        else
          tx_bit <= tx_bit+1;
        end if;
      when STOP =>
        tx <= '1';
        if(char_pointer=10) then
          led_o <= '1';
        else  
          tx_state <= IDLE;
          char_pointer <= char_pointer+1;
        end if;          
     end case;
   end if;
end process;     
end Behavioral;