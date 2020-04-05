using ReversibleTuringMachine
using NiLang

prog = quadruples([
    1 BLANK BLANK 2;
    2 SLASH RIGHT 3;
    3 0     1     4;
    3 1     0     2;
    3 BLANK BLANK 4;
    4 SLASH LEFT  5;
    5 0     0     4;
    5 BLANK BLANK 6;
])

function read_tape(tape)
    sum(tape[2:end-1] .* (1 .<< (0:length(tape)-3)))
end

function main()
    rtm = RTM(1,6,prog)
    tape = [BLANK, 1, 1, 0, 0, 1, BLANK]
    loc = 1
    pc = 1
    println("marching forward")
    for i=1:50
        @instr run!(rtm, tape, loc, pc)
        println("number → $(read_tape(tape))")
    end

    println("marching backward")
    for i=1:50
        @instr (~run!)(rtm, tape, loc, pc)
        println("number → $(read_tape(tape))")
    end
end
