# YouLift

# Made by Reid Buzby, Andrew Garland, and Connor O'Day

YouLift is a workout application that lets the user create a customized workout routine and log their results to compare and track progress over time. It supplies a list of pre-made workouts to use and edit, and the ability to create a new workout, either using existing exercises or making new ones.

Our typical user could range from a first time gym goer to professional athlete. By supplying default workouts for brand new users unfamiliar with the gym, while also logging completed workouts so a veteran user can track their progress, the app is designed for both the novice and expert lifter. Anyone that has any interest in working out is a target user for YouLift.

# External Files Needed to Run:

In order to make the graphs in our project work, an external library needs to be downloaded. Go to:

https://github.com/danielgindi/Charts

Select 'Clone or Download' and then 'Download ZIP.' Move the folder to a place where you can easily access it later.

Next open YouLift in XCode. Select the blue YouLift file and navigate to the General tab. Under 'Embedded Binaries' hit the plus button, and then 'Add Other.' Navigate to the Charts folder that you previously downloaded, and in this folder select 'Charts.xcodeproj'

The first build after importing this library will take a few minutes, but be patient it will work eventually.

(Simply adding this file to our GitHub repo would not work. We tried many ways to automate this process with no luck, hopefully manually downloading and importing wont be too difficult.)
