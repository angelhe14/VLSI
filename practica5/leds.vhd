library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity basica is 
    Port (
        clk: in std_logic;
        led1: out std_logic;
        led2: out std_logic;
        led3: out std_logic;
        led4: out std_logic;
		  led5: out std_logic;
        led6: out std_logic;
        led7: out std_logic;
        led8: out std_logic);
end basica;


architecture behavioral of basica is
    component divisor is
        Generic(N : integer := 24);
        Port (
            clk: in std_logic;
            div_clk: out std_logic);
    end component;

    component PWM is 
        Port (
            Reloj: in std_logic;
            D : in std_logic_vector (7 downto 0);
            S: out std_logic);
    end component;

    signal relojPWM : std_logic;
    signal relojCiclo : std_logic;
    signal a1 : std_logic_vector (7 downto 0) := X"08";
    signal a2 : std_logic_vector (7 downto 0) := X"20";
    signal a3 : std_logic_vector (7 downto 0) := X"60";
    signal a4 : std_logic_vector (7 downto 0) := X"F8";
	 signal a5 : std_logic_vector (7 downto 0) := X"00";
    signal a6 : std_logic_vector (7 downto 0) := X"00";
    signal a7 : std_logic_vector (7 downto 0) := X"00";
    signal a8 : std_logic_vector (7 downto 0) := X"00";

begin 
    D1: divisor generic map (10) port map (clk, relojPWM);
    D2: divisor generic map (23) port map (clk, relojCiclo);
    P1: PWM port map (relojPWM, a1, led1);
    P2: PWM port map (relojPWM, a2, led2);
    P3: PWM port map (relojPWM, a3, led3);
    P4: PWM port map (relojPWM, a4, led4);
	 P5: PWM port map (relojPWM, a5, led5);
    P6: PWM port map (relojPWM, a6, led6);
    P7: PWM port map (relojPWM, a7, led7);
    P8: PWM port map (relojPWM, a8, led8);

    process (relojCiclo)	
	 variable sentido : std_logic := '0'; 
    begin 
        if relojCiclo='1' and relojCiclo'event then 
            if sentido = '0' then 
                if a8 = X"F8" then 
                    sentido := '1'; 
                    a8 <= X"08"; 
                    a7 <= X"20"; 
                    a6 <= X"60"; 
                    a5 <= X"F8"; 
                    a4 <= X"F9"; 
                    a3 <= X"00"; 
                    a2 <= X"00"; 
                    a1 <= X"00"; 
                else 
                    a1 <= a8; 
                    a2 <= a1; 
                    a3 <= a2; 
                    a4 <= a3; 
                    a5 <= a4; 
                    a6 <= a5; 
                    a7 <= a6; 
                    a8 <= a7; 
                end if; 
            else 
                if a1 = X"F8" then 
                    sentido := '0'; 
                    a1 <= X"08"; 
                    a2 <= X"20"; 
                    a3 <= X"60"; 
                    a4 <= X"F8"; 
                    a5 <= X"00"; 
                    a6 <= X"00"; 
                    a7 <= X"00"; 
                    a8 <= X"00"; 
                else 
                    a7 <= a8; 
                    a6 <= a7; 
                    a5 <= a6;  
                    a4 <= a5; 
                    a3 <= a4; 
                    a2 <= a3; 
                    a1 <= a2;        
                end if; 
            end if; 
        end if; 
    end process; 

end Behavioral;
	