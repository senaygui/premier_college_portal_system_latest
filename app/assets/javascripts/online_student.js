
$(function () {
    $("#online-student-status").on("change", (e) => {
        $status = e.target.value
        if ($status == "approved") {
            approvalStatus()

        } else {
            pendingStatus()
        }

    })

    $('#online-student-semester').on('change', (e) => {

        $semester = e.target.value
        $year = $("#online-student-year").val()
        $department = $("#online-student-department").val()
        $approvalStatus = $("#online-student-status").val()

        if ($year == "" || $department == "" || $approvalStatus == "") {
            alert("either deaprtment, approval status or Year is empty")
        } else {

            $.ajax({
                type: "GET",
                url: "/online/student/grade",
                dataType: "json",
                data: { department_id: $department, year: $year, semester: $semester, status: $approvalStatus },
                success: function (result) {
                    $tbody = $("#online-student-list")
                    if (result.length == 0) {
                        // $tbody.text("")
                        approvalStatus();
                        $tbody.append("<p class='alert alert-danger'>We didn't find a student</p>")
                    } else {
                        // $tbody.text("")
                        // pendingStatus();
                        for (let i = 0; i < result.length; i++) {
                            $tr = $("<tr> </tr>")
                            $td = $("<td>  </td>")
                            $tr.append(`<td>${result[i].student.first_name + " " +
                                result[i].student.last_name}</td><td id='online-year'>${result[i].student.year}</td>+
                            <td id='onine-semester'>${result[i].student.semester}</td>+
                            <td>${result[i].letter_grade == null ? "No Grade" : result[i].letter_grade}</td>+
                            <td>${result[i].assesment_total == null ? "No Total" : result[i].assesment_total}</td>+
                            <td>${result[i].grade_point == null ? "No Grade Point" : result[i].grade_point}</td>+
                            <td>${result[i].course.course_title}</td>+
                            <td><span class="online-aproval-status">${result[i].department_approval}</span></td>`);
                            $tbody.append($tr)
                        }
                    }
                }
            })
        }



    })

    const approvalStatus = () => {
        $("#approve").prop('disabled', true);
        $("#approve").css({
            backgroundColor: "#666",
            cursor: "default"
        })
    }

    const pendingStatus = () => {
        $("#approve").prop('disabled', false);
        $("#approve").css({
            backgroundColor: "#168C40",
            cursor: "pointer"

        })
    }
})