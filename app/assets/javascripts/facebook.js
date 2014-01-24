window.fbAsyncInit = function() {
  FB.init({
    appId  : "<%=FACEBOOK_KEY%>",
      status : true, // check login status
      cookie : true, // enable cookies to allow the server to access the session
      xfbml  : true  // parse XFBML
    });
};

(function() {
  var e = document.createElement('script');
  e.src = document.location.protocol + '//connect.facebook.net/en_US/all.js';
  e.async = true;
  document.getElementById('fb-root').appendChild(e);
}());
function onloginCall(){
  FB.login(handleSessionResponse,{scope:'email,read_stream,publish_stream'});
}

function handleSessionResponse(response){
  var accessToken = response.authResponse.accessToken;
  var email = '';

  if (response.authResponse) {
   FB.api('/me', function (response) {
    email = response.email
  });
   FB.ui(
   {
     method: 'stream.publish',
     message: 'getting educated about Facebook Connect',
     attachment: {
       name: 'Connect',
       caption: 'The Facebook Connect JavaScript SDK',
       description: (
         'A small JavaScript library that allows you to harness ' +
         'the power of Facebook, bringing the user\'s identity, ' +
         'social graph and distribution power to your site.'
       ),
       href: 'http://github.com/facebook/connect-js'
     },
     action_links: [
       { text: 'Code', href: 'http://github.com/facebook/connect-js' }
     ],
     user_message_prompt: 'Share your thoughts about Connect'
   },
   function(response) {
     if (response && response.post_id) {
       alert('Post was published.');
     } else {
       alert('Post was not published.');
     }
   }

 );
   
 }
 else {
  console.log('User cancelled login or did not fully authorize.');
  return;
}
}
