$(function() {
  // 編集ボタンをクリック
  $(document).on("click", '.js-edit-comment-button', function(e) {
      e.preventDefault();
      const commentId = $(this).data("comment-id")
      switchToEdit(commentId)
  })

  // 編集のキャンセルボタンをクリック
  $(document).on("click", '.js-button-edit-comment-cancel', function() {
      clearErrorMessages()
      const commentId = $(this).data("comment-id")
      switchToLabel(commentId)
  })

  // 編集の更新ボタンをクリック
  $(document).on("click", '.js-button-comment-update', function() {
      clearErrorMessages()
      const commentId = $(this).data("comment-id")
      submitComment($("#js-textarea-comment-" + commentId).val(), commentId)
          .then(result => {
              $("#js-comment-" + result.comment.id).html(result.content.body.replace(/\r?\n/g, '<br>'))
              switchToLabel(result.comment.id)
          })
          .catch(result => {
              const commentId = result.responseJSON.comment.id
              const messages = result.responseJSON.errors.messages
              showErrorMessages(commentId, messages)
          })
  })

  function switchToLabel(commentId) {
      $("#js-textarea-comment-box-" + commentId).hide()
      $("#js-comment-" + commentId).show()
  }

  function switchToEdit(commentId) {
      $("#js-comment-" + commentId).hide()
      $("#js-textarea-comment-box-" + commentId).show()
  }

  function showErrorMessages(commentId, messages) {
      $('<p class="error_messages invalidError">' + messages.join('<br>') + '</p>').insertAfter($("#js-textarea-comment-" + commentId))
  }

  function submitComment(content, commentId) {
      return new Promise(function(resolve, reject) {
          $.ajax({
              type: 'PATCH',
              url: '/comments/' + commentId,
              data: {
                  comment: {
                      content: content
                  }
              }
          }).done(function (result) {
              resolve(result)
          }).fail(function (result) {
              reject(result)
          });
      })
  }

  function clearErrorMessages() {
      $("p.error_messages").remove()
  }
});