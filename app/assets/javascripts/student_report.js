
$(function () {
    $('#graduation-status').on('change', (e) => {
        $status = e.target.value;
        if ($status == "approved") {
            $("#gc-year").attr({ "required": true, "disabled": false })
            $("#student-report-semester").attr({ 'disabled': 'disabled', "required": false })
            $("#student-report-year").attr({ 'disabled': 'disabled', "required": false })
            setGcYear($status)
        } else {
            $("#gc-year").attr({ "required": false, "disabled": true })
            $("#student-report-year").attr({ 'disabled': false, "required": true })
            $("#student-report-semester").attr({ 'disabled': false, "required": true })
            setProgram($status)
        }
        $.ajax({
            type: "GET",
            url: "/student/report",
            dataType: "json",
            data: { graduation_status: $status },
            success: function (result) {
                $tbody = $("#payment-report-student-list")
                if (result == []) {
                    $tbody.text("We didn't find a student")
                } else {
                    $tbody.text("")
                    for (let i = 0; i < result.length; i++) {
                        date = new Date(result[i].date_of_birth)
                        day = date.getDate() < 10 ? `0${date.getDate()}` : date.getDate()
                        month = date.getMonth() < 10 ? `0${date.getMonth()}` : date.getMonth()
                        $tr = $("<tr> </tr>")
                        $td = $("<td>  </td>")
                        $tr.append(`<td>${result[i].student_id}</td>+
                            <td>${result[i].first_name + " " +
                            result[i].last_name}</td>+
                            <td class='year'>${result[i].year}</td>+
                            <td class='semester'>${result[i].semester}</td>+
                            <td>${result[i].gender}</td>+
                             <td>${day + "/" + month + "/" + date.getFullYear()}</td>+    
                            <td class=${result[i].study_level}>${result[i].study_level}</td>+
                            <td class='admission_type'>${result[i].admission_type}</td>`);
                        $tbody.append($tr)
                    }
                }
            }
        })

    })

    const setGcYear = (status) => {
        $.ajax({
            type: "GET",
            url: "/student/report/gc/year",
            dataType: "json",
            data: { graduation_status: status },
            success: function (result) {
                $studentGc = $("#gc-year")
                $studentGc.text("")
                $studentGc.append($(`<option value=''>All</option>`))
                for (let i = 0; i < result.length; i++) {
                    $studentGc.append($(`<option value=${result[i].graduation_year}>${result[i].graduation_year}</option>`))
                }
            }
        })
    }
    const setProgram = (status) => {
        $.ajax({
            type: "GET",
            url: "/student/report/program",
            dataType: "json",
            data: { graduation_status: status },
            success: function (result) {
                $studentYear = $("#student-report-program")
                $studentYear.text("")
                $studentYear.append($(`<option value=''>Program </option>`))
                for (let i = 0; i < result.length; i++) {
                    $studentYear.append($(`<option value=${result[i].program_id}>${result[i].program.program_name}</option>`))
                }
            }
        })
    }

    const setYear = (program) => {
        $.ajax({
            type: "GET",
            url: "/student/report/year",
            dataType: "json",
            data: { program: program },
            success: function (result) {
                $studentYear = $("#student-report-year")
                $studentYear.text("")
                $studentYear.append($(`<option value=''>Year </option>`))

                for (let i = 0; i < result.length; i++) {
                    $studentYear.append($(`<option value=${result[i].year}>Year ${result[i].year}</option>`))
                }
            }
        })
    }

    const get_semester = (year) => {
        $.ajax({
            type: "GET",
            url: "/student/report/semester",
            dataType: "json",
            data: { year: year },
            success: function (result) {
                $studentSemester = $("#student-report-semester")
                $studentSemester.text("")
                $studentSemester.append($(`<option value=''>Semester </option>`))
                for (let i = 0; i < result.length; i++) {
                    $studentSemester.append($(`<option value=${result[i].semester}>Semester ${result[i].semester}</option>`))
                }
            }
        })
    }

    // filter by program
    $('#student-report-program').on('change', (e) => {
        $value = e.target.value.toLowerCase();
        setYear($value)

        // $(`.year:contains(${$value})`).parent().show();
        // $(`.year:not(:contains(${$value}))`).parent().hide();
    })

    // filter by gc year 
    $('#gc-year').on('change', (e) => {
        $value = e.target.value.toLowerCase();
        gcProgram($value)
        // $(`.year:contains(${$value})`).parent().show();
        // $(`.year:not(:contains(${$value}))`).parent().hide();
    })


    // filter by year 
    $('#student-report-year').on('change', (e) => {
        $value = e.target.value.toLowerCase();
        get_semester($value)
        $(`.year:contains(${$value})`).parent().show();
        $(`.year:not(:contains(${$value}))`).parent().hide();
    })

    // filter by semester 
    $('#student-report-semester').on('change', (e) => {
        $value = e.target.value.toLowerCase();
        $(`.semester:contains(${$value})`).parent().show();
        $(`.semester:not(:contains(${$value}))`).parent().hide();
    })

    // filter by study level 
    $('#study-report-level').on('change', (e) => {
        $value = e.target.value.toLowerCase();
        if ($value.trim() == "undergraduate") {
            $('.undergraduate').parent().show();
            $('.graduate').parent().hide();
        } else {
            $('.undergraduate').parent().hide();
            $('.graduate').parent().show();
        }

    })

    // filter by admission type 
    $('#admission-report-type').on('change', (e) => {
        $value = e.target.value.toLowerCase();
        $(`.admission_type:contains(${$value})`).parent().show();
        $(`.admission_type:not(:contains(${$value}))`).parent().hide();
    })


    // ================== GC Pogram ================
    const gcProgram = (gc_year) => {
        $.ajax({
            type: "GET",
            url: "/student/gc/program",
            dataType: "json",
            data: { gc_year: gc_year },
            success: function (result) {
                $studentYear = $("#student-report-program")
                $studentYear.text("")
                $studentYear.append($(`<option value=''> All </option>`))
                for (let i = 0; i < result.length; i++) {
                    $studentYear.append($(`<option value=${result[i].program_id}>${result[i].program.program_name}</option>`))
                }
            }
        })
    }
});