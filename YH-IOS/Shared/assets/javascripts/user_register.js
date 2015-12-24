(function() {
  $(document).ready(function() {
    var randomNumber;
    randomNumber = function(min, max) {
      return Math.floor(Math.random() * (max - min + 1) + min);
    };
    $("#captchaOperation").html([randomNumber(1, 100), "+", randomNumber(1, 200), "="].join(" "));
    $("#registerForm").bootstrapValidator({
      message: "填写项不符全要求.",
      feedbackIcons: {
        valid: "glyphicon glyphicon-ok",
        invalid: "glyphicon glyphicon-remove",
        validating: "glyphicon glyphicon-refresh"
      },
      fields: {
        "user[name]": {
          validators: {
            stringLength: {
              min: 3,
              max: 30,
              message: "用户名称长度应在3-30字母之间."
            },
            regexp: {
              regexp: /^[a-zA-Z0-9_\.]+$/,
              message: "用户名称应由字母、数字、下划线、逗点组成."
            }
          }
        },
        "user[email]": {
          validators: {
            notEmpty: {
              message: "登陆邮箱为必填项."
            },
            emailAddress: {
              message: "邮箱地址无效."
            },
            remote: {
              type: "post",
              delay: true,
              url: "/users/check_email_exist",
              message: "该邮箱已被注册"
            }
          }
        },
        "user[password]": {
          validators: {
            notEmpty: {
              message: "登陆密码为必填项."
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
        },
        confirm_password: {
          validators: {
            notEmpty: {
              message: "确认密码为必填项."
            },
            identical: {
              field: "user[password]",
              message: "确认密码与登陆密码不一致."
            },
            different: {
              field: "user[name]",
              message: "确认密码不可以包含用户名称."
            }
          }
        },
        captcha: {
          validators: {
            callback: {
              message: "计算错误.",
              callback: function(value, validator) {
                var items, sum;
                items = $("#captchaOperation").html().split(" ");
                sum = parseInt(items[0]) + parseInt(items[2]);
                value = parseInt(value);
                return value === sum;
              }
            }
          }
        }
      }
    });
    $("#validateBtn").click(function() {
      return $("#registerForm").bootstrapValidator("validate");
    });
    return $("#resetBtn").click(function() {
      return $("#registerForm").data("bootstrapValidator").resetForm(true);
    });
  });

}).call(this);
