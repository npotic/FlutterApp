<h2 align="center">Project Structure</h2>


Desktop Application (Sender):

 - Built with Flutter Desktop.
 - Captures the screen every 5 seconds.
 - Streams the captured images using WebRTC.

Mobile Application (Receiver):

 - Built with Flutter for Android/iOS.
 - Receives the screen capture stream via WebRTC.
 - Displays the received images in real time.


</br><h3 align="center">How to Run the Applications</h3>

      

<h4> Desktop Application (Sender): </h4>

- Navigate to the sender_app directory.
- Run `flutter pub get`
- Run `flutter run -d windows (or the corresponding platform)`
   
   
<h4> Mobile Application (Receiver):</h4>

 - Navigate to the receiver_app directory.
 - Run `flutter pub get`
 - Connect a mobile device via USB or use an emulator.
 - Run `flutter run`

</br>Additional Notes </br>

Ensure that both applications are connected to the same network for WebRTC communication. </br>
Check if necessary permissions for screen capture and network access are enabled on both devices.
