(function() {
  $(document).ready(function() {

    $("#reportForm").bootstrapValidator({
      message: "填写项不符全要求.",
      feedbackIcons: {
        valid: "glyphicon glyphicon-ok",
        invalid: "glyphicon glyphicon-remove",
        validating: "glyphicon glyphicon-refresh"
      },
      fields: {
        "report[report_id]": {
          validators: {
            stringLength: {
              min: 1,
              max: 10,
              message: "长度应在1-10数字之间."
            },
            regexp: {
              regexp: /^[0-9]+$/,
              message: "应由数字组成."
            }
          }
        },
        "report[template_id]": {
          validators: {
            stringLength: {
              min: 1,
              max: 10,
              message: "长度应在1-10数字之间."
            },
            regexp: {
              regexp: /^[0-9]+$/,
              message: "应由数字组成."
            }
          }
        },
        "report[content]": {
          validators: {
            notEmpty: {
              message: "内容不可为空."
            },
            identical: {
              field: "confirm_password",
              message: "登陆密码与确认密码不一致."
            },
            different: {
              field: "user[name]",
              message: "登陆密码不可以与用户名称相同."
            }
          }
        }
      }
    });
    $("#submitBtn").click(function() {
      return $("#submitBtn").bootstrapValidator("validate");
    });
    return $("#resetBtn").click(function() {
      return $("#registerForm").data("bootstrapValidator").resetForm(true);
    });
  });

}).call(this);
