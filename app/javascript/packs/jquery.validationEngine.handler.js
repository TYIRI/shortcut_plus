$(document).on('turbolinks:load', function(){

  $("#signup-form").validationEngine( 'attach', {
    promptPosition: "inline",
    maxErrorsPerField: 1,
    addFailureCssClassToField: "invalid",
    "custom_error_messages": {
      "#user_name": {
        "required": {
          "message": "ユーザー名を入力してください"
        }
      },
      "#user_email": {
        "required": {
          "message": "メールアドレスを入力してください"
        }
      },
      "#user_password": {
        "required": {
          "message": "パスワードを入力してください"
        }
      },
      "#user_password_confirmation": {
        "required": {
          "message": "パスワード再入力を入力してください"
        }
      }
    }
  });
  $("#user_name").bind("jqv.field.result", function(event, field, errorFound, prompText){
    if(errorFound){
      $(".continue").attr("disabled", false);
      $("#user_name").removeClass("invalid");
    } else{
      $(".continue").attr("disabled", true);
    }
  });

  $("#password-reset-form").validationEngine( 'attach', {
    promptPosition: "inline",
    maxErrorsPerField: 1,
    addFailureCssClassToField: "invalid",
    "custom_error_messages": {
      "#user_password": {
        "required": {
          "message": "パスワードを入力してください"
        }
      },
      "#user_password_confirmation": {
        "required": {
          "message": "パスワード再入力を入力してください"
        }
      }
    }
  });
});
