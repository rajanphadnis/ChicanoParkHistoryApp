// var config = {
//     apiKey: "AIzaSyC1IMIc5fVsAF30_pi08gc03pz94CX2Avk",
//     authDomain: "programmingii-367d0.firebaseapp.com",
//     databaseURL: "https://programmingii-367d0.firebaseio.com",
//     projectId: "programmingii-367d0",
//     storageBucket: "programmingii-367d0.appspot.com",
//     messagingSenderId: "374441578679",
//     appId: "1:374441578679:web:33e2088b751f0169a77d32",
//     measurementId: "G-1GTHN2PHCX"
// };
// firebase.initializeApp(config);
var firestore = firebase.firestore();
var selected = true;

// firebase.firestore().enablePersistence({
//         experimentalTabSynchronization: true
//     })
//     .catch(function (err) {
//         if (err.code == 'failed-precondition') {
//             // Multiple tabs open, persistence can only be enabled
//             // in one tab at a a time.
//             // ...
//         } else if (err.code == 'unimplemented') {
//             // The current browser does not support all of the
//             // features required to enable persistence
//             // ...
//         }
//     });
firebase.auth().onAuthStateChanged(function (user) {
    if (user) {
        if (user.email == "rphadnis20@pacificridge.org" || user.email == "rajansd28@gmail.com" || user.email == "elisse.chow@gmail.com"|| user.email == "elisse.chow@gmail.com") {
            document.getElementById("murals").style.display = "block";
            document.getElementById("artists").style.display = "block";
            document.getElementById("noAuth").style.display = "none";
            document.getElementById("noAur").style.display = "none";
        } else {
            document.getElementById("murals").style.display = "none";
            document.getElementById("artists").style.display = "none";
            document.getElementById("noAuth").style.display = "none";
            document.getElementById("noAur").style.display = "block";
        }
    } else {
        document.getElementById("murals").style.display = "none";
        document.getElementById("artists").style.display = "none";
        document.getElementById("noAuth").style.display = "block";
        document.getElementById("noAur").style.display = "none";
    }
});
var StringThing = '<h1 class="title">Edit Murals</h1>';
firestore.collection("Murals/").get().then(function (querySnapshot) {
    querySnapshot.forEach(function (doc) {
        StringThing = StringThing + '<div class="cardDiv mdc-card"><input disabled class="centerTheThing" value="' + doc.id + '"><p>Title:</p><input class="VT" value="' + doc.data().title +
            '"></br><p>Picture:</p><input class="VP" value="' + doc.data().picURL +
            '"></br><p>Description:</p><textarea rows="4" class="VD" wrap="soft">' + doc.data().desc +
            '</textarea></br><p>Author:</p><input class="VA" value="' + doc.data().author + '"></div>';
        document.getElementById("murals").innerHTML = StringThing;

    });
}).catch(function (error) {
    console.log("Error getting document:", error);
    errorMain();
});
document.getElementById("murals").innerHTML = StringThing;

var ArtistString = '<h1 class="title">Edit Artists</h1>';
firestore.collection("Artists/").get().then(function (querySnapshot) {
    querySnapshot.forEach(function (doc) {
        ArtistString = ArtistString + '<div class="cardDiv mdc-card"><input disabled class="centerArt" value="' + doc.id + '"><p>Picture:</p><input class="ArtistPic" value="' + doc.data().picURL +
            '"></br><p>Description:</p><textarea rows="4" class="ArtistDesc" wrap="soft">' + doc.data().desc +
            '</textarea></div>';
        document.getElementById("artists").innerHTML = ArtistString;

    });
}).catch(function (error) {
    console.log("Error getting document:", error);
    errorMain();
});
document.getElementById("artists").innerHTML = ArtistString;

document.getElementById("commit").addEventListener("click", function () {
    var VT = document.getElementsByClassName("centerTheThing").length;
    updateV(VT);
    alert("Updated data. Refresh page to see changes.");
});
document.getElementById("artSave").addEventListener("click", function () {
    var AT = document.getElementsByClassName("centerArt").length;
    updateA(AT);
    alert("Updated data. Refresh page to see changes.");
});

function openCity(cityName) {
    var i;
    var x = document.getElementsByClassName("tabbar");
    for (i = 0; i < x.length; i++) {
        x[i].style.display = "none";
    }
    document.getElementById(cityName).style.display = "block";
}

function updateV(lengthOfV) {
    console.log(lengthOfV);
    var i;
    for (i = 0; i < lengthOfV; i++) {
        firestore.collection("Murals").doc(document.getElementsByClassName("centerTheThing")[i].value.toString()).set({
                title: document.getElementsByClassName("VT")[i].value,
                picURL: document.getElementsByClassName("VP")[i].value,
                desc: document.getElementsByClassName("VD")[i].value,
                author: document.getElementsByClassName("VA")[i].value
            }, {
                merge: true
            }).then(function () {
                console.log("Done updating mural " + i);
                console.log(lengthOfV);
            })
            .catch(function (error) {
                // The document probably doesn't exist.
                console.error("Error updating document: ", error);
            });
    }
}

function updateA(lengthOfA) {
    console.log(lengthOfA);
    var i;
    for (i = 0; i < lengthOfA; i++) {
        firestore.collection("Artists").doc(document.getElementsByClassName("centerArt")[i].value.toString()).set({
                picURL: document.getElementsByClassName("ArtistPic")[i].value,
                desc: document.getElementsByClassName("ArtistDesc")[i].value
            }, {
                merge: true
            }).then(function () {
                console.log("Done updating artist " + i);
                console.log(lengthOfA);
            })
            .catch(function (error) {
                // The document probably doesn't exist.
                console.error("Error updating artist document: ", error);
            });
    }
}