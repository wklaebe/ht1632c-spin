CON
  CMD_HT1632_SYS_DIS     = %100000000000
  CMD_HT1632_SYS_EN      = %100000000010
  CMD_HT1632_LED_OFF     = %100000000100
  CMD_HT1632_LED_ON      = %100000000110
  CMD_HT1632_BLINK_OFF   = %100000010000
  CMD_HT1632_BLINK_ON    = %100000010010
  CMD_HT1632_SLAVE_MODE  = %100000100000
  CMD_HT1632_MASTER_MODE = %100000110000
  CMD_HT1632_EXTCLK      = %100000111000
  'CMD_HT1632_COMS00      = %100001000000
  CMD_HT1632_COMS01      = %100001001000
  'CMD_HT1632_COMS10      = %100001010000
  'CMD_HT1632_COMS11      = %100001011000
  'CMD_HT1632_PWM01       = %100101000000
  CMD_HT1632_PWM16       = %100101011110


DAT
  PIN_DAT  byte 0
  PIN_WCLK byte 1
  PIN_RCLK byte 2
  PIN_CS
  PIN_CS1  byte 3
  PIN_CS2  byte 4
  PIN_CS3  byte 5
  PIN_CS4  byte 6
  ms       byte 4

PUB Init | m
  dira[PIN_DAT]  := 1
  dira[PIN_WCLK] := 1
  repeat m from 0 to ms-1
    HT1632_Set2416(byte[@PIN_CS][m], m == 0)

PUB numMs
  Result := ms

PRI HT1632_Set2416(p_cs,master)
  dira[p_cs] := 1
  HT1632_Write_Cmd(p_cs,CMD_HT1632_SYS_DIS)
  HT1632_Write_Cmd(p_cs,CMD_HT1632_COMS01)
  if master
    HT1632_Write_Cmd(p_cs,CMD_HT1632_MASTER_MODE)
  else
    HT1632_Write_Cmd(p_cs,CMD_HT1632_SLAVE_MODE)
  HT1632_Write_Cmd(p_cs,CMD_HT1632_SYS_EN)
  HT1632_Write_Cmd(p_cs,CMD_HT1632_LED_ON)
  HT1632_Write_Cmd(p_cs,CMD_HT1632_PWM16)

PRI HT1632_Tx_Bit(bit)
  outa[PIN_DAT] := bit
  outa[PIN_WCLK] := 0
  outa[PIN_WCLK] := 1

PRI HT1632_Tx_Bits(bits,count)
  repeat count
    HT1632_Tx_Bit(bits & 1)
    bits >>= 1

PRI HT1632_Write_Bits(bits,count)
  bits ><= count
  HT1632_Tx_Bits(bits, count)

PRI HT1632_Write_Cmd(p_cs,command)
  outa[p_cs] := 0
  HT1632_Write_Bits(command, 12)
  outa[p_cs] := 1

PRI HT1632_Write_Addr(address)
  HT1632_Write_Bits(%101, 3)
  HT1632_Write_Bits(address & $7F,7)

PUB Draw(data) | m,i
  repeat m from 0 to ms-1
    outa[byte[@PIN_CS][m]] := 0
    HT1632_Write_Addr(0)
    repeat i from 0 to 23
      HT1632_Tx_Bits(word[data][24*m+i],16)
    outa[byte[@PIN_CS][m]] := 1

' EOF
