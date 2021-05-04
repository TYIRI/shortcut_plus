// ページ更新でtag-it発火
$(document).on('turbolinks:load', function() {
  $('#recipe-tags').tagit({  // 指定のセレクタに、tag-itを反映
    fieldName: 'tag_list',
    tagLimit:10,         // タグの最大数
    singleField: true,   // タグの一意性
    placeholderText: 'タグ(スペース区切りで10個まで)'
  });
  tag_string = $('#tag_hidden').val();
  $(".tagit-new").addClass(
    'w-100');
  // $(".ui-widget-content.ui-autocomplete-input").attr(
  //   'placeholder','タグ(スペース区切りで10個まで入力できます)');
  try {
    tag_list = tag_string.split(',');
    results = [];
    for (i = 0, len = tag_list.length; i < len; i++) {
      tag = tag_list[i];
      results.push($('#recipe-tags').tagit('createTag', tag));
    }
    return results;
  } catch (_error) {
    error = _error;
  }
});

// タグ入力が行われたときの処理
$(document).on("keyup", '.tagit', function() {
  // placeholderを消す
  // $(".ui-widget-content.ui-autocomplete-input").removeAttr('placeholder');
  
  // // 空ならばplaceholderを表示
  // let tag_count = $(".tagit-choice").length    // 登録済みのタグを数える
  // if(tag_count === 0) {
  //   $(".ui-widget-content.ui-autocomplete-input").attr(
  //     'placeholder','タグ(スペース区切りで10個まで入力できます)');
  // }

  // Ajaxでタグ一覧を取得
  let input = $(".ui-widget-content.ui-autocomplete-input").val();
  $.ajax({
    type: 'GET',
    url: 'get_tag_search', // routesで設定のURL
    data: { key: input }, // 入力値を:keyとしてcontrollerに渡す
    dataType: 'json'
  })

  .done(function(data){
    if(input.length) {
      let tags = [];
      data.forEach(function(tag) {
        tags.push(tag.name);
      });
      $("#recipe-tags").tagit({
        availableTags: tags // 自動補完する一覧を配列で設定できるtag-itの機能（取得したタグ一覧を渡す）
      });
    }
  })
});
