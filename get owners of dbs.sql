SELECT suser_sname( owner_sid ), * FROM sys.databases
WHERE owner_sid <> 0x01

