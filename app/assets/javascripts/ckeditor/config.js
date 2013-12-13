CKEDITOR.editorConfig = function(config) {
   config.width = '348'
   config.height = '150'
    config.toolbar_Pure = [
    { name: 'basicstyles', items: [ 'Bold','Italic','Underline','Strike','Subscript','Superscript','-','RemoveFormat' ] },
    { name: 'styles',      items: [ 'Styles','Format','Font','FontSize' ] },
    { name: 'colors',      items: [ 'TextColor','BGColor' ] },
      ]
  config.toolbar = 'Pure'
return true;
};
