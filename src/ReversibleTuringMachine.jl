module ReversibleTuringMachine

using NiLang

export RTM, Quadruple, quadruples
export run!, is_deterministic, is_reversible
export BLANK, SLASH, LEFT, RIGHT, STAY

const BLANK = -10000000
const SLASH = -10000001
const LEFT = -10000002
const RIGHT = -10000003
const STAY = -10000004

struct RTM{QT,RT}
    qs::QT
    qf::QT
    rules::RT
end

struct Quadruple{QT, ST}
    q1::QT
    s1::ST
    s2::ST
    q2::QT
end

function quadruples(rules)
    [Quadruple(rules[i,:]...) for i=1:size(rules, 1)]
end

Base.show(io::IO, ::MIME"text/plain", state::Quadruple) = show(io, state)
function Base.show(io::IO, state::Quadruple)
    q1, s1, s2, q2 = state.q1, state.s1, state.s2, state.q2
    print(io, q1, ' ')
    if s1 == SLASH  # move rule
        print(io, "/ ")
        if s2 == RIGHT
            print(io, "→ ")
        elseif s2 == LEFT
            print(io, "← ")
        elseif s2 == STAY
            print(io, "↔ ")
        else
            error("wrong argument for SLASH rule $s2.")
        end
    elseif s1 >= 0 || s1 == BLANK # symbol rule
        print(io, s1 == BLANK ? '_' : s1, ' ')
        print(io, s2 == BLANK ? '_' : s2, ' ')
    end
    print(io, q2)
end

function is_deterministic(rtm::RTM)
    n = length(rtm.rules)
    for i = 1:n
        for j = i+1:n
            ri = rtm.rules[i]
            rj = rtm.rules[j]
            if ri.q1 == rj.q1 && ri.s1 == rj.s1
                return false
            elseif ri.q1 == rj.q1 && (ri.s1 == SLASH || rj.s1 == SLASH)
                return false
            end
        end
    end
    true
end

function is_reversible(rtm::RTM)
    n = length(rtm.rules)
    for i = 1:n
        for j = i+1:n
            ri = rtm.rules[i]
            rj = rtm.rules[j]
            if ri.q2 == rj.q2 && ri.s2 == rj.s2
                return false
            elseif ri.q2 == rj.q2 && (ri.s1 == SLASH || rj.s1 == SLASH)
                return false
            end
        end
    end
    true
end

@i function run!(rtm::RTM, tape, loc, pc)
    q ← rtm.qs
    while (q != rtm.qf, q != rtm.qs)
        # state q, at loc
        inst(q, tape[loc], rtm.rules[pc], loc)
        pc += identity(1)
        if (pc == length(rtm.rules)+1, pc == 1)
            pc -= identity(length(rtm.rules))
        end
    end
    q → rtm.qf
end

@i function inst(q, s, cmd::Quadruple, loc)
    if (q == cmd.q1 && s == cmd.s1, q == cmd.q2 && s == cmd.s2)
        # Symbol rule
        q += cmd.q2 - cmd.q1
        s += cmd.s2 - cmd.s1
    elseif (q == cmd.q1 && cmd.s1 == SLASH, q == cmd.q2 && cmd.s1 == SLASH)
        # Shift rule
        q += cmd.q2 - cmd.q1
        if (cmd.s2 == RIGHT, ~)
            loc += identity(1)
        elseif (cmd.s2 == LEFT, ~)
            loc -= identity(1)
        end
    end
end

end # module
