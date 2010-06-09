YamTesto = {
  submitUpdateForm: function(elem) {
    var form = $(elem).parents('form');
    var pwd = form.find('input#user_password');
    if (pwd.val() == '') {
      alert('Password field must be filled out to update');
    } else {
      form.submit();
    }
  }
};
