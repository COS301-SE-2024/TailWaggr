# Software Requirements Specification

[(PDF version)](/pdfs/requirements-specification.pdf)

## Introduction

This is a document that describes all the technical/non-technical requirements of our Pinterest replication, which we refer to as not-Pinterest. The requirements have been split into two categories: Technical and Non-technical requirements. The technical requirements delve into the subsystems required and the requirements for each, in format that meets the clients requirements, whereas the non-technical requirements focuses on the quality-attributes of each system.

## Technical/Functional requirements

### Authentication

<ol className="srs-bullets">
  <li>The users must be able to sign up  
    <ol className="srs-bullets">
      <li>Using a sign up form. The form should gather the following:
        <ol className="srs-bullets">
          <li>Email address. Does not require email authentication.</li>
          <li>Birthday</li>
          <li>Password</li>
        </ol>
       </li>
      <li>Using existing platforms:
        <ol className="srs-bullets">
          <li>Google</li>
          <li>Facebook</li>
        </ol>
      </li>
      <li> After signing up, the system must obtain the following from the user:
        <ol className="srs-bullets">
          <li>Gender</li>
          <li>Language</li>
          <li>Location</li>
          <li>Interests based in predefined categories</li>
        </ol>
      </li>
    </ol>
  </li>
  <li>The user must be able to sign in
    <ol className="srs-bullets">
      <li>Using their email and password
        <ol className="srs-bullets">
          <li>The user credentials must be validated</li>
          <li>Must allow user to recover their password using their email or username
            <ol className="srs-bullets">
              <li>The account must be verified (i.e. ensure it exists)</li>
              <li>If the account is found, the system must allow the user to send a recovery email to the email address associated with the account</li>
            </ol>
          </li>
        </ol>
      </li>
      <li>Using existing platforms
        <ol className="srs-bullets">
          <li>Using Google</li>
          <li>Using Facebook</li>
        </ol>
      </li>
      <li>The user must be able to select “forgot password’
        <ol className="srs-bullets">
          <li>The system must identify their account using their email address or username.</li>
          <li>If an account is found, a button appears that lets the user send a password reset email to the email address linked to their account</li>
        </ol>
      </li>
    </ol>
  </li>
</ol>

### Authorization

<ol className="srs-bullets">
  <li>The system must provide an "Explore page" for users that are not signed up. The page allows the user to view posts</li>
  <li>The system must provide functionality that is specific to users that are singed up:
    <ol className="srs-bullets">
      <li>Access to the board system</li>
      <li>Access to the recommendation system. The access is implicit (i.e. the user doesn't directly interact with the system)</li>
      <li>Access to account management</li>
      <li>Access to the social interaction system</li>
    </ol>
  </li>
</ol>

### Account settings systems

<ol className="srs-bullets">
    <li>The system must allow the users to view their profile information:
          <ol className="srs-bullets">
            <li>Profile picture</li>
            <li>Username</li>
            <li>About information</li>
            <li>Their website link</li>
            <li>Their pronouns</li>
          </ol>
    </li>
    <li>The system must allow the users to view and edit their account information:
          <ol className="srs-bullets">
            <li>Email</li>
            <li>Password</li>
            <li>Birthday</li>
            <li>Gender</li>
            <li>Country</li>
            <li>Language</li>
            <li>Must allow the user to deactivate their account</li>
            <li>Must allow the user to delete their account</li>
          </ol>
    </li>
    <li>The system must allow the user to view and edit their account visibility</li>
    <li>The system must allow the users to view and edit their account's social permission:
          <ol className="srs-bullets">
            <li>Who is allowed to mention the user</li>
            <s><li>Message privileges:
              <ol className="srs-bullets">
                <li>Inbox</li>
                <li>Request</li>
                <li>Don't deliver</li>
              </ol>
            </li></s>
            <li>The system must allow the users to view and edit their account information:
            </li>
          </ol>
    </li>
    <li>The system must allow the users to view and edit their notification settings:
      <ol className="srs-bullets">
        <li>On pinterest </li>
        <li>By email</li>
        <li>By push notification</li>
      </ol>
    </li>
    <s><li>The system must allow the users to view and edit their privacy and data settings:
      <ol className="srs-bullets">
        <li>Delete your data and account</li>
        <li>Request your data</li>
      </ol>
    </li></s>
    <li>The system must allow the users to view and edit their security settings:
      <ol className="srs-bullets">
        <li>Two-factor authentication</li>
        <li>Login options</li>
      </ol>
    </li>
</ol>

### Content creating and posting system

<ol className="srs-bullets">
  <li>The system provide support for posting videos and photos
    <ol className="srs-bullets">
      <li>This is a required field for any posts (i.e. users can't post if they haven't uploaded any media)</li>
      <li>The user can upload the media from their computer</li>
      <li>The user can provide the media from a saved URL</li>
    </ol>
  </li>
  <s>
  <li>The system should make use of drafts
    <ol className="srs-bullets">
      <li>The user should be able to delete the current draft</li>
      <li>The user should be able to create a new draft</li>
      <li>The user should be allowed to publish the draft</li>
    </ol>
  </li>
  </s>
  <li>The system should allow the user to add information related to the post
    <ol className="srs-bullets">
      <li>The user must be able to add a title to the pin.</li>
      <li>The user must be able to add a description.</li>
      <li>The user must be able to add a link to their pin for more resources on their pin.</li>
      <li>The user must be able to specify to which of their boards this pin will be posted to (see board subsystem).
        <ol className="srs-bullets">
          <li>Search Board</li>
          <li>Choose Board</li>
          <li>Add Board</li>
        </ol>
      </li>
      <li>The must be able to can add multiple tags to their pin.</li>
      <li>The must be able to be provided with more options
        <ol className="srs-bullets">
          <li>The user must be able to indicate if people are allowed to comment.</li>
          <li>The user must be able to indicate if similar pins should be displayed beneath their pin.</li>
        </ol>
      </li>
      <li>The user should be able to edit the cover of their pin</li>
    </ol>
  </li>
</ol>

### Content viewing system

<ol className="srs-bullets">
  <li>Must display the media (picture of video)
    <ol className="srs-bullets">
      <li>If it is a video, the video must play automatically</li>
       <li>If the post has multiple pictures and or videos, there must be a way to navigate between then</li>
    </ol>
  </li>
  <li>The post's information must be displayed</li>
  <li>The post's comment section must be displayed (as described in the social interaction system)</li>
  <li>The user must be able to save the post to a board </li>
  <li>The user must be able to share the post (as described in the social interaction system)</li>
  <li>Must provide more options on the post that lets the user:
    <ol className="srs-bullets">
      <li>Download</li>
      <li>Hide the pin</li>
      <li>Report pin</li>
      <li>Get Pin embedded code</li>
    </ol>
  </li>
</ol>

### Social interactions

<ol className="srs-bullets">
    <li>The system must provide commenting functionality
      <ol className="srs-bullets">
        <li>Must allow users to comment on posts and on other comments</li>
        <li>Must allow users to react to the post and comments:
          <ol className="srs-bullets">
            <li>“Good idea”</li>
            <li>“Love”</li>
            <li>“Thanks”</li>
            <li>“Wow”</li>
            <li>“Haha”</li>
          </ol>
        </li>
      </ol>
    </li>
        <li>The system must display the comments of a post
      <ol className="srs-bullets">
        <li>Must be able to minimize the comment section</li>
        <li>Each comment must displays the username and profile picture of the person who commented.</li>
        <li>Display the comment</li>
        <li>Comments can contain emojis</li>
        <li>Must display when the comment was created</li>
        <li>Must show the comments on comments</li>
        <li>Has to provide the user with more options for each comment
          <ol className="srs-bullets">
            <li>Report this content</li>
            <li>Block user</li>
          </ol>
        </li>
      </ol>
    </li>
    <li>The system must allow users to follow one another</li>
    <li>The system must provide messaging functionality
      <ol className="srs-bullets">
        <li>The system should allow the users to start a new message chat with another user
          <ol className="srs-bullets">
            <li>The user should be able to search for the the other user by their email or their name</li>
          </ol>
        </li>
        <li>The user should be able to invite friends
          <ol className="srs-bullets">
            <li>Via a link</li>
            <li>Via whatsapp</li>
            <li>Via Facebook</li>
            <li>Via email</li>
          </ol>
        </li>
        <li>The user must be able to view and access their previous chats</li>
        <li>Any new message should alert the user via the notification system(as described in the notification system)</li>
      </ol>
    </li>
</ol>

### Notifications System

<ol className="srs-bullets">
    <li>The system should notify the user with regards to.
      <ol className="srs-bullets">
        <li>New recommendations.</li>
        <li>Who started following you.</li>
        <li>Who reacted on the pins you created.</li>
        <li>Who saved the pins you created.</li>
        <li>Who commented on the pins you created.</li>
        <li>Who saved pins that you saved.</li>
      </ol>
    </li>
    <li>The system must provide notification settings as detailed in the account settings system section</li>
</ol>

### Navigation and search

<ol className="srs-bullets">
    <li>Each page must contain a way to go back to the previous page.</li>
    <li>The system must have a search function
      <ol className="srs-bullets">
        <li>It should show the user their recent searches.</li>
        <li>It should show ideas for the user(recommendations).</li>
        <li>When the user starts to search it should do word completion recommendations</li>
      </ol>
    </li>
    <li>The system must provide a more options dropdown
      <ol className="srs-bullets">
        <li> It needs to show the user what account is currently signed in.</li>
        <li>There should be a partition to give the user more options:
          <ol className="srs-bullets">
            <li>There should be a “Settings” button that takes you to the page where you can edit your account.</li>
            <li>There should be a “Your privacy rights” button that takes you to the page where you can edit your privacy setting or delete your account.</li>
            <li>There should be links for various purposes:
              <ol className="srs-bullets">
                <li>A link to get help.</li>
                <li>A link to see the terms of service</li>
                <li>A link to see the privacy policy</li>
                <li>A link to become a beta tester.</li>
              </ol>
            </li>
          </ol>
        </li>
        <li>The user should be able to log out through the “Logout” button</li>
      </ol>
    </li>
</ol>

### Board and pinning system

<ol className="srs-bullets">
    <li>The system has to allow a user to create boards
      <ol className="srs-bullets">
        <li>Must be able to specify the board name</li>
        <li>Must be able to set viewing permission on the board</li>
      </ol>
    </li>
    <li>The system must allow users to save posts to boards
      <ol className="srs-bullets">
        <li>The recommendation system should automatically specify the board the post will be saved to</li>
        <li>The user must be able to change the board the post will be saved to
          <ol className="srs-bullets">
            <li>Should allow the user to search for a board</li>
            <li>All the users recently used boards should be listed</li>
            <li>The board creation recommendation should be available to the user</li>
            <li>The user should be allowed to create a new board</li>
          </ol>
        </li>
      </ol>
    </li>
</ol>

### Recommendation system  

<ol className="srs-bullets">
    <li>The system must provide separate recommendations based on each board the user has created (only available once user creates a board).
      <ol className="srs-bullets">
        <li>Only present in the "Home page"</li>
        <li>A feed that corresponds to that particular board has to be generated and the user has to be able to access the feed </li>
        <li>Each recommendation in the feeds needs to automatically be pin-able to that board</li>
      </ol>
    </li>
    <li>The system must generate a feed based on the user's perceived interests.
      <ol className="srs-bullets">
        <li>In the "Home page" the feed must be based on the user's general interests</li>
        <li>The the "View post page" the feed must be generated based on the post that is being viewed</li>
      </ol>
    </li>
    <li>The system must automatically suggest a board to which the user can pin a particular post</li>
    <li>The system must also recommend a board that may be created based on the current pin</li>
    <li>This system has to create a "ideas you might love" recommendation
      <ol className="srs-bullets">
        <li>Consist of 5 recommended categories related to the current post</li>
        <li>A feed is generated for each category</li>
      </ol>
    </li>
    <li>This system must provide a "search based on current image" functionality:
      <ol className="srs-bullets">
        <li>A feed must be created based on the current image. image</li>
        <li>In this case the images must be as closely matched to the image as opposed to being relate to the</li>
      </ol>
    </li>
</ol>

## Quality Attributes (Non Technical)  Requirements

### Authentication

<ol className="srs-bullets">
  <li>The users must be able to sign up: Security + Confidentiality + Integrity - the system should safeguard user data from unauthorised modification as well as keep user information confidential</li>
  <li>The user must be able to sign in: Security + Confidentiality + Integrity - the system should safeguard user data from unauthorised modification as well as keep user information confidential</li>
</ol>

### Authorisation

<ol className="srs-bullets">
  <li>The system must provide an "Explore page" for users that are not signed up. The page allows the user to view posts: Security + Integrity + Performance + Reliability - unauthorised users should not be allow to interact with posts until authenticated. As the explore page is the landing for possible new users, it should always be performant.</li>
  <li>The system must provide functionality that is specific to users that are singed up: Integrity + Security - the system must ensure that only authenticated users have access to the sub-systems</li>
</ol>

### Account Settings System

<ol className="srs-bullets">
    <li>The system must allow the users to view their profile information: Integrity - the system should ensure that only authorised users are able to view account information</li>
    <li>The system must allow the users to view and edit their account information + visibility: Integrity + Confidentiality + Usability + Reliability - the system should ensure that only authorised users are able to modify account information. The system should also ensure that the process of modifying account information is intuitive and easy to do. This system should be reliable as it is important for user privacy to allow users to update their information at anytime, without providing fake/invalid information.
    </li>
</ol>

### Content creating and posting system

<ol className="srs-bullets">
  <li>The system provide support for posting videos and photos: Reliability + Scalability + Usability -  the system should provide an easy and reliable way to upload on download media. This system needs to scale to the particular processing and storage requirements.
  </li>
  <li>The system should allow the user to add information related to the post
    <ol className="srs-bullets">
      <li>The user must be able to add a title to the pin.</li>
      <li>The user must be able to add a description.</li>
      <li>The user must be able to add a link to their pin for more resources on their pin.</li>
      <li>The user must be able to specify to which of their boards this pin will be posted to (see board subsystem).
        <ol className="srs-bullets">
          <li>Search Board</li>
          <li>Choose Board</li>
          <li>Add Board</li>
        </ol>
      </li>
      <li>The must be able to can add multiple tags to their pin.</li>
      <li>The must be able to needs to be provided with more options
        <ol className="srs-bullets">
          <li>The user must be able to indicate if people are allowed to comment.</li>
          <li>The user must be able to indicate if similar pins should be displayed beneath their pin.</li>
        </ol>
      </li>
      <li>The user should be able to edit the cover of their pin</li>
    </ol>
  </li>
</ol>

### Content viewing system

<ol className="srs-bullets">
  <li>Entire sub-system: Reliable + Performant + Integrity + Uptime - the system is the back of why people use Pinterest, thus it is crucial that the system is reliable and maintain a high uptime. It also needs to be performant, as viewing media on the web is network intensive, steps should be taken to optimise this step.
  </li>
</ol>

### Social interactions

<ol className="srs-bullets">
    <li>The system must provide commenting functionality: Performant - comments should update in near-realtime, thus this system needs to be performant.</li>
    <li>The system must display the comments of a post: Integrity - comments of only the current post should be show, and only if the users' preference allow for comments.</li>
    <li>The system must allow users to follow one another: Performant + Reliable Usability- since this is another core feature of any social media network, it needs to be performant</li>
</ol>

### Navigation and search

<ol className="srs-bullets">
    <li>The system must have a search function: Scalable + Performant + Reliable + Timeliness: This is a feature that is used a lot throughout the application, it should be as performant as possible to account for the slower database operation. Index and sharding could be done at periods of low usage in order to maximise response times during high usage.</li>
</ol>

### Board and pinning system

<ol className="srs-bullets">
    <li>The system has to allow a user to create boards: Integrity + Performant: Only authorised users should be able to create a board, as this is another core feature that would get used often, it should be performant.</li>
    <li>The system must allow users to save posts to boards: Integrity: Only authorised users should be allowed to a modify or add to a board.</li>
</ol>

### Recommendation system  

<ol className="srs-bullets">
    <li>The system must provide separate recommendations based on each board the user has created: Performant + Usability + Maintainability - this system should be performant in order to generate new feeds in near-realtime. As this is a feature that gets used by different components on the site, it should be designed in such a way that it can reused across those components with minimal changes.</li>
</ol>

## Use Case Diagrams

### Board System

![Board Sub-system](./assets/use-case-diagrams/Board_System_Usecase.svg)

### Create Pin System

![Create Pin System](./assets/use-case-diagrams/CreatePinSubsystem.svg)

### Explore Page System

![Explore Page System](./assets/use-case-diagrams/Explore_Page_Use_Case.svg)

### Home Page System

![Home Page System](./assets/use-case-diagrams/Home_Page_System.svg)

### Landing Page System

![Landing Page System](./assets/use-case-diagrams/Landing_Page_Use_Case.svg)

### Pin Page System

![Pin Page System](./assets/use-case-diagrams/Pin_Page_Use_Case.svg)

### Profile Page

![Profile Page System](./assets/use-case-diagrams/Profile_Page_system.svg)

### Ribbon Sub-system

![Ribbon Sub-system](./assets/use-case-diagrams/RibbonSubsystem.svg)

### Search System

![Search System](./assets/use-case-diagrams/Search_Base_On_Current_Pin.svg)
