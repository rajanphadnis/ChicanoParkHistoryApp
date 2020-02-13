function userShow() {
    document.getElementById("message").style.display = "none";
    document.getElementById("userDoc").style.display = "block";
    document.getElementById("scDoc").style.display = "none";
    document.getElementById("loginE").style.display = "none";    
};
function scShow() {
    firebase.auth().onAuthStateChanged(function(user) {
        if (user) {
          // User is signed in.
          document.getElementById("message").style.display = "none";
          document.getElementById("scDoc").style.display = "block";
          document.getElementById("userDoc").style.display = "none";
          document.getElementById("loginE").style.display = "none";
          document.getElementById("sc").innerHTML = "Welcome, " + user.displayName;
        } else {
          // No user is signed in.
          document.getElementById("loginE").style.display = "block";
          document.getElementById("message").style.display = "none";
        }
      });   
};
function showNone() {
    document.getElementById("message").style.display = "block";
    document.getElementById("userDoc").style.display = "none";
    document.getElementById("scDoc").style.display = "none";
    document.getElementById("loginE").style.display = "none";
};
function logout() {
    firebase.auth().signOut().then(function() {
        // Sign-out successful.

      }, function(error) {
        // An error happened.
        alert(error);
      });
}