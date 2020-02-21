var firestore = firebase.firestore();


function userShow() {
  document.getElementById("message").style.display = "none";
  document.getElementById("userDoc").style.display = "block";
  document.getElementById("scDoc").style.display = "none";
  document.getElementById("loginE").style.display = "none";
};

function scShow() {
  firebase.auth().onAuthStateChanged(function (user) {
    if (user) {
      var docRef = firestore.collection("Authorization").doc(user.email);

      docRef.get().then(function (doc) {
        if (doc.exists) {
          document.getElementById("message").style.display = "none";
          document.getElementById("scDoc").style.display = "block";
          document.getElementById("userDoc").style.display = "none";
          document.getElementById("loginE").style.display = "none";
          document.getElementById("sc").innerHTML = "Welcome, " + user.displayName;
        } else {
          document.getElementById("scDoc").style.display = "none";
          document.getElementById("userDoc").style.display = "none";
          document.getElementById("loginE").style.display = "block";
          document.getElementById("message").style.display = "none";
          document.getElementById("loginE").innerHTML = "Sorry, you don't have access. <a onclick='logout()' href=''>Logout</a>";
        }
      }).catch(function (error) {
        console.log("Error getting document:", error);
      });
    } else {
      // No user is signed in.
      document.getElementById("scDoc").style.display = "none";
      document.getElementById("userDoc").style.display = "none";
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
  firebase.auth().signOut().then(function () {
    // Sign-out successful.

  }, function (error) {
    // An error happened.
    alert(error);
  });
}