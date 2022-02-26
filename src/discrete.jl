const IVec8 = SVector{8, Int}

struct DSubHuntPOMDP <: POMDP{SubState, Int, IVec8}
    cp::SubHuntPOMDP
    binsize::Float64
end

struct DSubObsDist
    cd::SubObsDist
    binsize::Float64
end

Base.rand(rng::AbstractRNG, d::DSubObsDist) = floor.(Int, (rand(rng, d.cd)./d.binsize)::Vec8)::IVec8

function Distributions.pdf(d::DSubObsDist, o::IVec8)
    p = 1.0
    cd = d.cd
    for i in 1:length(o)
        lo = d.binsize * o[i] 
        hi = lo + d.binsize
        if i == cd.abeam
            p *= cdf(cd.an, hi) - cdf(cd.an, lo)
        else
            p *= cdf(cd.n, hi) - cdf(cd.n, lo)
        end
    end
    return p
end

observation(p::DSubHuntPOMDP, a::Int, sp::SubState) = DSubObsDist(observation(p.cp, a, sp), p.binsize)
n_states(p::DSubHuntPOMDP) = n_states(p.cp)
stateindex(p::DSubHuntPOMDP, s::SubState) = stateindex(p.cp, s)
states(p::DSubHuntPOMDP) = states(p.cp)
initialstate_distribution(p::DSubHuntPOMDP) = initialstate_distribution(p.cp)
actions(p::DSubHuntPOMDP) = actions(p.cp)
actionindex(p::DSubHuntPOMDP, i::Int) = actionindex(p.cp, i)
n_actions(p::DSubHuntPOMDP) = n_actions(p.cp)
transition(p::DSubHuntPOMDP, s::SubState, a::Int) = transition(p.cp, s, a)
discount(p::DSubHuntPOMDP) = discount(p.cp)
isterminal(p::DSubHuntPOMDP, s::SubState) = isterminal(p.cp, s)
reward(p::DSubHuntPOMDP, s::SubState, a::Int, sp::SubState) = reward(p.cp, s, a, sp)
