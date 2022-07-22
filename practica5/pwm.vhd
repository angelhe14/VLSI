library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity PWM is
    port(
        Reloj :in std_logic;
        D: in std_logic_vector (7 downto 0);
        S: out std_logic
    );
end PWM;

architecture Behavioral of PWM is
begin
        process(Reloj)
            variable Cuenta: integer range 0 to 255:=0;
        begin
            if Reloj='1' and Reloj'event then
                Cuenta := (Cuenta+1) mod 256;
                if Cuenta<D then
                    S<='1';
                else
                    S<='0';
                end if;
            end if;
        end process;
end Behavioral;