/*
 Copyright (c) 2003-2013, CKSource - Frederico Knabben. All rights reserved.
 For licensing, see LICENSE.md or http://ckeditor.com/license
*/
CKEDITOR.dialog.add("smiley",function(e){for(var t,a=e.config,i=e.lang.smiley,n=a.smiley_images,o=a.smiley_columns||8,r=function(a){var i=a.data.getTarget(),n=i.getName();if("a"==n)i=i.getChild(0);else if("img"!=n)return;var n=i.getAttribute("cke_src"),o=i.getAttribute("title"),i=e.document.createElement("img",{attributes:{src:n,"data-cke-saved-src":n,title:o,alt:o,width:i.$.width,height:i.$.height}});e.insertElement(i),t.hide(),a.data.preventDefault()},l=CKEDITOR.tools.addFunction(function(t,a){var i,t=new CKEDITOR.dom.event(t),a=new CKEDITOR.dom.element(a);i=t.getKeystroke();var n="rtl"==e.lang.dir;switch(i){case 38:(i=a.getParent().getParent().getPrevious())&&(i=i.getChild([a.getParent().getIndex(),0]),i.focus()),t.preventDefault();break;case 40:(i=a.getParent().getParent().getNext())&&(i=i.getChild([a.getParent().getIndex(),0]))&&i.focus(),t.preventDefault();break;case 32:r({data:t}),t.preventDefault();break;case n?37:39:(i=a.getParent().getNext())?(i=i.getChild(0),i.focus(),t.preventDefault(!0)):(i=a.getParent().getParent().getNext())&&((i=i.getChild([0,0]))&&i.focus(),t.preventDefault(!0));break;case n?39:37:(i=a.getParent().getPrevious())?(i=i.getChild(0),i.focus(),t.preventDefault(!0)):(i=a.getParent().getParent().getPrevious())&&(i=i.getLast().getChild(0),i.focus(),t.preventDefault(!0))}}),s=CKEDITOR.tools.getNextId()+"_smiley_emtions_label",s=['<div><span id="'+s+'" class="cke_voice_label">'+i.options+"</span>",'<table role="listbox" aria-labelledby="'+s+'" style="width:100%;height:100%;border-collapse:separate;" cellspacing="2" cellpadding="2"',CKEDITOR.env.ie&&CKEDITOR.env.quirks?' style="position:absolute;"':"","><tbody>"],d=n.length,i=0;d>i;i++){0===i%o&&s.push('<tr role="presentation">');var c="cke_smile_label_"+i+"_"+CKEDITOR.tools.getNextNumber();s.push('<td class="cke_dark_background cke_centered" style="vertical-align: middle;" role="presentation"><a href="javascript:void(0)" role="option"',' aria-posinset="'+(i+1)+'"',' aria-setsize="'+d+'"',' aria-labelledby="'+c+'"',' class="cke_smile cke_hand" tabindex="-1" onkeydown="CKEDITOR.tools.callFunction( ',l,', event, this );">','<img class="cke_hand" title="',a.smiley_descriptions[i],'" cke_src="',CKEDITOR.tools.htmlEncode(a.smiley_path+n[i]),'" alt="',a.smiley_descriptions[i],'"',' src="',CKEDITOR.tools.htmlEncode(a.smiley_path+n[i]),'"',CKEDITOR.env.ie?" onload=\"this.setAttribute('width', 2); this.removeAttribute('width');\" ":"",'><span id="'+c+'" class="cke_voice_label">'+a.smiley_descriptions[i]+"</span></a>","</td>"),i%o==o-1&&s.push("</tr>")}if(o-1>i){for(;o-1>i;i++)s.push("<td></td>");s.push("</tr>")}return s.push("</tbody></table></div>"),a={type:"html",id:"smileySelector",html:s.join(""),onLoad:function(e){t=e.sender},focus:function(){var e=this;setTimeout(function(){e.getElement().getElementsByTag("a").getItem(0).focus()},0)},onClick:r,style:"width: 100%; border-collapse: separate;"},{title:e.lang.smiley.title,minWidth:270,minHeight:120,contents:[{id:"tab1",label:"",title:"",expand:!0,padding:0,elements:[a]}],buttons:[CKEDITOR.dialog.cancelButton]}});