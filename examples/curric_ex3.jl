## Curriculum assoicated with the University of Houston EE program in 2016

using CurricularAnalytics

# create the courses
c = Array{Course}(undef, 49)
# term 1
c[1] = Course("HIST 1377", 3)
c[2] = Course("ENGL 1303", 3)
c[3] = Course("ENGI 1100", 1)
c[4] = Course("MATH 1431", 4)
c[5] = Course("CHEM 1331", 3)
c[6] = Course("CHEM 1111", 1)
# term 2
c[7] = Course("HIST 1378", 3)
c[8] = Course("ENGL 1304", 3)
c[9] = Course("ENGI 1331", 3)
c[10] = Course("MATH 1432", 4)
c[11] = Course("PHYS 1321", 3)
c[12] = Course("PHYS 1121", 1)
# term 3
c[13] = Course("POLS 1336", 3)
c[14] = Course("MATH 3321", 3)
c[15] = Course("ECE 2201", 3)
c[16] = Course("MATH 2433", 3)
c[17] = Course("PHYS 1322", 3)
c[18] = Course("PHYS 1122", 1)
# term 4
c[19] = Course("ENGI 2304", 3)
c[20] = Course("ECE 3331", 3)
c[21] = Course("ECE 2100", 1)
c[22] = Course("ECE 2202", 3)
c[23] = Course("ECE 3337", 3)
c[24] = Course("ECE 3436", 3)
# term 5
c[25] = Course("Create Arts Core", 3)
c[26] = Course("ECE 3155", 1)
c[27] = Course("ECE 3355", 3)
c[28] = Course("Concentration Elective", 3)
c[29] = Course("ECE 3317", 3)
c[30] = Course("ECE Elective", 3)
# term 6
c[31] = Course("POLS 1337", 3)
c[32] = Course("INDE 2333", 3)
c[33] = Course("Elective Lab", 1)
c[34] = Course("Concentration Elective", 3)
c[35] = Course("ECE 3340", 3)
c[36] = Course("ECE Elective", 3)
# term 7
c[37] = Course("ECON 2304", 3)
c[38] = Course("ECE 4335", 3)
c[39] = Course("Elective Lab", 1)
c[40] = Course("Concentration Elective", 3)
c[41] = Course("Concentration Elective", 3)
c[42] = Course("Tecnical Elective", 3)
# term 8
c[43] = Course("Lang, Phil & Culture Core", 3)
c[44] = Course("ECE 4336", 3)
c[45] = Course("Elective Lab", 1)
c[46] = Course("Concentration Elective", 3)
c[47] = Course("Concentration Elective", 3)
c[48] = Course("Concentration Elective", 3)
c[49] = Course("Elective Lab", 1)

# term 1
add_requisite!(c[2],c[8],pre)
add_requisite!(c[3],c[9],pre)
add_requisite!(c[4],c[3],co)
add_requisite!(c[4],c[9],pre)
add_requisite!(c[4],c[10],pre)
add_requisite!(c[5],c[6],co)
# term 2
add_requisite!(c[8],c[19],pre)
add_requisite!(c[9],c[32],pre)
add_requisite!(c[9],c[15],pre)
add_requisite!(c[10],c[14],pre)
add_requisite!(c[10],c[32],pre)
add_requisite!(c[10],c[16],pre)
add_requisite!(c[10],c[11],co)
add_requisite!(c[11],c[17],pre)
add_requisite!(c[11],c[12],co)
# term 3
add_requisite!(c[14],c[20],pre)
add_requisite!(c[14],c[15],co)
add_requisite!(c[15],c[19],pre)
add_requisite!(c[15],c[20],pre)
add_requisite!(c[15],c[22],pre)
add_requisite!(c[16],c[15],co)
add_requisite!(c[16],c[17],co)
add_requisite!(c[17],c[15],co)
add_requisite!(c[17],c[18],co)
add_requisite!(c[18],c[15],co)
add_requisite!(c[18],c[21],pre)
# term 4
add_requisite!(c[19],c[26],pre)
add_requisite!(c[20],c[35],pre)
add_requisite!(c[20],c[24],co)
add_requisite!(c[21],c[24],co)
add_requisite!(c[21],c[26],pre)
add_requisite!(c[22],c[21],co)
add_requisite!(c[22],c[23],co)
add_requisite!(c[23],c[27],pre)
add_requisite!(c[23],c[29],pre)
add_requisite!(c[24],c[38],pre)
# term 5
add_requisite!(c[26],c[38],pre)
add_requisite!(c[26],c[27],strict_co)
add_requisite!(c[27],c[38],pre)
add_requisite!(c[29],c[38],pre)
# term 6
add_requisite!(c[32],c[38],pre)
add_requisite!(c[35],c[38],pre)
# term 7
add_requisite!(c[37],c[38],co)
add_requisite!(c[38],c[44],pre)

curric = Curriculum("University of Houston EE Program", c)

errors = IOBuffer()
if isvalid_curriculum(curric, errors)
    println("Curriculum $(curric.name) is valid")
    println("  delay factor = $(delay_factor(curric))")
    println("  blocking factor = $(blocking_factor(curric))")
    println("  centrality factor = $(centrality(curric))")
    println("  curricular complexity = $(complexity(curric))")
else
    println("Curriculum $(curric.name) is not valid:")
    print(String(take!(errors)))
end