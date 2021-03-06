using JSON

# Takes requisite and return it as a string for the visualization
function requisite_to_string(req::Requisite)
    if req == pre
        return "prereq"
    elseif req == co
        return "coreq"
    else
        return "strict-coreq"
    end
end

# Returns a requisite (enumerated type) from a string
function string_to_requisite(req::String)
    if req == "prereq"
        return pre
    elseif req == "coreq"
        return co
    else
        return strict_co
    end
end

function export_degree_plan(plan::DegreePlan, file_path::String)
    io = open(file_path, "w")
    degreeplan = Dict{String, Any}()
    degreeplan["curriculum"] = Dict{String, Any}()
    degreeplan["curriculum"]["name"] = plan.name
    degreeplan["curriculum"]["curriculum_terms"] = Dict{String, Any}[]
    for i = 1:plan.num_terms
        current_term = Dict{String, Any}()
        current_term["id"] = i
        current_term["name"] = "Term $i"
        current_term["curriculum_items"] = Dict{String, Any}[]
        for course in plan.terms[i].courses
            current_course = Dict{String, Any}()
            current_course["id"] = course.id
            current_course["nameSub"] = course.name
            current_course["name"] =  course.prefix * " " * course.num
            current_course["prefix"] =  course.prefix
            current_course["num"] = course.num
            current_course["credits"] = course.credit_hours
            current_course["curriculum_requisites"] = Dict{String, Any}[]
            current_course["metrics"] = course.metrics
            for req in collect(keys(course.requisites))
                current_req = Dict{String, Any}()
                current_req["source_id"] = req
                current_req["target_id"] = course.id
                # Parse the Julia requisite type to the required type for the visualization
                current_req["type"] = requisite_to_string(course.requisites[req])
                push!(current_course["curriculum_requisites"], current_req)
            end
            push!(current_term["curriculum_items"], current_course)
        end
        push!(degreeplan["curriculum"]["curriculum_terms"], current_term)
    end
    JSON.print(io, degreeplan, 1)
    close(io)
end

function import_degree_plan(file_path::String)
    # read in JSON from curriculum-data.json
    open(file_path, "r") do f
        # Create empty dictionary to hold the imported data
        global degree_plan = Dict()
        filetxt = read(f, String)  # file information to string
        degree_plan=JSON.parse(filetxt)  # parse and transform data
    end
    # Create an array "terms" with elements equal to the number of terms from the file
    num_terms = length(degree_plan["curriculum"]["curriculum_terms"])
    terms = Array{Term}(undef, num_terms)
    all_courses = Array{Course}(undef, 0)
    courses_dict = Dict{Int, Course}()
    # For every term
    for i = 1:num_terms
        # Grab the current term
        current_term = degree_plan["curriculum"]["curriculum_terms"][i]
        # Create an array of course objects with length equal to the number of courses
        courses = Array{Course}(undef, 0)
        # For each course in the current term
        for course in current_term["curriculum_items"]
            # Create Course object for each course in the current term
            current_course = Course(course["nameSub"], course["credits"], prefix = course["prefix"], num = course["num"])
            # Push each Course object to the array of courses
            push!(courses, current_course)
            push!(all_courses, current_course)
            courses_dict[course["id"]] = current_course
        end

        # For each course object create its requisites
        for course in current_term["curriculum_items"]
            # If the course has requisites
            if !isempty(course["curriculum_requisites"])
                # For each requisite of the course
                for req in course["curriculum_requisites"]
                    # Create the requisite relationship
                    source = courses_dict[req["source_id"]]
                    target = courses_dict[req["target_id"]]
                    add_requisite!(source, target, string_to_requisite(req["type"]))
                end
            end
        end
        # Set the current term to be a Term object
        terms[i] = Term(courses)
    end
    curric = Curriculum("Underwater Basket Weaving", all_courses)
    return DegreePlan("MyPlan", curric, terms)
end