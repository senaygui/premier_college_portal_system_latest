
$(function () {
    $('#student-departement').on('change', (e) => {
        $id = e.target.value;
        $.ajax({
            type: "GET",
            url: "/payment/report/fetch/student",
            dataType: "json",
            data: { department_id: $id },
            success: function (result) {
                $tbody = $("#payment-report-student-list")
                if (result == []) {
                    $tbody.text("We didn't find a student")
                } else {
                    $tbody.text("")
                    for (let i = 0; i < result.length; i++) {
                        $tr = $("<tr> </tr>")
                        $td = $("<td>  </td>")
                        $tr.append(`<td>${result[i].student.first_name + " " +
                            result[i].student.last_name}</td><td>${result[i].year}</td>+
                            <td>${result[i].semester}</td>+
                            <td>${result[i].total_price}</td>+
                            <td class='remaining_amount'>${result[i].remaining_amount}</td>+
                            <td>${result[i].actual_payment}</td>+
                            <td>${result[i].study_level}</td>+
                            <td>${result[i].admission_type}</td>`);
                        $tbody.append($tr)
                    }
                    setYear($id)
                }
            }
        })
    })

    const setYear = (id) => {
        $.ajax({
            type: "GET",
            url: "/get/year",
            dataType: "json",
            data: { dept: id },
            success: function (result) {
                $studentYear = $("#student-year")
                $studentYear.text("")
                for (let i = 0; i < result.length; i++) {
                    $studentYear.append($(`<option value=${result[i].year}>Year ${result[i].year}</option>`))
                    get_semester(result[i].year)
                }
            }
        })
    }

    const get_semester = (year) => {
        $.ajax({
            type: "GET",
            url: "/get/semester",
            dataType: "json",
            data: { year: year },
            success: function (result) {
                $studentSemester = $("#student-semester")
                $studentSemester.text("")
                for (let i = 0; i < result.length; i++) {
                    $studentSemester.append($(`<option value=${result[i].semester}>Semester ${result[i].semester}</option>`))
                }
            }
        })
    }
    // filter by year 
    $('#student-year').on('change', (e) => {
        $value = e.target.value.toLowerCase();
        $("#payment-report-student-list tr").filter(function () {
            $(this).toggle($(this).text().toLowerCase().indexOf($value) > -1)
        });
    })
    // filter by semester 
    $('#student-semester').on('change', (e) => {
        $value = e.target.value.toLowerCase();
        $("#payment-report-student-list tr").filter(function () {
            $(this).toggle($(this).text().toLowerCase().indexOf($value) > -1)

        });
    })
    // filter by study level 
    $('#study-level').on('change', (e) => {
        $value = e.target.value.toLowerCase();
        $("#payment-report-student-list tr").filter(function () {
            $(this).toggle($(this).text().toLowerCase().indexOf($value) > -1)
        });
    })
    // filter by admission type 
    $('#admission-type').on('change', (e) => {
        $value = e.target.value.toLowerCase();
        $("#payment-report-student-list tr").filter(function () {
            $(this).toggle($(this).text().toLowerCase().indexOf($value) > -1)
        });
    })

    // filter by remaining status  
    $('#remaining-status').on('change', (e) => {
        $value = e.target.value.toLowerCase();
        if ($value == "true") {
            $(".remaining_amount:contains(0.0)").parent().show();
            $(".remaining_amount:not(:contains(0.0))").parent().hide();
        } else if ($value == "false") {
            $(".remaining_amount:contains(0.0)").parent().hide();
            $(".remaining_amount:not(:contains(0.0))").parent().show();
        }
    })
});