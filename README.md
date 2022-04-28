<img src="Assets/revert-logo.png" alt="revert logo">

# revert-gait-app
## :file_folder: JointsDetection
#### Content
Simple ARKit Motion Capture app with custom joints (not a .usdz model) and the ability to save the capture to a JSON file.

## :file_folder: MotionCapture
#### Content
Skeleton of the main app with the possibility of creating accounts, logging in.
The ARKit fonctionalities of the *JointsDetection* file has veend implemented with also the ability to capture and save the JSON file.
#### To be done
- Responsive design (Only a responsive draft has been done)
- Front / Visual update
- Update the ReadMe part on the app
---
### Screenshots (not definitive design)

#### <a name="main">Main Menu</a>
<center><img src="Assets/001.PNG" alt="Main Menu" width="250"/></center>

This is the first menu you'll see after you launched the app.
In this menu you have differents choices which are: Sign Up, Log In, ReadMe, Delete
When you'll be connected, the app will automatically change the menu to the record one (see the [*Record Menu*](#record)).

Actions of every buttons on the Main Menu:
- Sign Up: Present the Sign up menu wich, as named, allows you to create a new account
- Log in: Present the Log in menu wich allows you to connect to your account
- ReadMe: The documentation about a normal running of the app
- Delete: Delete every person registered in the database (Has to be changed)

#### <a>Sign up Menu</a>
<center><img src="Assets/003.PNG" alt="Log in Menu" width="250"/></center>

This menu is where you create your account.
Once you created it, a pop up will appear to tell you if your account has been sucsessfully created or not and then leaves you to the [*Main Menu*](#main).

Fields:
- Name
- Family Name
- Email
- Hospital ID

#### <a>Log in Menu</a>
<center><img src="Assets/002.PNG" alt="Sign in Menu" width="250"/></center>

In this menu, you can choose to connect in your account, if you already created it.
Once you're connected, the application will automatically redirect you to the [*Record Menu*](#record).
#### <a name="record"> Record Menu </a>
<center><img src="Assets/004.PNG" alt="Record Menu" width="250"/></center>


<center><img src="Assets/005.PNG" alt="Save File Menu" width="250"/></center>
<center><img src="Assets/006.PNG" alt="Save File Alert" width="250"/></center>
<center><img src="Assets/007.PNG" alt="App Directory" width="250"/></center>