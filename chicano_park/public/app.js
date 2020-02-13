var config = {
    apiKey: "AIzaSyC1IMIc5fVsAF30_pi08gc03pz94CX2Avk",
    authDomain: "programmingii-367d0.firebaseapp.com",
    databaseURL: "https://programmingii-367d0.firebaseio.com",
    projectId: "programmingii-367d0",
    storageBucket: "programmingii-367d0.appspot.com",
    messagingSenderId: "374441578679",
    appId: "1:374441578679:web:33e2088b751f0169a77d32",
    measurementId: "G-1GTHN2PHCX"
};
firebase.initializeApp(config);
var firestore = firebase.firestore();
var selected = true;

firebase.firestore().enablePersistence({
        experimentalTabSynchronization: true
    })
    .catch(function (err) {
        if (err.code == 'failed-precondition') {
            // Multiple tabs open, persistence can only be enabled
            // in one tab at a a time.
            // ...
        } else if (err.code == 'unimplemented') {
            // The current browser does not support all of the
            // features required to enable persistence
            // ...
        }
    });

function doesExist(nameOfElementToDetectIfItHasBeenRenderedOrEvenExistsOnThePageAtAll) {
    if (document.getElementById(nameOfElementToDetectIfItHasBeenRenderedOrEvenExistsOnThePageAtAll) == null) {
        return false;
    } else if (document.getElementById(nameOfElementToDetectIfItHasBeenRenderedOrEvenExistsOnThePageAtAll) != null) {
        return true;
    }
}
document.getElementById("stats").style.display = "none";
document.getElementById("design").style.display = "flex";

function switchTabs() {
    if (selected) {
        document.getElementById("stats").style.display = "block";
        document.getElementById("design").style.display = "none";
        document.getElementById("TabButton").innerText = "Edit Site";
        selected = false;
    } else {
        document.getElementById("stats").style.display = "none";
        document.getElementById("design").style.display = "flex";
        document.getElementById("TabButton").innerText = "View Stats";
        selected = true;
    }
}
document.getElementById("TabButton").onclick = function () {
    switchTabs();
};
if (doesExist("Content")) {
    document.getElementById("stats").style.display = "none";
    document.getElementById("design").style.display = "flex";

}
firestore.collection("Pages").doc("All").get().then(function (doc) {
    document.getElementById("HomeInput").value = doc.data().homeTitleBar;
    document.getElementById("RatesInput").value = doc.data().ratesTitleBar;
    document.getElementById("HowInput").value = doc.data().proceduresTitleBar;
    document.getElementById("ContactInput").value = doc.data().contactTitleBar;
    // document.getElementById("AboutInput").value = doc.data().aboutTitleBar;
});
firestore.collection("Pages").doc("Contact").get().then(function (doc) {
    document.getElementById("ContactSInput").value = doc.data().ContactSectionTitle;
    document.getElementById("ContactDesInput").value = doc.data().ContactSectionDescription;
    document.getElementById("PhoneInput").value = doc.data().phoneNumber;
    document.getElementById("EmailInput").value = doc.data().emailAddress;
    document.getElementById("ContactButtonInput").value = doc.data().ContactButtonText;
    // Order Section
    document.getElementById("OrderInput").value = doc.data().OrderSectionTitle;
    document.getElementById("OrderDesInput").value = doc.data().OrderSectionDescription;
    document.getElementById("OrderButtonInput").value = doc.data().ContactButton2Text;
});
firestore.collection("Pages").doc("Home").get().then(function (doc) {
    // document.getElementById("galleryTitle").value = doc.data().GalleryTitle;
    document.getElementById("HomeContactButton").value = doc.data().HomeContactButton;
    document.getElementById("HomeRatesButton").value = doc.data().HomeRatesButton;
    document.getElementById("HomeTitle").value = doc.data().HomeTitle;
    document.getElementById("HomeTitleDescription").value = doc.data().HomeTitleDescription;

});
firestore.collection("Pages").doc("Rates").get().then(function (doc) {
    
    document.getElementById("ratesTitle").value = doc.data().RatesTitle;
    document.getElementById("ratesTitleDescription").value = doc.data().RatesTitleDescription;
    document.getElementById("ratesTitle1").value = doc.data().RatesTitle1;
    document.getElementById("ratesTitle1Description").value = doc.data().RatesTitle1Des;
    document.getElementById("ratesTitle2").value = doc.data().RatesTitle2;
    document.getElementById("ratesTitle2Description").value = doc.data().RatesTitle2Des;
    document.getElementById("ratesTitle3").value = doc.data().RatesTitle3;
    document.getElementById("ratesTitle3Description").value = doc.data().RatesTitle3Des;
    document.getElementById("CourtFlat").value = doc.data().CourtFlat;
    document.getElementById("HolidaysTitle").value = doc.data().HolidaysTitle;
    document.getElementById("holidays").value = doc.data().holidays;
});
firestore.collection("Pages").doc("Procedures").get().then(function (doc) {
    document.getElementById("HowTitle").value = doc.data().HowTitle;document.getElementById("HowTitleDes").value = doc.data().HowTitleDes;
    document.getElementById("How1").value = doc.data().How1;
    document.getElementById("How1Des").value = doc.data().How1Des;
    document.getElementById("How2").value = doc.data().How2;
    document.getElementById("How2Des").value = doc.data().How2Des;
    document.getElementById("How3").value = doc.data().How3;
    document.getElementById("How3Des").value = doc.data().How3Des;
    document.getElementById("How4").value = doc.data().How4;
    document.getElementById("How4Des").value = doc.data().How4Des;

});
firestore.collection("Pages").doc("About").get().then(function (doc) {
    document.getElementById("AboutTitle").value = doc.data().AboutTitle;
    document.getElementById("AboutTitleDes").value = doc.data().AboutTitleDes;
    document.getElementById("AboutMainBody").value = doc.data().AboutMainBody;

});
firestore.collection("Pages").doc("ContactShowcase").get().then(function (doc) {
    document.getElementById("ContactTitle").value = doc.data().ContactTitle;
    document.getElementById("ContactTitleDes").value = doc.data().ContactTitleDes;
    document.getElementById("ContactMainBody").value = doc.data().ContactMainBody;

});
// var one = 0;
// var two = 0;
// var three = 0;
// firestore.collection("Pages/Rates/Visitation").get().then(function (querySnapshot) {
//     querySnapshot.forEach(function (doc) {
//         var newString = '<tr><td class="wide">' + doc.data().title + '</td><td class="narrow price">' + doc.data().price + '</td></tr><tr><td class="wide descritptionTable">' + doc.data().des + '</td><td class="narrow"></td></tr><tr><td class="wide spacing"> </td><td class="narrow spacing"></td></tr>';
//         var oldString = document.getElementById("Visit").innerHTML;
//         document.getElementById("Visit").innerHTML = oldString + newString;
//     });
// }).catch(function (error) {
//     console.log("Error getting document:", error);
//     // errorMain();
// });
// firestore.collection("Pages/Rates/Exchanges").get().then(function (querySnapshot) {
//     querySnapshot.forEach(function (doc) {
//         var newString = '<tr><td class="wide">' + doc.data().title + '</td><td class="narrow price">' + doc.data().price + '</td></tr><tr><td class="wide descritptionTable">' + doc.data().des + '</td><td class="narrow"></td></tr><tr><td class="wide spacing"> </td><td class="narrow spacing"></td></tr>';
//         var oldString = document.getElementById("Exchange").innerHTML;
//         document.getElementById("Exchange").innerHTML = oldString + newString;
//     });
// }).catch(function (error) {
//     console.log("Error getting document:", error);
//     errorMain();
// });
// firestore.collection("Pages/Rates/Reports").get().then(function (querySnapshot) {
//     querySnapshot.forEach(function (doc) {
//         var newString = '<tr><td class="wide2">' + doc.data().title + '</td><td class="narrow2 price2">' + doc.data().price1 + '</td><td class="narrow2 price2">' + doc.data().price2 + '</td></tr><tr><td class="wide2 descritptionTable">' + doc.data().des + '</td><td class="narrow2"></td><td class="narrow2"></td></tr><tr><td class="wide2 spacing"></td><td class="narrow2 spacing"></td><td class="narrow2 spacing"></td></tr>';
//         var oldString = document.getElementById("Report").innerHTML;
//         document.getElementById("Report").innerHTML = oldString + newString;
//     });
// }).catch(function (error) {
//     console.log("Error getting document:", error);
//     errorMain();
// });

document.getElementById("HomeContactButton").size = 7;
document.getElementById("HomeRatesButton").size = 10;
document.getElementById("HomeTitleDescription").size = 80;
document.getElementById("bodyMain").style.display = "block";
document.getElementById("sendEmail").addEventListener("click", function() {
    firestore.collection("email").doc(prompt("Recipient email address")).set({
        subj: prompt("subject:"),
        msg: prompt('message:')
    })
    .then(function() {
        console.log("Document successfully written!");
    })
    .catch(function(error) {
        console.error("Error writing document: ", error);
    });
});
document.getElementById("SaveButton").addEventListener("click", function () {
    firestore.collection("Pages").doc("All").set({

        homeTitleBar: document.getElementById("HomeInput").value,
        ratesTitleBar: document.getElementById("RatesInput").value,
        proceduresTitleBar: document.getElementById("HowInput").value,
        contactTitleBar: document.getElementById("ContactInput").value,
        // aboutTitleBar: document.getElementById("AboutInput").value,

    }, {
        merge: true
    }).then(function () {
        console.log("Document successfully written!");
        firestore.collection("Pages").doc("Contact").set({
            ContactSectionTitle: document.getElementById("ContactSInput").value,
            ContactSectionDescription: document.getElementById("ContactDesInput").value,
            phoneNumber: document.getElementById("PhoneInput").value,
            emailAddress: document.getElementById("EmailInput").value,
            ContactButtonText: document.getElementById("ContactButtonInput").value,
            OrderSectionTitle: document.getElementById("OrderInput").value,
            OrderSectionDescription: document.getElementById("OrderDesInput").value,
            ContactButton2Text: document.getElementById("OrderButtonInput").value,

        }, {
            merge: true
        }).then(function () {
            console.log("Document successfully written!");
            firestore.collection("Pages").doc("Home").set({
                // GalleryTitle: document.getElementById("galleryTitle").value,
                HomeContactButton: document.getElementById("HomeContactButton").value,
                HomeRatesButton: document.getElementById("HomeRatesButton").value,
                HomeTitle: document.getElementById("HomeTitle").value,
                HomeTitleDescription: document.getElementById("HomeTitleDescription").value,
            }, {
                merge: true
            }).then(function () {
                console.log("Document successfully written!");
                firestore.collection("Pages").doc("Rates").set({
                    RatesTitle: document.getElementById("ratesTitle").value,
                    RatesTitleDescription: document.getElementById("ratesTitleDescription").value,
                    RatesTitle1: document.getElementById("ratesTitle1").value,
                    CourtFlat: document.getElementById("CourtFlat").value,
                    HolidaysTitle: document.getElementById("HolidaysTitle").value,
                    holidays: document.getElementById("holidays").value,
                }, {
                    merge: true
                }).then(function () {
                    console.log("Document successfully written!");
                    firestore.collection("Pages").doc("Procedures").set({
                        HowTitle: document.getElementById("HowTitle").value,
                        HowTitleDes: document.getElementById("HowTitleDes").value,
                        How1: document.getElementById("How1").value,
                        How1Des: document.getElementById("How1Des").value,
                        How2: document.getElementById("How2").value,
                        How2Des: document.getElementById("How2Des").value,
                        How3: document.getElementById("How3").value,
                        How3Des: document.getElementById("How3Des").value,
                        How4: document.getElementById("How4").value,
                        How4Des: document.getElementById("How4Des").value,
                    }, {
                        merge: true
                    }).then(function () {
                        console.log("Document successfully written!");
                        firestore.collection("Pages").doc("About").set({
                            AboutTitle: document.getElementById("AboutTitle").value,
                            AboutTitleDes: document.getElementById("AboutTitleDes").value,
                            // AboutButton1: document.getElementById("AboutButton1").value,
                            // AboutButton2: document.getElementById("AboutButton2").value,
                            AboutMainBody: document.getElementById("AboutMainBody").value,
                        }, {
                            merge: true
                        }).then(function () {
                            console.log("Document successfully written!");
                            firestore.collection("Pages").doc("ContactShowcase").set({
                                ContactTitle: document.getElementById("ContactTitle").value,
                                ContactTitleDes: document.getElementById("ContactTitleDes").value,
                                ContactMainBody: document.getElementById("ContactMainBody").value,
                            }, {
                                merge: true
                            }).then(function () {
                                console.log("Document successfully written!");
                                window.alert("Values Successfully Updated! Press OK to see changes");
                                location.reload(true);
                            });
                        });

                    });
                });

            });
        });
    });
});