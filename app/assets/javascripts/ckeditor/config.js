CKEDITOR.editorConfig = function(config) {
    config.width = '685px',
    config.height = '200px'
    config.toolbar =
        [
//            { name: 'basicstyles', items: [ 'Bold', 'Italic', 'Underline', 'Strike', 'Subscript', 'Superscript', '-', 'EqnEditor', '-', 'RemoveFormat' ] },
        { name: 'basicstyles', items: [ 'Bold', 'Italic', 'Underline', 'Strike', 'Subscript', 'Superscript', '-', 'RemoveFormat' ] },
        { name: 'paragraph', items: [ 'NumberedList', 'BulletedList', '-', 'Outdent', 'Indent', '-', 'Blockquote', '-', 'JustifyLeft', 'JustifyCenter', 'JustifyRight', 'JustifyBlock' ] },
        { name: 'links', items: [ 'Link', 'Unlink','Anchor'] },
        { name: 'insert', items: [ 'Image', 'HorizontalRule', 'SpecialChar' ] },
        { name: 'document', items: [ 'Source' ] },
        '/',
        { name: 'styles', items: [ 'Styles', 'Format', 'Font', 'FontSize' ] },
    ];
};
