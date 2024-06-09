
$(function () {
    $("#firstName").on ("input", (e)=> {
            const fname = e.target.value; 
            const nameRegex = /^[\sA-Za-z\s]+$/;

            if (!nameRegex.test(fname)) {
                alert("Please Enter only Letters.");
            }   
    });
    
    $("#middleName").on ("input", (e)=> {
        const mname = e.target.value; 
        const nameRegex = /^[\sA-Za-z\s]+$/;

        if (!nameRegex.test(mname)) {
            alert("Please Enter only Letters.");
        }   
    });

    $("#lastName").on ("input", (e)=> {
        const lname = e.target.value; 
        const nameRegex = /^[\sA-Za-z\s]+$/;

        if (!nameRegex.test(lname)) {
            alert("Please Enter only Letters.");
        }   
    });

    $("#city").on ("input", (e)=> {
        const city = e.target.value; 
        const nameRegex = /^[\sA-Za-z\s]+$/;

        if (!nameRegex.test(city)) {
            alert("Please use Letters Only.");
        }   
    });

    $("#contactname").on ("input", (e)=> {
        const cname = e.target.value; 
        const nameRegex = /^[\sA-Za-z\s]+$/;

        if (!nameRegex.test(cname)) {
            alert("Please use Letters Only.");
        }   
    });

    $("#contactphone").on ("input", (e)=> {
        const cphone = e.target.value; 
        const phoneno = /^[0-9]{1,12}$/;

        if (!phoneno.test(cphone)) {
            alert("Please Enter a valid phone number.");
        }   
    });

    $("#college").on ("input", (e)=> {
        const college = e.target.value; 
        const nameRegex = /^[\sA-Za-z\s]+$/;

        if (!nameRegex.test(college)) {
            alert("Please use Letters Only.");
        }   
    });
   
    $("#exampleCheck1").on ("input", (e)=> {
        const check = e.target.value; 
        if (!$('check').prop('checked')) {
            alert("Please agree to the terms and conditions.");
        }   
    });

    $("#collegephone").on ("input", (e)=> {
        const collphone = e.target.value; 
        const phoneno = /^[0-9]{1,12}$/;

        if (!phoneno.test(collphone)) {
            alert("Please Enter a valid phone number.");
        }   
    });

    $("#collegecgpa").on ("input", (e)=> {
        const ccgpa = e.target.value; 
        
        if (ccgpa < 0.0 || ccgpa > 4) {
            alert("Please Enter values from 0.0 to 4.0 only.");
        }   
    });

    $("#accountfullname").on ("input", (e)=> {
        const accname = e.target.value; 
        const nameRegex = /^[\sA-Za-z\s]+$/;

        if (!nameRegex.test(accname)) {
            alert("Please use Letters Only.");
        }
    });

    $("#accountnumber").on ("input", (e)=> {
        const accref = e.target.value; 
        const ref = /^[0-9]{1,13}$/;

        if (!ref.test(accref)) {
            alert("Please Enter a valid account number.");
        }   
    });

    $("#accountphone").on ("input", (e)=> {
        const accphone = e.target.value; 
        const phoneno = /^[0-9]{1,12}$/;

        if (!phoneno.test(accphone)) {
            alert("Please Enter a valid phone number.");
        }   
    });

    $("#accountreference").on ("input", (e)=> {
        const accref = e.target.value; 
        const ref = /^[0-9]{1,20}$/;

        if (!ref.test(accref)) {
            alert("Please Enter a valid reference number.");
        }   
    });

    $("#addressmobile").on ("input", (e)=> {
        const mob = e.target.value; 
        const phoneno = /^[0-9]{1,12}$/;
        if (!phoneno.test(mob)) {
            alert("Please Enter a valid phone number.");
        }   
    });
}); 
          







// const firstName = document.getElementById("firstName");
// const middleName = document.getElementById("middleName");
// const lastName = document.getElementById("lastName");
//
// const nameRegex = /^[A-Za-z]+$/; // Only characters allowed
//
           // if (!nameRegex.test(firstName)) {
           //     alert("First name contains non-character characters");
           // } else if (!nameRegex.test(middleName)) {
           //     alert("Middle name contains non-character characters");
           // } else if (!nameRegex.test(lastName)) {
           //     alert("Last name contains non-character characters");
           // } else {
           //     alert("All names are valid");
           // }
        
