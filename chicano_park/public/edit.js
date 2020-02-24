var firestore = firebase.firestore();
var selected = true;
firebase.auth().onAuthStateChanged(function (user) {
    if (user) {
        var docRef = firestore.collection("Authorization").doc(user.email);

        docRef.get().then(function (doc) {
            if (doc.exists) {
                console.log("Document data:", doc.data());
                document.getElementById("murals").style.display = "block";
                document.getElementById("artists").style.display = "block";
                document.getElementById("history").style.display = "block";
                document.getElementById("noAuth").style.display = "none";
                document.getElementById("noAur").style.display = "none";
            } else {
                console.log("No such document!");
                document.getElementById("murals").style.display = "none";
                document.getElementById("artists").style.display = "none";
                document.getElementById("history").style.display = "none";
                document.getElementById("noAuth").style.display = "none";
                document.getElementById("noAur").style.display = "block";
            }
        }).catch(function (error) {
            console.log("Error getting document:", error);
        });
    } else {
        document.getElementById("murals").style.display = "none";
        document.getElementById("artists").style.display = "none";
        document.getElementById("history").style.display = "none";
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
            '</textarea></br><p>Author:</p><input class="VA" value="' + doc.data().author + '"></br><p>Interview URL (YouTube link):</p><input class="ArtistInt" value="' + doc.data().interview +
            '"></br><p>Audio Tour:</p><input class="AudTour" value="' + doc.data().audioTour +
            '"></div>';
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


var HistoryString = '<h1 class="title">Edit History</h1>';
firestore.collection("History/").get().then(function (querySnapshot) {
    querySnapshot.forEach(function (doc) {
        HistoryString = HistoryString + '<div class="cardDiv mdc-card"><input disabled class="centerHis" value="' + doc.id + '"></br><p>Paragraph:</p><textarea rows="10" class="paraHis" wrap="soft">' + doc.data().para +
            '</textarea></div>';
        document.getElementById("history").innerHTML = HistoryString;

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
document.getElementById("hisSave").addEventListener("click", function () {
    var HT = document.getElementsByClassName("centerHis").length;
    updateH(HT);
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
                author: document.getElementsByClassName("VA")[i].value,
                interview: document.getElementsByClassName("ArtistInt")[i].value,
                audioTour: document.getElementsByClassName("AudTour")[i].value,
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
                desc: document.getElementsByClassName("ArtistDesc")[i].value,

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

function updateH(lengthOfH) {
    console.log(lengthOfH);
    var i;
    for (i = 0; i < lengthOfH; i++) {
        firestore.collection("History").doc(document.getElementsByClassName("centerHis")[i].value.toString()).set({
                para: document.getElementsByClassName("paraHis")[i].value,

            }, {
                merge: true
            }).then(function () {
                console.log("Done updating history " + i);
                console.log(lengthOfH);
            })
            .catch(function (error) {
                // The document probably doesn't exist.
                console.error("Error updating history document: ", error);
            });
    }
}