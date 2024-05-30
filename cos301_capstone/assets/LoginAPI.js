import { initializeApp } from "firebase/app";
import { getFirestore, where, collection, query, doc, getDocs, addDoc, updateDoc, deleteDoc, orderBy } from "firebase/firestore";
import { getAuth, signInWithEmailAndPassword, signOut } from "firebase/auth";
import { getStorage, ref, uploadBytes, getDownloadURL } from "firebase/storage";
import axios from 'axios';

// Firebase credentials. Okay to expose in public repo due to how Firebase handles auth.
initializeApp({
    apiKey: "AIzaSyCRBjb_Yp7J-qDqykRwSqZdiOSvXKLHlbg",
    authDomain: "tailwaggr.firebaseapp.com",
    projectId: "tailwaggr",
    storageBucket: "tailwaggr.appspot.com",
    messagingSenderId: "72589797723",
    appId: "1:72589797723:web:7f3d226b775157cf2cd27e",
    measurementId: "G-F6YMQD6MZV"
});

const db = getFirestore();
const storage = getStorage();

// --------------------------------------------------------- //
//                                                           //
//                    Signin Functions                       //
//                                                           //
// --------------------------------------------------------- //

export const passwordReset = async (employeeEmail) => {

    // Link to docs where info can be found: https://firebase.google.com/docs/reference/rest/auth
    const response = await axios.post(
        `https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode?key=AIzaSyCUk5Bnl01l6EJsXxQtC2FFH3zd7vt_0TU`,
        { email: employeeEmail, requestType: 'PASSWORD_RESET' }
    );
};

export const signUserIn = (email, password) => {

    console.log("Signing in...");
    // const auth = getAuth();

    // // Firebase sign in function
    // signInWithEmailAndPassword(auth, email, password)
    //     .catch((error) => {
    //         console.log(error);
    //         if (error == "FirebaseError: Firebase: Error (auth/wrong-password)." || error == "FirebaseError: Firebase: Error (auth/user-not-found).") {
    //             alert("Incorrect email or password");
    //         }
    //         else if (error == "FirebaseError: Firebase: Error (auth/invalid-email).") {
    //             alert("Invalid email");
    //         }
    //         else if (error == "FirebaseError: Firebase: Error (auth/user-disabled).") {
    //             alert("User has been disabled. Please contact your administrator");
    //         }
    //         else {
    //             alert("An error occured");
    //         }

    //     });
    return 5;
};

export const signUserOut = (auth, router) => {
    signOut(auth);
};