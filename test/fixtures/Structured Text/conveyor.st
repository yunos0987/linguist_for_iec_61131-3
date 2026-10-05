(* Uppercase keyword style, as exported by many PLC IDEs *)
PROGRAM Conveyor
VAR
    Start   : BOOL;
    Stop    : BOOL;
    Running : BOOL;
    Count   : INT;
    Log     : STRING := 'Conveyor ready$N';
END_VAR

IF Start AND NOT Stop THEN
    Running := TRUE;
ELSIF Stop THEN
    Running := FALSE;
END_IF;

FOR Count := 1 TO 10 DO
    Running := Running AND NOT Stop;
END_FOR;
END_PROGRAM
