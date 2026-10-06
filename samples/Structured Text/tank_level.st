(* tank_level.st - two-point level control with fill/drain valves and alarm text *)

type
    TankState : (Idle, Filling, Draining, Fault) := Idle;
end_type

function_block TankLevel
var_input
    Level      : real;          (* measured level in percent *)
    LowLimit   : real := 20.0;
    HighLimit  : real := 80.0;
    Reset      : bool;
end_var
var_output
    FillValve  : bool;
    DrainValve : bool;
    Alarm      : bool;
    Message    : string(80);
end_var
var
    State      : TankState;
    FaultTimer : TON;
end_var

FaultTimer(IN := (State = Filling) and (Level < LowLimit), PT := t#30s);

case State of
    Idle:
        if Level < LowLimit then
            State := Filling;
        elsif Level > HighLimit then
            State := Draining;
        end_if;
    Filling:
        if Level >= HighLimit then
            State := Idle;
        elsif FaultTimer.Q then
            State := Fault;
        end_if;
    Draining:
        if Level <= LowLimit then
            State := Idle;
        end_if;
    Fault:
        if Reset then
            State := Idle;
        end_if;
end_case;

FillValve  := State = Filling;
DrainValve := State = Draining;
Alarm      := State = Fault;

if Alarm then
    Message := 'Tank fill timeout$R$L';
else
    Message := '';
end_if;
end_function_block
