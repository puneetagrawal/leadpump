
WL.init({ client_id: "0000000044119D8D", redirect_uri: "http://www.leadpump.com" });

function testt(){
  WL.login({ scope: ["wl.basic","wl.contacts_emails","wl.emails"] }).then(
      function(response) {
        $.fancybox.open({
          href: '#hotmailContactsPopup',
          type: 'inline',
          'beforeLoad' : function() {
              var first_tr = '<tr><td colspan="2">' +
                      '<label class="select_all"><input checked="checked" class="mr2" '+ 'id="select_all" name="select_all" type="checkbox" value="yes">'+'Select All</label></td>'+
                        '<td><label class="select_none"><input class="mr2"'+
                            'id="deselect_all"  name="deselect_all" type="checkbox"'+    'value="yes">Select None</label></td></tr>';
              $("#hotmailcontacts .data-table tbody").html(first_tr);
            }
        });
        getContacts();
      },
      function(response) {
          log("Could not connect, status = " + response.status);
      }
  );
}

  function getContacts() {
    email = '';
    WL.api({ path: "/me", method: "GET" }).then(
        function(response) {
            email = response.emails.preferred;
            $("#user_email").val(email);
        }
    );
    WL.api({ path: "/me/contacts", method: "GET" }).then(
        onGetContacts,
        function(response) {
            log("Cannot get contacts: " + JSON.stringify(response.error).replace(/,/g, ",\n"));
        }
    );
}

function onGetContacts(response) {
    var items = response.data;
    for (var i = 0; i < items.length; i++) {
        if (i > items.length) {
            break;
        }
        getContactProperties(items[i].id);
    }
     
 }

function getContactProperties(contactId) {
    WL.api({ path: contactId, method: "GET" }).then(onGetContactProperties);
}

function onGetContactProperties(response) {
    makeemail(JSON.stringify(response).replace(/,/g, ",\n"));
}
function makeemail(message){
  var email = jQuery.parseJSON( message ).emails.preferred;
  if(email){
    append_email(email);    
  }
}
                   
function log(message) {
    $("#hotmailcontacts .data-table tbody").append(message);
}

function append_email(email){
  var html = '<tr><td><input type="checkbox" "'+email+'" checked class = "gmailContactChekbox '+ 
  'chekboxess"></td><td class="email_label">'+email+'</td><td>'+email+'</td></tr>';
  $("#hotmailcontacts .data-table tbody").append(html);
}
