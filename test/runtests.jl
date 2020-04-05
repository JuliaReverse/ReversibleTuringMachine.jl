using ReversibleTuringMachine
using Test
using NiLang

@testset "inst" begin
    tape = [BLANK, 1, 1, 0, 0, 1]
    q = 3
    rule = Quadruple(3, 1, 0, 2)
    @instr ReversibleTuringMachine.inst(q, tape[3], rule, 3)
    @test q == 2
    @test tape[3] == 0
end

@testset "rtm" begin
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

    @test prog isa Vector{Quadruple{Int,Int}}

    rtm = RTM(1,6,prog)
    tape = [BLANK, 1, 1, 0, 0, 1, BLANK]
    loc = 1
    pc = 1
    @instr run!(rtm, tape, loc, pc)
    @test tape == [BLANK, 0, 0, 1, 0, 1, BLANK]
    @instr (~run!)(rtm, tape, loc, pc)
    @test tape == [BLANK, 1, 1, 0, 0, 1, BLANK]
end
