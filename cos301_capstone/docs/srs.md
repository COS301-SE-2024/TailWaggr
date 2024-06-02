**Introduction**

Tailwaggr’s vision is to be a one-stop shop for all things pet, fostering a vibrant

and a supportive online community for pet owners and enthusiasts.

Our objectives are to:



* Empower pet owners: Provide a platform that simplifies pet care and

            strengthens the bond between owners and their furry companions.



* Connect the pet care community: Facilitate connections between pet owners, veterinarians, pet sitters, and other animal lovers through forums and

relevant services.



*  Enhance pet well-being: Offer resources and tools that promote responsible pet ownership and contribute to the overall health and happiness of  pets.

**Business Need**

The pet care industry is booming, with a growing number of people considering

pets as valued members of their families. Tailwaggr addresses this need by:



* Centralizing pet care resources: Simplifying the process of finding qualified

pet care professionals and relevant pet information.



* Enhancing convenience: Offering a mobile app allows pet owners to manage their pet’s needs and access services on the go.
* Building a community: Providing a platform for pet owners to connect,

share experiences, and offer support to each other.

**Project Scope**

The initial scope of Tailwaggr focuses on core functionalities:



*  Pet profiles and owner profiles: Create detailed profiles for pets and their

owners, fostering a sense of community and personalization.



*  Find a veterinarian: Allow pet owners to locate and connect with licensed

veterinarians in their area.



*  Find a pet sitter: Enable pet owners to discover reliable pet sitters and

dog walkers for in-home or scheduled pet care.



* Pet forums: Establish a dedicated forum section where pet owners can ask

questions, share experiences, and build relationships.



* Lost & Found Pets: Create a database to reunite lost pets with their

worried owners and facilitate faster reunions.

Future iterations may consider expanding the scope to include features like:



* Appointment scheduling with veterinarians and pet sitters.
* Telehealth consultations with veterinarians.
* Online pet stores or marketplaces.
* Integration with wearable pet trackers.

**Class diagram**




<p id="gdcalert1" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: inline image link here (to images/image1.png). Store image on your image server and adjust path/filename/extension if necessary. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert2">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>


![alt_text](images/image1.png "image_tooltip")


**User stories/user characteristics**:

User Characteristics:

Normal User:



* 
Loves their pet


* 
Looks after their pet


* 
Makes posts
Vet User:



* 
Has regular user characteristics


* 
Has contact details listed


* 
Has qualifications listed


* 
Has clinic location listed
 

Pet Caretaker User:



* 
Has regular user characteristics


* 
Has contact details listed


* 
Has pet specialities listed


* 
Has location listed
 User Stories for TailWagger

User Accounts Subsystem

1. As a new user, I want to sign up for an account so that I can access the application's features.

2. As a user, I want to enter my username during sign-up so that I can create a unique identity.

3. As a user, I want to enter my password during sign-up so that my account is secure.

4. As a user, I want to enter my email address during sign-up so that I can receive notifications and account-related information.

5. As a user, I want to fill in my personal details during sign-up so that my profile is complete.

6. As a returning user, I want to log in to my account so that I can access my profile and pets' information.

7. As a returning user, I want to reset my password if I forget it so that I can regain access to my account.

8. As a user, I want to log in with my email and password so that I can access my account securely.

Profile Subsystem

1. As a user, I want to edit my profile photo so that I can personalise my account.

2. As a user, I want to edit my username so that I can update my display name.

3. As a user, I want to edit my personal details so that my profile information is up-to-date.

4. As a user, I want to add a pet profile so that I can keep track of my pets' information.

5. As a user, I want to add my pet's details so that the profile is complete.

6. As a user, I want to delete my profile so that I can remove my account from the system.

7. As a user, I want to be prompted to confirm profile deletion so that I don't accidentally delete my profile.

8. As a user, I want my profile to be deleted from the database so that my information is removed.

9. As a user, I want to delete a pet profile so that I can remove pets that I no longer own.

10. As a user, I want to be prompted to confirm pet profile deletion so that I don't accidentally delete it.

11. As a user, I want my pet profile to be deleted from the database so that the information is removed.

12. As a user, I want to edit my pet's details so that the profile information is up-to-date.

13. As a user, I want to edit my pet's profile photo so that it is personalised.

14. As a vet, I want to edit my profile to include my vet clinic’s details

15. As a pet caretaker, I want to add my details so that pet owners can find and contact me

Location Subsystem

1. As a user, I want to search for found pets so that I can find my lost pet.

2. As a user, I want to enter a pet name during the search so that I can find specific pets.

3. As a user, I want to view search results so that I can see the found pets' information.

4. As a user, I want to find veterinarians around my area so that I can get medical care for my pet.

5. As a user, I want to see the location of the vet clinic so that I can visit it.

6. As a user, I want to see the vet's details so that I can contact them for an appointment.

7. As a user, I want to find pet caretaker details so that I can find someone to take care of my pet.

Forums Subsystem

1. As a user, I  want to create forums so that I can initiate discussions on relevant topics about pets.

2. As a user, I want to like a forum post so that I can show my appreciation for the content.

3. As a user, I want to share a forum post so that I can spread useful information.

4. As a user, I want to comment on a forum post so that I can participate in the discussion.

5. As a user, I want to create forum posts about lost pets.

6. As a vet, I want to post news and events about my clinic.

7. As a vet, I want to create forums about taking care of pets and my clinic.

Notifications Subsystem

1. As a user, I want to receive notifications for new comments on my forum posts so that I can stay updated.

2. As a user, I want to receive notifications for new likes on my forum posts so that I know when others appreciate my content.

3. As a user, I want to receive notifications for new forum posts in categories I'm interested in so that I can stay informed.

4. As a pet caretaker , I want to receive notifications for upcoming appointments with pet owners so that I don't miss them.

5. As a user, I want to edit my notification settings so that I can control what notifications I receive.

**Functional requirements**

1.       User Accounts subsystem:


    1.1.  User must be able to Sign up:


        1.1.1. Enter their name


        1.1.2. User must be able to enter their valid password


        1.1.3. User must be able to enter their valid email address

1.3.  User must be able to login:


        1.3.1. User must be able to reset their password


        1.3.2. User must be able to login with email


        1.3.3. User must be able to login with their password

2.       Profile subsystem:


    2.1.  User must be able to edit their profile:


        2.1.1. 	User must be able to edit their profile photo


        2.1.2.     User must be able to edit their personal details


    2.2.  User must be able to add a pet profile:


        2.2.1.     User must be able to add pet details


        2.2.2.   User must be able to upload pet photos to gallery


    2.3.  User  must be able to delete their profile:


        2.3.1. 	User must be prompted to confirm profile deletion


        2.3.2.     User should be deleted from the database


    2.4.  User must be able to delete a pet profile


        2.4.1. 	User must be prompted to confirm profile deletion


        2.4.2.     User should be deleted from the database

2.5.  User must be able to edit a pet profile:


        2.5.1.    User must be able to edit pet details


        2.5.2.  User must be able to edit pet gallery

	2.6. Vet must be able to become registered

		2.6.1  Vet must be able to upload proof of qualification

		

		2.6.2  Vet must be able to provide contact details

		

		2.6.3  Vet must be able to share clinic location

	

2.7. Pet Caretaker must be able to become registered

		

		2.7.2  Caretaker must be able to provide contact details

		

		2.7.3  Caretaker must be able to share location

	


         

3.       Location subsystem:


    3.1.  User must be able to search for found pets:


        3.1.1. 	User must be able to enter a pet name


        3.1.2.     The user must be able to view search results


    3.2.  User must to able to find Veterinarians around their area:


        3.2.1. 	Users must be able to see the location of the vet clinic


        3.2.2.     Users must be able to see the vet details


    3.3.  Users must be able to find a pet caretaker:


        3.3.1. 	Users must be see pet caretaker details


        3.3.2.     User must be able to see the pet caretaker location

4.       Forums subsystem:


    4.1.  Users must be able to create forum


        4.1.1.     Users must be able to create forums


        4.1.2.     Users must be able to create forums


    4.1.3.     Users must be able to select or create relevant tags to categorise the forum


    4.2.  Users must be able to interact with posts


        4.2.1.     Users must be able to like a post


        4.2.2.     Users must be able to share a post


        4.2.3.     Users must be able to comment on a post

5. Notifications subsystem:

	5.1. Users must be able to receive notifications from their forum posts

		5.1.1. Users must receive notifications if they receive a like on their forum posts

		5.1.2. User must receive notifications if they receive a comment on their forum posts

		5.1.3. Users must receive notifications if their forum post is shared

	

5.2. Users must be able to receive notifications from followed forums


        5.2.1. Users must be able to receive notifications about new comments on forums they follow


        5.2.2 Users must be able to receive notifications for replies on their comments on forums


    5.3 Pet caretakers must receive notifications of users interested in their services


    	


    	5.3.1  Pet caretakers must receive notifications of users requesting their service


    	5.3.2  Pet caretakers must receive notifications of upcoming appointments with user 


     	          pets

**Use Case diagrams:**


    

<p id="gdcalert2" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: inline image link here (to images/image2.jpg). Store image on your image server and adjust path/filename/extension if necessary. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert3">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>


![alt_text](images/image2.jpg "image_tooltip")