using JuMP
using SCIP

debug = false

macro check_array_int_arg(arg, expected_length)
    expected_length_name = string(expected_length)
    quote
        if typeof($(esc(arg))) == Array{Int64, 2} && length($(esc(arg))) != $(esc(expected_length))
            throw(AssertionError(
            "Provided dim " * string(length($(esc(arg)))) * " but expected dim " * string(length($(esc(expected_length)))) * " in " * $expected_length_name * "."
            ))
        end
    end
end

function schedule_timeslots(preferences :: Array{Int, 2},
    min_time_requirements :: Union{Array{Int, 2}, Int} = 0,
    max_time_requirements :: Union{Array{Int, 2}, Int} = typemax(Int),
    min_jobs_per_person :: Union{Array{Int, 2}, Int} = 0,
    max_jobs_per_person :: Union{Array{Int, 2}, Int} = typemax(Int),
    ) :: Array{Int, 2}
    n_people = size(preferences)[1]
    n_timeslots = size(preferences)[2]

    @check_array_int_arg(min_time_requirements, n_timeslots)
    @check_array_int_arg(max_time_requirements, n_timeslots)
    @check_array_int_arg(min_jobs_per_person, n_people)
    @check_array_int_arg(max_jobs_per_person, n_people)

    m = Model(with_optimizer(SCIP.Optimizer))
    @variable(m, t[1:n_people, 1:n_timeslots], Bin)
    @objective(m, Min, sum(t .* preferences))
    @constraint(m, min_time_requirements .<= sum(t, dims=1) .<= max_time_requirements)
    @constraint(m, min_jobs_per_person .<= sum(t, dims=2) .<= max_jobs_per_person)
    if debug
        println(m)
    end

    optimize!(m)
    value.(t)
end

# # Sample
# preferences = [1 2 2 1; 1 1 1 2]
# min_time_requirements = repeat([1], 1, 4)
# max_time_requirements = repeat([1], 1, 4)
# schedule_timeslots(preferences, min_time_requirements, max_time_requirements, 1, 5)
