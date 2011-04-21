CON
  CMD_HT1632_SYS_DIS     = %100000000000
  CMD_HT1632_SYS_EN      = %100000000010
  CMD_HT1632_LED_OFF     = %100000000100
  CMD_HT1632_LED_ON      = %100000000110
  CMD_HT1632_BLINK_OFF   = $08
  CMD_HT1632_BLINK_ON    = $09
  CMD_HT1632_SLAVE_MODE  = $10
  CMD_HT1632_MASTER_MODE = %100000110000
  CMD_HT1632_EXTCLK      = $1C
  CMD_HT1632_COMS00      = $20
  CMD_HT1632_COMS01      = %100001001000
  CMD_HT1632_COMS10      = $28
  CMD_HT1632_COMS11      = $2C
  CMD_HT1632_PWM         = $A0
  CMD_HT1632_PWM16       = %100101011110

VAR
  LONG PIN_CS
  LONG PIN_DAT
  LONG PIN_WCLK

PUB Init(p_cs,p_dat,p_wclk)
  PIN_CS := p_cs
  PIN_DAT := p_dat
  PIN_WCLK := p_wclk
  HT1632_Init
  HT1632_Set2416

PRI HT1632_Init
  dira[PIN_CS]   := 1
  dira[PIN_DAT]  := 1
  dira[PIN_WCLK] := 1

PRI HT1632_Set2416
  HT1632_Write_Cmd(CMD_HT1632_SYS_DIS)
  HT1632_Write_Cmd(CMD_HT1632_COMS01)
  HT1632_Write_Cmd(CMD_HT1632_MASTER_MODE)
  HT1632_Write_Cmd(CMD_HT1632_SYS_EN)
  HT1632_Write_Cmd(CMD_HT1632_LED_ON)
  HT1632_Write_Cmd(CMD_HT1632_PWM16)

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

PUB HT1632_Write_Cmd(command)
  outa[PIN_CS] := 0
  HT1632_Write_Bits(command, 12)
  outa[PIN_CS] := 1

PUB HT1632_Write_Addr(address)
  HT1632_Write_Bits(%101, 3)
  HT1632_Write_Bits(address & $7F,7)

PUB HT1632_Print(data) | i
  outa[PIN_CS] := 0

  HT1632_Write_Addr(0)
  repeat i from 0 to 23
    HT1632_Tx_Bits(word[data][i],16)

  outa[PIN_CS] := 1

' EOF
