$(document).ready(function() {
    $("#business_partner_form").validate({
      // Specify validation rules for each field
      rules: {
        customer_name: "required",
        customer_code: "required",
        corporate_number: {
          required: true,
          minlength: 10,
          maxlength: 10,
          digits: true // Ensures only digits are allowed
        },
        invoice_number: "required",
        address: "required",
        postal_code: {
          required: true,
          digits: true // Ensures only digits are allowed
        },
        telephone_number: {
          required: true,
          minlength: 10,
          maxlength: 10,
          digits: true // Ensures only digits are allowed
        },
        bank_name: "required"
      },
      // Specify validation error messages
      messages: {
        customer_name: "Please select a customer name",
        customer_code: "Please enter a customer code",
        corporate_number: {
          required: "Please enter a corporate number",
          minlength: "Corporate number must be at least 10 digits long",
          maxlength: "Corporate number cannot exceed 10 digits",
          digits: "Corporate number must contain only digits"
        },
        invoice_number: "Please enter an invoice number",
        address: "Please enter an address",
        postal_code: {
          required: "Please enter a postal code",
          digits: "Postal code must contain only digits"
        },
        telephone_number: {
          required: "Please enter a telephone number",
          minlength: "Telephone number must be at least 10 digits long",
          maxlength: "Telephone number cannot exceed 10 digits",
          digits: "Telephone number must contain only digits"
        },
        bank_name: "Please enter a bank name"
      },
      // Specify where to display error messages
      errorPlacement: function(error, element) {
        error.insertAfter(element); // Display error message after the input field
      },
      // Highlight input fields with errors
      highlight: function(element, errorClass, validClass) {
        $(element).addClass(errorClass).removeClass(validClass);
      },
      // Remove highlight from input fields with valid data
      unhighlight: function(element, errorClass, validClass) {
        $(element).removeClass(errorClass).addClass(validClass);
      }
    });
  });
  