// firebase-messaging-sw.js
importScripts('https://www.gstatic.com/firebasejs/9.6.1/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/9.6.1/firebase-messaging-compat.js');

const firebaseConfig = {
    apiKey: 'AIzaSyCRBjb_Yp7J-qDqykRwSqZdiOSvXKLHlbg',
    appId: '1:72589797723:web:3d845a88f4aec88d2cd27e',
    messagingSenderId: '72589797723',
    projectId: 'tailwaggr',
    authDomain: 'tailwaggr.firebaseapp.com',
    storageBucket: 'tailwaggr.appspot.com',
    measurementId: 'G-8PYPBX6FDT',
};

firebase.initializeApp(firebaseConfig);

const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
  console.log('Received background message ', payload);
  const notificationTitle = payload.notification.title || 'Background Message Title';
  const notificationOptions = {
    body: payload.notification.body || 'Background Message body.',
    icon: '/firebase-logo.png'
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
});
